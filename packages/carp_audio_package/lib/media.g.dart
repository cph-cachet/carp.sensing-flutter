// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioMedia _$AudioMediaFromJson(Map<String, dynamic> json) => AudioMedia(
      filename: json['filename'] as String,
      startRecordingTime: json['startRecordingTime'] == null
          ? null
          : DateTime.parse(json['startRecordingTime'] as String),
      endRecordingTime: json['endRecordingTime'] == null
          ? null
          : DateTime.parse(json['endRecordingTime'] as String),
    )
      ..$type = json['__type'] as String?
      ..path = json['path'] as String?
      ..upload = json['upload'] as bool
      ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      )
      ..id = json['id'] as String
      ..mediaType = $enumDecode(_$MediaTypeEnumMap, json['mediaType']);

Map<String, dynamic> _$AudioMediaToJson(AudioMedia instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('path', instance.path);
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

ImageMedia _$ImageMediaFromJson(Map<String, dynamic> json) => ImageMedia(
      filename: json['filename'] as String,
      startRecordingTime: json['startRecordingTime'] == null
          ? null
          : DateTime.parse(json['startRecordingTime'] as String),
      endRecordingTime: json['endRecordingTime'] == null
          ? null
          : DateTime.parse(json['endRecordingTime'] as String),
    )
      ..$type = json['__type'] as String?
      ..path = json['path'] as String?
      ..upload = json['upload'] as bool
      ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      )
      ..id = json['id'] as String
      ..mediaType = $enumDecode(_$MediaTypeEnumMap, json['mediaType']);

Map<String, dynamic> _$ImageMediaToJson(ImageMedia instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('path', instance.path);
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

VideoMedia _$VideoMediaFromJson(Map<String, dynamic> json) => VideoMedia(
      filename: json['filename'] as String,
      startRecordingTime: json['startRecordingTime'] == null
          ? null
          : DateTime.parse(json['startRecordingTime'] as String),
      endRecordingTime: json['endRecordingTime'] == null
          ? null
          : DateTime.parse(json['endRecordingTime'] as String),
    )
      ..$type = json['__type'] as String?
      ..path = json['path'] as String?
      ..upload = json['upload'] as bool
      ..metadata = (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      )
      ..id = json['id'] as String
      ..mediaType = $enumDecode(_$MediaTypeEnumMap, json['mediaType']);

Map<String, dynamic> _$VideoMediaToJson(VideoMedia instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('path', instance.path);
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
