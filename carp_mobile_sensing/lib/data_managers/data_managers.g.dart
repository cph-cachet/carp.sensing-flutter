// GENERATED CODE - DO NOT MODIFY BY HAND

part of managers;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileDataEndPoint _$FileDataEndPointFromJson(Map<String, dynamic> json) {
  return FileDataEndPoint(
    type: json['type'] as String,
    bufferSize: json['bufferSize'] as int,
    zip: json['zip'] as bool,
    encrypt: json['encrypt'] as bool,
    publicKey: json['publicKey'] as String,
  )..$type = json[r'$type'] as String;
}

Map<String, dynamic> _$FileDataEndPointToJson(FileDataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull(r'$type', instance.$type);
  writeNotNull('type', instance.type);
  writeNotNull('bufferSize', instance.bufferSize);
  writeNotNull('zip', instance.zip);
  writeNotNull('encrypt', instance.encrypt);
  writeNotNull('publicKey', instance.publicKey);
  return val;
}
