// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessageLog _$TextMessageLogFromJson(Map<String, dynamic> json) =>
    TextMessageLog(
      (json['textMessageLog'] as List<dynamic>?)
              ?.map((e) => TextMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$TextMessageLogToJson(TextMessageLog instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['textMessageLog'] =
      instance.textMessageLog.map((e) => e.toJson()).toList();
  return val;
}

TextMessage _$TextMessageFromJson(Map<String, dynamic> json) => TextMessage(
      id: (json['id'] as num?)?.toInt(),
      address: json['address'] as String?,
      body: json['body'] as String?,
      size: (json['size'] as num?)?.toInt(),
      read: json['read'] as bool?,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      dateSent: json['dateSent'] == null
          ? null
          : DateTime.parse(json['dateSent'] as String),
      type: $enumDecodeNullable(_$SmsTypeEnumMap, json['type']),
      status: $enumDecodeNullable(_$SmsStatusEnumMap, json['status']),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$TextMessageToJson(TextMessage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('id', instance.id);
  writeNotNull('address', instance.address);
  writeNotNull('body', instance.body);
  writeNotNull('size', instance.size);
  writeNotNull('read', instance.read);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('dateSent', instance.dateSent?.toIso8601String());
  writeNotNull('type', _$SmsTypeEnumMap[instance.type]);
  writeNotNull('status', _$SmsStatusEnumMap[instance.status]);
  return val;
}

const _$SmsTypeEnumMap = {
  SmsType.MESSAGE_TYPE_ALL: 'MESSAGE_TYPE_ALL',
  SmsType.MESSAGE_TYPE_INBOX: 'MESSAGE_TYPE_INBOX',
  SmsType.MESSAGE_TYPE_SENT: 'MESSAGE_TYPE_SENT',
  SmsType.MESSAGE_TYPE_DRAFT: 'MESSAGE_TYPE_DRAFT',
  SmsType.MESSAGE_TYPE_OUTBOX: 'MESSAGE_TYPE_OUTBOX',
  SmsType.MESSAGE_TYPE_FAILED: 'MESSAGE_TYPE_FAILED',
  SmsType.MESSAGE_TYPE_QUEUED: 'MESSAGE_TYPE_QUEUED',
};

const _$SmsStatusEnumMap = {
  SmsStatus.STATUS_COMPLETE: 'STATUS_COMPLETE',
  SmsStatus.STATUS_FAILED: 'STATUS_FAILED',
  SmsStatus.STATUS_NONE: 'STATUS_NONE',
  SmsStatus.STATUS_PENDING: 'STATUS_PENDING',
};

PhoneLog _$PhoneLogFromJson(Map<String, dynamic> json) => PhoneLog(
      DateTime.parse(json['start'] as String),
      DateTime.parse(json['end'] as String),
      (json['phoneLog'] as List<dynamic>?)
              ?.map((e) => PhoneCall.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$PhoneLogToJson(PhoneLog instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['start'] = instance.start.toIso8601String();
  val['end'] = instance.end.toIso8601String();
  val['phoneLog'] = instance.phoneLog.map((e) => e.toJson()).toList();
  return val;
}

PhoneCall _$PhoneCallFromJson(Map<String, dynamic> json) => PhoneCall(
      json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      json['callType'] as String?,
      (json['duration'] as num?)?.toInt(),
      json['formattedNumber'] as String?,
      json['number'] as String?,
      json['name'] as String?,
    );

Map<String, dynamic> _$PhoneCallToJson(PhoneCall instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('callType', instance.callType);
  writeNotNull('duration', instance.duration);
  writeNotNull('formattedNumber', instance.formattedNumber);
  writeNotNull('number', instance.number);
  writeNotNull('name', instance.name);
  return val;
}

Calendar _$CalendarFromJson(Map<String, dynamic> json) => Calendar(
      DateTime.parse(json['start'] as String),
      DateTime.parse(json['end'] as String),
      (json['calendarEvents'] as List<dynamic>?)
              ?.map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$CalendarToJson(Calendar instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['calendarEvents'] =
      instance.calendarEvents.map((e) => e.toJson()).toList();
  val['start'] = instance.start.toIso8601String();
  val['end'] = instance.end.toIso8601String();
  return val;
}

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) =>
    CalendarEvent(
      json['eventId'] as String?,
      json['calendarId'] as String?,
      json['title'] as String?,
      json['description'] as String?,
      json['start'] == null ? null : DateTime.parse(json['start'] as String),
      json['end'] == null ? null : DateTime.parse(json['end'] as String),
      json['allDay'] as bool?,
      json['location'] as String?,
      (json['attendees'] as List<dynamic>?)?.map((e) => e as String?).toList(),
    );

Map<String, dynamic> _$CalendarEventToJson(CalendarEvent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('eventId', instance.eventId);
  writeNotNull('calendarId', instance.calendarId);
  writeNotNull('title', instance.title);
  writeNotNull('description', instance.description);
  writeNotNull('start', instance.start?.toIso8601String());
  writeNotNull('end', instance.end?.toIso8601String());
  writeNotNull('allDay', instance.allDay);
  writeNotNull('location', instance.location);
  writeNotNull('attendees', instance.attendees);
  return val;
}
