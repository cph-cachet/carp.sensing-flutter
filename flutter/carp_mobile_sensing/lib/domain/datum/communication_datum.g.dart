// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communication_datum.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextMessageLogDatum _$TextMessageLogDatumFromJson(Map<String, dynamic> json) {
  return TextMessageLogDatum()
    ..$ = json[r'$'] as String
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

  writeNotNull(r'$', instance.$);
  writeNotNull('text_message_log', instance.textMessageLog);
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
    ..$ = json[r'$'] as String;
}

Map<String, dynamic> _$TextMessageToJson(TextMessage instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('id', instance.id);
  writeNotNull('address', instance.address);
  writeNotNull('body', instance.body);
  writeNotNull('is_read', instance.isRead);
  writeNotNull('date', instance.date?.toIso8601String());
  writeNotNull('date_sent', instance.dateSent?.toIso8601String());
  writeNotNull('kind', instance.kind);
  writeNotNull('state', instance.state);
  return val;
}

PhoneLogDatum _$PhoneLogDatumFromJson(Map<String, dynamic> json) {
  return PhoneLogDatum()
    ..$ = json[r'$'] as String
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

  writeNotNull(r'$', instance.$);
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
      json['number'] as String)
    ..$ = json[r'$'] as String;
}

Map<String, dynamic> _$PhoneCallToJson(PhoneCall instance) {
  var val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$', instance.$);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('call_type', instance.callType);
  writeNotNull('duration', instance.duration);
  writeNotNull('formatted_number', instance.formattedNumber);
  writeNotNull('number', instance.number);
  return val;
}
