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
TextMessage textMessageAnoymizer(TextMessage msg) {
  if (msg.address != null) {
    msg.address = sha1.convert(utf8.encode(msg.address!)).toString();
  }
  if (msg.body != null) {
    msg.body = sha1.convert(utf8.encode(msg.body!)).toString();
  }

  return msg;
}

/// A [TextMessageDatum] anonymizer function. Anonymizes the [TextMessage]
/// using the [textMessageAnoymizer] function.
Datum textMessageDatumAnoymizer(Datum datum) {
  assert(datum is TextMessageDatum);
  TextMessageDatum msg = datum as TextMessageDatum;
  return msg..textMessage = textMessageAnoymizer(msg.textMessage!);
}

/// A [TextMessageLogDatum] anonymizer function. Anonymizes each [TextMessageDatum]
/// entry in the log using the [textMessageAnoymizer] function.
Datum textMessageLogAnoymizer(Datum datum) {
  assert(datum is TextMessageLogDatum);
  TextMessageLogDatum log = datum as TextMessageLogDatum;
  for (var msg in log.textMessageLog) {
    textMessageAnoymizer(msg);
  }
  return log;
}

/// A [PhoneLogDatum] anonymizer function. Anonymizes each [PhoneCall]
/// entry in the log using the [phoneCallAnoymizer] function.
Datum phoneLogAnoymizer(Datum datum) {
  assert(datum is PhoneLogDatum);
  PhoneLogDatum log = datum as PhoneLogDatum;
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

/// A [CalendarDatum] anonymizer function. Anonymizes each [CalendarEvent]
/// entry in the calendar using the [calendarEventAnoymizer] function.
Datum calendarAnoymizer(Datum datum) {
  assert(datum is CalendarDatum);
  CalendarDatum calendar = datum as CalendarDatum;
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
