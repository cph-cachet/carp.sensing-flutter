// GENERATED CODE - DO NOT MODIFY BY HAND

part of media;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Media _$MediaFromJson(Map<String, dynamic> json) => Media(
      filename: json['filename'] as String,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
      startRecordingTime: json['startRecordingTime'] == null
          ? null
          : DateTime.parse(json['startRecordingTime'] as String),
      endRecordingTime: json['endRecordingTime'] == null
          ? null
          : DateTime.parse(json['endRecordingTime'] as String),
    )
      ..$type = json['__type'] as String?
      ..upload = json['upload'] as bool
      ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      )
      ..id = json['id'] as String;

Map<String, dynamic> _$MediaToJson(Media instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['filename'] = instance.filename;
  val['upload'] = instance.upload;
  writeNotNull('metadata', instance.metadata);
  val['id'] = instance.id;
  val['mediaType'] = _$MediaTypeEnumMap[instance.mediaType]!;
  writeNotNull(
      'startRecordingTime', instance.startRecordingTime?.toIso8601String());
  writeNotNull(
      'endRecordingTime', instance.endRecordingTime?.toIso8601String());
  return val;
}

const _$MediaTypeEnumMap = {
  MediaType.audio: 'audio',
  MediaType.video: 'video',
  MediaType.image: 'image',
};

Noise _$NoiseFromJson(Map<String, dynamic> json) => Noise(
      meanDecibel: (json['meanDecibel'] as num).toDouble(),
      stdDecibel: (json['stdDecibel'] as num).toDouble(),
      minDecibel: (json['minDecibel'] as num).toDouble(),
      maxDecibel: (json['maxDecibel'] as num).toDouble(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$NoiseToJson(Noise instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['meanDecibel'] = instance.meanDecibel;
  val['stdDecibel'] = instance.stdDecibel;
  val['minDecibel'] = instance.minDecibel;
  val['maxDecibel'] = instance.maxDecibel;
  return val;
}
