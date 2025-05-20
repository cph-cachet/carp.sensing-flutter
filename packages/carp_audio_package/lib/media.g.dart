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

Map<String, dynamic> _$AudioMediaToJson(AudioMedia instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.path case final value?) 'path': value,
      'filename': instance.filename,
      'upload': instance.upload,
      if (instance.metadata case final value?) 'metadata': value,
      'id': instance.id,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      if (instance.startRecordingTime?.toIso8601String() case final value?)
        'startRecordingTime': value,
      if (instance.endRecordingTime?.toIso8601String() case final value?)
        'endRecordingTime': value,
    };

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

Map<String, dynamic> _$ImageMediaToJson(ImageMedia instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.path case final value?) 'path': value,
      'filename': instance.filename,
      'upload': instance.upload,
      if (instance.metadata case final value?) 'metadata': value,
      'id': instance.id,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      if (instance.startRecordingTime?.toIso8601String() case final value?)
        'startRecordingTime': value,
      if (instance.endRecordingTime?.toIso8601String() case final value?)
        'endRecordingTime': value,
    };

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

Map<String, dynamic> _$VideoMediaToJson(VideoMedia instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.path case final value?) 'path': value,
      'filename': instance.filename,
      'upload': instance.upload,
      if (instance.metadata case final value?) 'metadata': value,
      'id': instance.id,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      if (instance.startRecordingTime?.toIso8601String() case final value?)
        'startRecordingTime': value,
      if (instance.endRecordingTime?.toIso8601String() case final value?)
        'endRecordingTime': value,
    };

Noise _$NoiseFromJson(Map<String, dynamic> json) => Noise(
      meanDecibel: (json['meanDecibel'] as num).toDouble(),
      stdDecibel: (json['stdDecibel'] as num).toDouble(),
      minDecibel: (json['minDecibel'] as num).toDouble(),
      maxDecibel: (json['maxDecibel'] as num).toDouble(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$NoiseToJson(Noise instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'meanDecibel': instance.meanDecibel,
      'stdDecibel': instance.stdDecibel,
      'minDecibel': instance.minDecibel,
      'maxDecibel': instance.maxDecibel,
    };
