/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// A [TextMessage] anonymizer function. Anonymizes:
///  - address
///  - body
TextMessage textMessageAnoymizer(Data data) {
  assert(data is TextMessage);
  var msg = data as TextMessage;
  if (msg.address != null) {
    msg.address = sha1.convert(utf8.encode(msg.address!)).toString();
  }
  if (msg.body != null) {
    msg.body = sha1.convert(utf8.encode(msg.body!)).toString();
  }

  return msg;
}

/// A [TextMessageLog] anonymizer function. Anonymizes each [TextMessageDatum]
/// entry in the log using the [textMessageAnoymizer] function.
Data textMessageLogAnoymizer(Data datum) {
  assert(datum is TextMessageLog);
  TextMessageLog log = datum as TextMessageLog;
  for (var msg in log.textMessageLog) {
    textMessageAnoymizer(msg);
  }
  return log;
}

/// A [PhoneLog] anonymizer function. Anonymizes each [PhoneCall]
/// entry in the log using the [phoneCallAnoymizer] function.
Data phoneLogAnoymizer(Data data) {
  assert(data is PhoneLog);
  PhoneLog log = data as PhoneLog;
  for (var call in log.phoneLog) {
    phoneCallAnoymizer(call);
  }
  return log;
}

/// A [PhoneCall] anonymizer function. Anonymizes:
///  - formattedNumber
///  - number
///  - name
PhoneCall phoneCallAnoymizer(PhoneCall call) {
  if (call.formattedNumber != null) {
    call.formattedNumber =
        sha1.convert(utf8.encode(call.formattedNumber!)).toString();
  }
  if (call.number != null) {
    call.number = sha1.convert(utf8.encode(call.number!)).toString();
  }
  if (call.name != null) {
    call.name = sha1.convert(utf8.encode(call.name!)).toString();
  }

  return call;
}

/// A [Calendar] anonymizer function. Anonymizes each [CalendarEvent]
/// entry in the calendar using the [calendarEventAnoymizer] function.
Data calendarAnoymizer(Data data) {
  assert(data is Calendar);
  Calendar calendar = data as Calendar;
  for (var event in calendar.calendarEvents) {
    calendarEventAnoymizer(event);
  }
  return calendar;
}

/// A [CalendarEvent] anonymizer function. Anonymizes:
///  - title
///  - description
///  - names of all attendees
CalendarEvent calendarEventAnoymizer(CalendarEvent event) {
  if (event.title != null) {
    event.title = sha1.convert(utf8.encode(event.title!)).toString();
  }
  if (event.description != null) {
    event.description =
        sha1.convert(utf8.encode(event.description!)).toString();
  }
  if (event.attendees != null) {
    event.attendees = event.attendees!
        .map((name) => sha1.convert(utf8.encode(name!)).toString())
        .toList();
  }

  return event;
}
