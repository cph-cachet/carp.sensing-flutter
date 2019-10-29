/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// A probe that collects the phone log from this device on a regular basis (e.g. once pr. hour).
class PhoneLogProbe extends DatumProbe {
  Future<Datum> getDatum() async {
    int days = (measure as PhoneLogMeasure).days;
    Iterable<CallLogEntry> entries;
    if ((days == null) || (days == -1)) {
      entries = await CallLog.get();
    } else {
      var now = DateTime.now();
      int from = now.subtract(Duration(days: days)).millisecondsSinceEpoch;
      int to = now.millisecondsSinceEpoch;
      entries = await CallLog.query(dateFrom: from, dateTo: to);
    }

    return PhoneLogDatum()..phoneLog = entries.map((call) => PhoneCall.fromCallLogEntry(call)).toList();
  }
}

/// A probe that collects a complete list of all text (SMS) messages from this device.
class TextMessageLogProbe extends DatumProbe {
  Future<Datum> getDatum() async {
    SmsQuery query = new SmsQuery();
    List<SmsMessage> _messages = await query.getAllSms;
    return TextMessageLogDatum()..textMessageLog = _messages.map((sms) => TextMessage.fromSmsMessage(sms)).toList();
  }
}

/// The [TextMessageProbe] listens to SMS messages and collects a
/// [TextMessageDatum] every time a new SMS message is received.
class TextMessageProbe extends StreamProbe {
  Stream<Datum> get stream =>
      SmsReceiver().onSmsReceived.map((event) => TextMessageDatum.fromTextMessage(TextMessage.fromSmsMessage(event)));
}

/// A probe collecting calendar entries from the calendar on the phone.
///
/// See [CalendarMeasure] for how to configure this probe's measure.
class CalendarProbe extends DatumProbe {
  DeviceCalendarPlugin _deviceCalendar = DeviceCalendarPlugin();
  List<Calendar> _calendars;
  Iterator<Calendar> _calendarIterator;
  List<CalendarEvent> _events = [];

  Future<void> onInitialize(Measure measure) async {
    assert(measure is CalendarMeasure);
    super.onInitialize(measure);
    _retrieveCalendars();
  }

  Future<void> _retrieveCalendars() async {
    // try to get permission to access calendar
    var permissionsGranted = await _deviceCalendar.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data) {
      permissionsGranted = await _deviceCalendar.requestPermissions();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
        return;
      }
    }

    final calendarsResult = await _deviceCalendar.retrieveCalendars();
    _calendars = calendarsResult?.data;

    print('_calendar : $_calendars');
  }

  /// Collects events from the [calendar].
  Future<void> _retrieveEvents(Calendar calendar) async {
    final startDate = new DateTime.now().subtract(new Duration(days: (measure as CalendarMeasure).daysBack));
    final endDate = new DateTime.now().add(new Duration(days: (measure as CalendarMeasure).daysFuture));

    var _calendarEventsResult =
        await _deviceCalendar.retrieveEvents(calendar.id, RetrieveEventsParams(startDate: startDate, endDate: endDate));
    List<Event> _calendarEvents = _calendarEventsResult?.data;
    if (_calendarEvents != null) _calendarEvents.forEach((event) => _events.add(CalendarEvent.fromEvent(event)));

    // recursively collect events from the next calendar in the iterator
    if (_calendarIterator.moveNext()) await _retrieveEvents(_calendarIterator.current);
  }

  /// Get the [CalendarDatum].
  Future<Datum> getDatum() async {
    if (_calendars == null) await _retrieveCalendars();
    if (_calendars != null) {
      _events = [];
      _calendarIterator = _calendars.iterator;

      if (_calendarIterator.moveNext()) await _retrieveEvents(_calendarIterator.current);

      return CalendarDatum()..calendarEvents = _events;
    } else {
      return ErrorDatum('Permission to collect calendar entries not granted.');
    }
  }
}
