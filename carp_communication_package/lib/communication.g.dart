// GENERATED CODE - DO NOT MODIFY BY HAND

part of communication;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessageLogDatum _$TextMessageLogDatumFromJson(Map<String, dynamic> json) {
  return TextMessageLogDatum(
    textMessageLog: (json['text_message_log'] as List)
        ?.map((e) =>
            e == null ? null : TextMessage.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  )
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
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
  writeNotNull('text_message_log', instance.textMessageLog);
  return val;
}

TextMessageDatum _$TextMessageDatumFromJson(Map<String, dynamic> json) {
  return TextMessageDatum()
    ..id = json['id'] as String
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
    id: json['id'] as int,
    address: json['address'] as String,
    body: json['body'] as String,
    isRead: json['is_read'] as bool,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    dateSent: json['date_sent'] == null
        ? null
        : DateTime.parse(json['date_sent'] as String),
    kind: json['kind'] as String,
    state: json['state'] as String,
  )..size = json['size'] as int;
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
  writeNotNull('is_read', instance.isRead);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('date_sent', instance.dateSent?.toIso8601String());
  writeNotNull('kind', instance.kind);
  writeNotNull('state', instance.state);
  return val;
}

PhoneLogDatum _$PhoneLogDatumFromJson(Map<String, dynamic> json) {
  return PhoneLogDatum()
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..phoneLog = (json['phone_log'] as List)
        ?.map((e) =>
            e == null ? null : PhoneCall.fromJson(e as Map<String, dynamic>))
        ?.toList();
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
  writeNotNull('phone_log', instance.phoneLog);
  return val;
}

PhoneCall _$PhoneCallFromJson(Map<String, dynamic> json) {
  return PhoneCall(
    json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String),
    json['call_type'] as String,
    json['duration'] as int,
    json['formatted_number'] as String,
    json['number'] as String,
    json['name'] as String,
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
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String)
    ..calendarEvents = (json['calendar_events'] as List)
        ?.map((e) => e == null
            ? null
            : CalendarEvent.fromJson(e as Map<String, dynamic>))
        ?.toList();
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
  writeNotNull('calendar_events', instance.calendarEvents);
  return val;
}

CalendarEvent _$CalendarEventFromJson(Map<String, dynamic> json) {
  return CalendarEvent(
    json['event_id'] as String,
    json['calendar_id'] as String,
    json['title'] as String,
    json['description'] as String,
    json['start'] == null ? null : DateTime.parse(json['start'] as String),
    json['end'] == null ? null : DateTime.parse(json['end'] as String),
    json['all_day'] as bool,
    json['location'] as String,
    (json['attendees'] as List)?.map((e) => e as String)?.toList(),
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
    json['type'] == null
        ? null
        : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
    name: json['name'],
    enabled: json['enabled'],
    past: json['past'] == null
        ? null
        : Duration(microseconds: json['past'] as int),
    future: json['future'] == null
        ? null
        : Duration(microseconds: json['future'] as int),
  )
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$CalendarMeasureToJson(CalendarMeasure instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('type', instance.type);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('past', instance.past?.inMicroseconds);
  writeNotNull('future', instance.future?.inMicroseconds);
  return val;
}
