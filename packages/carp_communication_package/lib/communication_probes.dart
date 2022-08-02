/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// A probe that collects the phone log from this device.
///
/// Only works on Android.
class PhoneLogProbe extends DatumProbe {
  @override
  Future<Datum> getDatum() async {
    HistoricSamplingConfiguration m =
        (samplingConfiguration as HistoricSamplingConfiguration);
    int from = (m.lastTime != null)
        ? m.lastTime!.millisecondsSinceEpoch
        : DateTime.now().subtract(m.past).millisecondsSinceEpoch;
    int now = DateTime.now().millisecondsSinceEpoch;
    Iterable<CallLogEntry> entries =
        await CallLog.query(dateFrom: from, dateTo: now);
    return PhoneLogDatum()
      ..phoneLog =
          entries.map((call) => PhoneCall.fromCallLogEntry(call)).toList();
  }
}

/// A probe that collects a complete list of all text (SMS) messages from
/// this device. Combines both send and recieved messages.
///
/// Only works on Android.
class TextMessageLogProbe extends DatumProbe {
  SmsColumn? col;
  static const List<SmsColumn> ALL_SMS_COLUMNS = [
    SmsColumn.ADDRESS,
    SmsColumn.BODY,
    SmsColumn.DATE,
    SmsColumn.DATE_SENT,
    SmsColumn.ID,
    SmsColumn.READ,
    SmsColumn.SEEN,
    SmsColumn.STATUS,
    SmsColumn.SUBJECT,
    SmsColumn.SUBSCRIPTION_ID,
    SmsColumn.TYPE,
  ];

  @override
  Future<Datum> getDatum() async {
    List<SmsMessage> allSms = [];
    allSms
      ..addAll(await Telephony.instance.getInboxSms(
        columns: ALL_SMS_COLUMNS,
      ))
      ..addAll(await Telephony.instance.getSentSms(
        columns: ALL_SMS_COLUMNS,
      ));
    return TextMessageLogDatum()
      ..textMessageLog =
          allSms.map((sms) => TextMessage.fromSmsMessage(sms)).toList();
  }
}

// A private stream controller to be used in the call-back from the SMS probe.
StreamController<Datum> _textMessageProbeController =
    StreamController.broadcast();

/// The top-level call-back method for handling in-coming SMS messages when
/// the app is in the background.
void backgrounMessageHandler(SmsMessage message) async {
  _textMessageProbeController.add(
      TextMessageDatum.fromTextMessage(TextMessage.fromSmsMessage(message)));
}

/// The [TextMessageProbe] listens to SMS messages and collects a
/// [TextMessageDatum] every time a new SMS message is received.
///
/// Only works on Android.
class TextMessageProbe extends StreamProbe {
  @override
  Stream<Datum> get stream => _textMessageProbeController.stream;

  @override
  void onInitialize() {
    if (!Platform.isAndroid) {
      throw SensingException('TextMessageProbe only available on Android.');
    }

    Telephony.instance.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        _textMessageProbeController.add(TextMessageDatum.fromTextMessage(
            TextMessage.fromSmsMessage(message)));
      },
      onBackgroundMessage: backgrounMessageHandler,
    );
  }
}

/// A probe collecting calendar entries from the calendar on the phone.
///
/// See [CalendarMeasure] for how to configure this probe's measure.
class CalendarProbe extends DatumProbe {
  final DeviceCalendarPlugin _deviceCalendar = DeviceCalendarPlugin();
  List<Calendar>? _calendars;
  late Iterator<Calendar> _calendarIterator;
  List<CalendarEvent> _events = [];

  @override
  void onInitialize() {
    _retrieveCalendars();
  }

  Future<bool> _retrieveCalendars() async {
    // try to get permission to access calendar
    var permissionsGranted = await _deviceCalendar.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
      permissionsGranted = await _deviceCalendar.requestPermissions();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
        return false;
      }
    }

    final calendarsResult = await _deviceCalendar.retrieveCalendars();
    _calendars = calendarsResult.data;
    return true;
  }

  @override
  HistoricSamplingConfiguration get samplingConfiguration =>
      super.samplingConfiguration as HistoricSamplingConfiguration;

  // Collects events from the [calendar].
  Future<bool> _retrieveEvents(Calendar calendar) async {
    final startDate = DateTime.now().subtract(samplingConfiguration.past);
    final endDate = DateTime.now().add(samplingConfiguration.future);

    var calendarEventsResult = await _deviceCalendar.retrieveEvents(calendar.id,
        RetrieveEventsParams(startDate: startDate, endDate: endDate));
    List<Event>? calendarEvents = calendarEventsResult.data;
    if (calendarEvents != null) {
      for (var event in calendarEvents) {
        _events.add(CalendarEvent.fromEvent(event));
      }
    } else {
      return false;
    }

    // recursively collect events from the next calendar in the iterator
    if (_calendarIterator.moveNext()) {
      return await _retrieveEvents(_calendarIterator.current);
    }

    return true;
  }

  /// Get the [CalendarDatum].
  @override
  Future<Datum> getDatum() async {
    if (_calendars == null) await _retrieveCalendars();

    if (_calendars != null) {
      _events = [];
      _calendarIterator = _calendars!.iterator;

      if (_calendarIterator.moveNext()) {
        await _retrieveEvents(_calendarIterator.current);
      }

      return CalendarDatum()..calendarEvents = _events;
    } else {
      return ErrorDatum('Permission to collect calendar entries not granted.');
    }
  }
}
