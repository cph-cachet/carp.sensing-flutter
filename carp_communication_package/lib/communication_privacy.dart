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
TextMessage text_message_anoymizer(TextMessage msg) {
  msg.address = sha1.convert(utf8.encode(msg.address)).toString();
  msg.body = sha1.convert(utf8.encode(msg.body)).toString();

  return msg;
}

/// A [TextMessageDatum] anonymizer function. Anonymizes the [TextMessage]
/// using the [text_message_anoymizer] function.
Datum text_message_datum_anoymizer(Datum datum) {
  assert(datum is TextMessageDatum);
  TextMessageDatum msg = datum as TextMessageDatum;
  return msg..textMessage = text_message_anoymizer(msg.textMessage);
}

/// A [TextMessageLogDatum] anonymizer function. Anonymizes each [TextMessageDatum]
/// entry in the log using the [text_message_anoymizer] function.
Datum text_message_log_anoymizer(Datum datum) {
  assert(datum is TextMessageLogDatum);
  TextMessageLogDatum log = datum as TextMessageLogDatum;
  log.textMessageLog.forEach((msg) => text_message_anoymizer(msg));
  return log;
}

/// A [PhoneLogDatum] anonymizer function. Anonymizes each [PhoneCall]
/// entry in the log using the [phone_call_anoymizer] function.
Datum phone_log_anoymizer(Datum datum) {
  assert(datum is PhoneLogDatum);
  PhoneLogDatum log = datum as PhoneLogDatum;
  log.phoneLog.forEach((call) => phone_call_anoymizer(call));
  return log;
}

/// A [PhoneCall] anonymizer function. Anonymizes:
///  - formattedNumber
///  - number
///  - name
PhoneCall phone_call_anoymizer(PhoneCall call) {
  call.formattedNumber = sha1.convert(utf8.encode(call.formattedNumber)).toString();
  call.number = sha1.convert(utf8.encode(call.number)).toString();
  call.name = sha1.convert(utf8.encode(call.name)).toString();

  return call;
}

/// A [CalendarDatum] anonymizer function. Anonymizes each [CalendarEvent]
/// entry in the calendar using the [calendar_event_anoymizer] function.
Datum calendar_anoymizer(Datum datum) {
  assert(datum is CalendarDatum);
  CalendarDatum calendar = datum as CalendarDatum;
  calendar.calendarEvents.forEach((event) => calendar_event_anoymizer(event));
  return calendar;
}

/// A [CalendarEvent] anonymizer function. Anonymizes:
///  - title
///  - description
///  - names of all attendees
CalendarEvent calendar_event_anoymizer(CalendarEvent event) {
  event.title = sha1.convert(utf8.encode(event.title)).toString();
  event.description = sha1.convert(utf8.encode(event.description)).toString();
  event.attendees = event.attendees.map((name) => sha1.convert(utf8.encode(name)).toString()).toList();

  return event;
}
