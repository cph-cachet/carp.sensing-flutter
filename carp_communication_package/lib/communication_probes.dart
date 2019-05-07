/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// A probe that collects the phone log from this device on a regular basis (e.g. once pr. day).
class PhoneLogProbe extends PeriodicDatumProbe {
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

//    PhoneLogDatum pld = new PhoneLogDatum();
//    for (CallLogEntry call in entries ?? []) {
//      pld.phoneLog.add(PhoneCall.fromCallLogEntry(call));
//    }
//
//    return pld;
  }
}

/// A probe that collects a complete list of all text (SMS) messages from this device.
///
/// This probe only collects the list of SMS messages once.
/// If you want to listen to text messages being received,
/// use a [TextMessageProbe] instead.
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
class CalendarProbe extends PeriodicDatumProbe {
  DeviceCalendarPlugin _deviceCalendar = DeviceCalendarPlugin();
  List<Calendar> _calendars;

  void onInitialize(Measure measure) {
    assert(measure is CalendarMeasure);
    super.onInitialize(measure);
    _retrieveCalendars();
  }

  Future<void> _retrieveCalendars() async {
    print('_retrieveCalendars() #0');
    // try to get permission to access calendar
    try {
      var permissionsGranted = await _deviceCalendar.hasPermissions();
      print('_retrieveCalendars() #0.1 - ${permissionsGranted.data}');
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendar.requestPermissions();
        print('_retrieveCalendars() #0.2 - ${permissionsGranted.data}');
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          print('_retrieveCalendars() #0.3 - ${permissionsGranted.data}');
          return;
        }
      }

      print('_retrieveCalendars() #1');
      final calendarsResult = await _deviceCalendar.retrieveCalendars();
      _calendars = calendarsResult?.data;
      print('_retrieveCalendars() - $_calendars');
    } catch (e) {
      print(e);
    }
  }

  Future<Datum> getDatum() async {
    print('getDatum() - $_calendars');
    //if (_calendars == null) await _retrieveCalendars();
    //print('getDatum() - $_calendars');

    if (_calendars != null) {
      print('getDatum() #2 - $_calendars');
      final startDate = new DateTime.now().subtract(new Duration(days: (measure as CalendarMeasure).daysBack));
      final endDate = new DateTime.now().add(new Duration(days: (measure as CalendarMeasure).daysFuture));

      _calendars.forEach((calendar) async {
        print('cal - ${calendar.name}');
        var calendarEventsResult = await _deviceCalendar.retrieveEvents(
            calendar.id, RetrieveEventsParams(startDate: startDate, endDate: endDate));
        print('event #1 - ${calendarEventsResult}');
        List<Event> _calendarEvents = calendarEventsResult?.data;
        print('event #2 - ${_calendarEvents}');
        if (_calendarEvents != null) {
          print('event #3 - ${_calendarEvents.length}');

          List<CalendarEvent> _events = new List<CalendarEvent>();
          _calendarEvents.forEach((event) => _events.add(CalendarEvent.fromEvent(event)));

          print('_events : $_events');
          CalendarDatum cd = CalendarDatum();
          cd..calendarEvents = _events;
          print('cd - $cd');
          return cd;
        }
      });
    } else {
      return ErrorDatum('Could not retrieve calendar entries');
    }
  }
}
