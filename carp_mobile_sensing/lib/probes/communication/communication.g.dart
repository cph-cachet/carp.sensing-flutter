// GENERATED CODE - DO NOT MODIFY BY HAND

part of communication;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessageLogDatum _$TextMessageLogDatumFromJson(Map<String, dynamic> json) {
  return TextMessageLogDatum()
    ..c__ = json['c__'] as String
    ..textMessageLog = (json['text_message_log'] as List)
        ?.map((e) =>
            e == null ? null : TextMessage.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$TextMessageLogDatumToJson(TextMessageLogDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('text_message_log', instance.textMessageLog);
  return val;
}

TextMessageDatum _$TextMessageDatumFromJson(Map<String, dynamic> json) {
  return TextMessageDatum(json['text_message'] == null
      ? null
      : TextMessage.fromJson(json['text_message'] as Map<String, dynamic>))
    ..c__ = json['c__'] as String;
}

Map<String, dynamic> _$TextMessageDatumToJson(TextMessageDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('text_message', instance.textMessage);
  return val;
}

TextMessage _$TextMessageFromJson(Map<String, dynamic> json) {
  return TextMessage(
      id: json['id'] as int,
      address: json['address'] as String,
      body: json['body'] as String,
      isRead: json['is_read'] as bool,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      dateSent: json['date_sent'] == null
          ? null
          : DateTime.parse(json['date_sent'] as String),
      kind: json['kind'] as String,
      state: json['state'] as String)
    ..c__ = json['c__'] as String
    ..size = json['size'] as int;
}

Map<String, dynamic> _$TextMessageToJson(TextMessage instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
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
    ..c__ = json['c__'] as String
    ..phoneLog = (json['phone_log'] as List)
        ?.map((e) =>
            e == null ? null : PhoneCall.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PhoneLogDatumToJson(PhoneLogDatum instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
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
      json['name'] as String)
    ..c__ = json['c__'] as String;
}

Map<String, dynamic> _$PhoneCallToJson(PhoneCall instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('call_type', instance.callType);
  writeNotNull('duration', instance.duration);
  writeNotNull('formatted_number', instance.formattedNumber);
  writeNotNull('number', instance.number);
  writeNotNull('name', instance.name);
  return val;
}

TextMessageMeasure _$TextMessageMeasureFromJson(Map<String, dynamic> json) {
  return TextMessageMeasure(json['measure_type'] as String, name: json['name'])
    ..c__ = json['c__'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String))
    ..collectBodyOfMessage = json['collect_body_of_message'] as bool;
}

Map<String, dynamic> _$TextMessageMeasureToJson(TextMessageMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('collect_body_of_message', instance.collectBodyOfMessage);
  return val;
}

PhoneLogMeasure _$PhoneLogMeasureFromJson(Map<String, dynamic> json) {
  return PhoneLogMeasure(json['measure_type'] as String,
      name: json['name'], days: json['days'] as int)
    ..c__ = json['c__'] as String
    ..enabled = json['enabled'] as bool
    ..configuration = (json['configuration'] as Map<String, dynamic>)
        ?.map((k, e) => MapEntry(k, e as String));
}

Map<String, dynamic> _$PhoneLogMeasureToJson(PhoneLogMeasure instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('c__', instance.c__);
  writeNotNull('measure_type', instance.measureType);
  writeNotNull('name', instance.name);
  writeNotNull('enabled', instance.enabled);
  writeNotNull('configuration', instance.configuration);
  writeNotNull('days', instance.days);
  return val;
}
