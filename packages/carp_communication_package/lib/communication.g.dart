// GENERATED CODE - DO NOT MODIFY BY HAND

part of communication;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessageLogDatum _$TextMessageLogDatumFromJson(Map<String, dynamic> json) {
  return TextMessageLogDatum()
    ..id = json['id'] as String?
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..textMessageLog = (json['text_message_log'] as List<dynamic>)
        .map((e) => TextMessage.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$TextMessageLogDatumToJson(TextMessageLogDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  val['text_message_log'] = instance.textMessageLog;
  return val;
}

TextMessageDatum _$TextMessageDatumFromJson(Map<String, dynamic> json) {
  return TextMessageDatum()
    ..id = json['id'] as String?
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..textMessage = json['text_message'] == null
        ? null
        : TextMessage.fromJson(json['text_message'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TextMessageDatumToJson(TextMessageDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('text_message', instance.textMessage);
  return val;
}

TextMessage _$TextMessageFromJson(Map<String, dynamic> json) {
  return TextMessage(
    id: json['id'] as int?,
    address: json['address'] as String?,
    body: json['body'] as String?,
    size: json['size'] as int?,
    read: json['read'] as bool?,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    dateSent: json['date_sent'] == null
        ? null
        : DateTime.parse(json['date_sent'] as String),
    type: _$enumDecodeNullable(_$SmsTypeEnumMap, json['type']),
    status: _$enumDecodeNullable(_$SmsStatusEnumMap, json['status']),
  );
}

Map<String, dynamic> _$TextMessageToJson(TextMessage instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('address', instance.address);
  writeNotNull('body', instance.body);
  writeNotNull('size', instance.size);
  writeNotNull('read', instance.read);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('date_sent', instance.dateSent?.toIso8601String());
  writeNotNull('type', _$SmsTypeEnumMap[instance.type]);
  writeNotNull('status', _$SmsStatusEnumMap[instance.status]);
  return val;
}

K _$enumDecode<K, V>(
  Map<K, V> enumValues,
  Object? source, {
  K? unknownValue,
}) {
  if (source == null) {
    throw ArgumentError(
      'A value must be provided. Supported values: '
      '${enumValues.values.join(', ')}',
    );
  }

  return enumValues.entries.singleWhere(
    (e) => e.value == source,
    orElse: () {
      if (unknownValue == null) {
        throw ArgumentError(
          '`$source` is not one of the supported values: '
          '${enumValues.values.join(', ')}',
        );
      }
      return MapEntry(unknownValue, enumValues.values.first);
    },
  ).key;
}

K? _$enumDecodeNullable<K, V>(
  Map<K, V> enumValues,
  dynamic source, {
  K? unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<K, V>(enumValues, source, unknownValue: unknownValue);
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

PhoneLogDatum _$PhoneLogDatumFromJson(Map<String, dynamic> json) {
  return PhoneLogDatum()
    ..id = json['id'] as String?
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..phoneLog = (json['phone_log'] as List<dynamic>)
        .map((e) => PhoneCall.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$PhoneLogDatumToJson(PhoneLogDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  val['phone_log'] = instance.phoneLog;
  return val;
}

PhoneCall _$PhoneCallFromJson(Map<String, dynamic> json) {
  return PhoneCall(
    json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    json['call_type'] as String?,
    json['duration'] as int?,
    json['formatted_number'] as String?,
    json['number'] as String?,
    json['name'] as String?,
  );
}

Map<String, dynamic> _$PhoneCallToJson(PhoneCall instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('call_type', instance.callType);
  writeNotNull('duration', instance.duration);
  writeNotNull('formatted_number', instance.formattedNumber);
  writeNotNull('number', instance.number);
  writeNotNull('name', instance.name);
  return val;
}

CalendarDatum _$CalendarDatumFromJson(Map<String, dynamic> json) {
  return CalendarDatum()
    ..id = json['id'] as String?
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..calendarEvents = (json['calendar_events'] as List<dynamic>)
        .map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>))
        .toList();
}

Map<String, dynamic> _$CalendarDatumToJson(CalendarDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  val['calendar_events'] = instance.calendarEvents;
  return val;
}

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) {
  return CalendarEvent(
    json['event_id'] as String?,
    json['calendar_id'] as String?,
    json['title'] as String?,
    json['description'] as String?,
    json['start'] == null ? null : DateTime.parse(json['start'] as String),
    json['end'] == null ? null : DateTime.parse(json['end'] as String),
    json['all_day'] as bool?,
    json['location'] as String?,
    (json['attendees'] as List<dynamic>?)?.map((e) => e as String?).toList(),
  );
}

Map<String, dynamic> _$CalendarEventToJson(CalendarEvent instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('event_id', instance.eventId);
  writeNotNull('calendar_id', instance.calendarId);
  writeNotNull('title', instance.title);
  writeNotNull('description', instance.description);
  writeNotNull('start', instance.start?.toIso8601String());
  writeNotNull('end', instance.end?.toIso8601String());
  writeNotNull('all_day', instance.allDay);
  writeNotNull('location', instance.location);
  writeNotNull('attendees', instance.attendees);
  return val;
}

CalendarMeasure _$CalendarMeasureFromJson(Map<String, dynamic> json) {
  return CalendarMeasure(
    type: json['type'] as String,
    name: json['name'] as String?,
    description: json['description'] as String?,
    enabled: json['enabled'],
    past: Duration(microseconds: json['past'] as int),
    future: Duration(microseconds: json['future'] as int),
  )
    ..$type = json[r'$type'] as String?
    ..configuration = Map<String, String>.from(json['configuration'] as Map);
}

Map<String, dynamic> _$CalendarMeasureToJson(CalendarMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  val['type'] = instance.type;
  writeNotNull('name', instance.name);
  writeNotNull('description', instance.description);
  val['enabled'] = instance.enabled;
  val['configuration'] = instance.configuration;
  val['past'] = instance.past.inMicroseconds;
  val['future'] = instance.future.inMicroseconds;
  return val;
}
