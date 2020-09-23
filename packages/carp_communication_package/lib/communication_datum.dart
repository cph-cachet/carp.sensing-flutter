/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// Holds a list of text (SMS) messages from the device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TextMessageLogDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, CommunicationSamplingPackage.TEXT_MESSAGE_LOG);
  DataFormat get format => CARP_DATA_FORMAT;

  List<TextMessage> textMessageLog;

  TextMessageLogDatum({this.textMessageLog}) : super() {
    textMessageLog ??= List<TextMessage>();
  }

  factory TextMessageLogDatum.fromJson(Map<String, dynamic> json) => _$TextMessageLogDatumFromJson(json);
  Map<String, dynamic> toJson() => _$TextMessageLogDatumToJson(this);

  String toString() => super.toString() + ', size: ${textMessageLog.length}';
}

/// Holds a single text (SMS) message as a [Datum] object.
///
/// Wraps a [TextMessage].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TextMessageDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, CommunicationSamplingPackage.TEXT_MESSAGE);
  DataFormat get format => CARP_DATA_FORMAT;

  TextMessage textMessage;

  TextMessageDatum() : super();
  factory TextMessageDatum.fromTextMessage(TextMessage msg) => TextMessageDatum()..textMessage = msg;

  factory TextMessageDatum.fromJson(Map<String, dynamic> json) => _$TextMessageDatumFromJson(json);
  Map<String, dynamic> toJson() => _$TextMessageDatumToJson(this);

  String toString() => super.toString() + ', textMessage: $textMessage';
}

/// Holds a text messages (SMS).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class TextMessage {
  int id;

  /// The receiver address of this message
  String address;

  /// The text body of this message.
  String body;

  /// The size in bytes of the body of the message.
  int size;
  bool isRead;

  /// The date this message was created.
  DateTime date;

  /// The date this message was sent.
  DateTime dateSent;

  /// The kind of message:
  ///  - draft
  ///  - received
  ///  - sent
  String kind;

  /// The state of the message:
  ///  - delivered
  ///  - fail
  ///  - none
  ///  - sending
  ///  - sent
  String state;

  TextMessage({this.id, this.address, this.body, this.isRead, this.date, this.dateSent, this.kind, this.state})
      : super();

  factory TextMessage.fromSmsMessage(SmsMessage sms) {
    TextMessage msg = new TextMessage(
        id: sms.id, address: sms.address, body: sms.body, isRead: sms.isRead, date: sms.date, dateSent: sms.dateSent);

    if (sms.body != null) msg.size = sms.body.length;

    switch (sms.kind) {
      case SmsMessageKind.Sent:
        msg.kind = 'sent';
        break;
      case SmsMessageKind.Received:
        msg.kind = 'received';
        break;
      case SmsMessageKind.Draft:
        msg.kind = 'draft';
        break;
    }

    switch (sms.state) {
      case SmsMessageState.Delivered:
        msg.state = 'delivered';
        break;
      case SmsMessageState.Fail:
        msg.state = 'fail';
        break;
      case SmsMessageState.None:
        msg.state = 'none';
        break;
      case SmsMessageState.Sending:
        msg.state = 'sending';
        break;
      case SmsMessageState.Sent:
        msg.state = 'sent';
        break;
    }

    return msg;
  }

  factory TextMessage.fromJson(Map<String, dynamic> json) => _$TextMessageFromJson(json);
  Map<String, dynamic> toJson() => _$TextMessageToJson(this);

  String toString() =>
      "Text Message - id: $id, address: $address, is_read: $isRead, date: $date, date_send: $dateSent, kind: $kind, state: $state\n$body";
}

/// Holds a phone log, i.e. a list of phone calls made on the device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhoneLogDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, CommunicationSamplingPackage.PHONE_LOG);
  DataFormat get format => CARP_DATA_FORMAT;

  List<PhoneCall> phoneLog = new List<PhoneCall>();

  PhoneLogDatum() : super();

  factory PhoneLogDatum.fromJson(Map<String, dynamic> json) => _$PhoneLogDatumFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneLogDatumToJson(this);

  String toString() => super.toString() + "size: ${phoneLog.length}";
}

/// Phone call data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PhoneCall {
  /// Date & Time of the call.
  DateTime timestamp;

  /// Type of call:
  ///  - answered
  ///  - incoming
  ///  - blocked
  ///  - missed
  ///  - outgoing
  ///  - rejected
  ///  - voice_mail
  String callType;

  /// Duration of call in ms.
  int duration;

  /// The formatted version of the phone number (if available).
  String formattedNumber;

  /// The phone number
  String number;

  /// The name of the caller (if available).
  String name;

  PhoneCall([this.timestamp, this.callType, this.duration, this.formattedNumber, this.number, this.name]);

  factory PhoneCall.fromCallLogEntry(CallLogEntry call) {
    DateTime timestamp = DateTime.fromMicrosecondsSinceEpoch(call.timestamp);
    String type = "unknown";

    switch (call.callType) {
      case CallType.answeredExternally:
        type = 'answered_externally';
        break;
      case CallType.blocked:
        type = 'blocked';
        break;
      case CallType.incoming:
        type = 'incoming';
        break;
      case CallType.missed:
        type = 'missed';
        break;
      case CallType.outgoing:
        type = 'outgoing';
        break;
      case CallType.rejected:
        type = 'rejected';
        break;
      case CallType.voiceMail:
        type = 'voice_mail';
        break;
      default:
        type = "unknown";
        break;
    }

    return PhoneCall(timestamp, type, call.duration, call.formattedNumber, call.number, call.name);
  }

  factory PhoneCall.fromJson(Map<String, dynamic> json) => _$PhoneCallFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneCallToJson(this);

  String toString() =>
      "Phone Call - timestamp: $timestamp, call_type: $callType, duration: $duration, number: $number, formatted_number: $formattedNumber, name: $name";
}

/// Holds a list of calendar events from the device.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CalendarDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, CommunicationSamplingPackage.CALENDAR);
  DataFormat get format => CARP_DATA_FORMAT;

  List<CalendarEvent> calendarEvents = new List<CalendarEvent>();

  CalendarDatum() : super();

  factory CalendarDatum.fromJson(Map<String, dynamic> json) => _$CalendarDatumFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarDatumToJson(this);

  String toString() => super.toString() + ', size: ${calendarEvents.length}';
}

/// A calendar event.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CalendarEvent {
  /// The unique identifier for this event
  String eventId;

  /// The identifier of the calendar that this event is associated with
  String calendarId;

  /// The title of this event
  String title;

  /// The description for this event
  String description;

  /// Indicates when the event starts
  DateTime start;

  /// Indicates when the event ends
  DateTime end;

  /// Indicates if this is an all-day event
  bool allDay;

  /// The location of this event
  String location;

  /// A list of attendees' name for this event
  List<String> attendees;

  CalendarEvent(
      [this.eventId,
      this.calendarId,
      this.title,
      this.description,
      this.start,
      this.end,
      this.allDay,
      this.location,
      this.attendees]);

  factory CalendarEvent.fromEvent(Event event) {
    return CalendarEvent(event.eventId, event.calendarId, event.title, event.description, event.start.toUtc(),
        event.end.toUtc(), event.allDay, event.location, event.attendees.map((attendees) => attendees.name).toList());
  }

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => _$CalendarEventFromJson(json);
  Map<String, dynamic> toJson() => _$CalendarEventToJson(this);

  String toString() =>
      "Calendar Event - eventId: $eventId, calendarId: $calendarId, title: $title, description: $description, start: $start, end: $end, all day: $allDay, location: $location, no. attendees: ${attendees.length}";
}
