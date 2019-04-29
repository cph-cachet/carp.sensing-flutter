// GENERATED CODE - DO NOT MODIFY BY HAND

part of audio;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AudioDatum _$AudioDatumFromJson(Map<String, dynamic> json) {
  return AudioDatum(
      filename: json['filename'] as String,
      startRecordingTime: json['start_recording_time'] == null
          ? null
          : DateTime.parse(json['start_recording_time'] as String),
      endRecordingTime: json['end_recording_time'] == null
          ? null
          : DateTime.parse(json['end_recording_time'] as String))
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$AudioDatumToJson(AudioDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('filename', instance.filename);
  writeNotNull(
      'start_recording_time', instance.startRecordingTime?.toIso8601String());
  writeNotNull(
      'end_recording_time', instance.endRecordingTime?.toIso8601String());
  return val;
}

NoiseDatum _$NoiseDatumFromJson(Map<String, dynamic> json) {
  return NoiseDatum(
      meanDecibel: json['mean_decibel'] as num,
      stdDecibel: json['std_decibel'] as num,
      minDecibel: json['min_decibel'] as num,
      maxDecibel: json['max_decibel'] as num)
    ..id = json['id'] as String
    ..timestamp = json['timestamp'] == null
        ? null
        : DateTime.parse(json['timestamp'] as String);
}

Map<String, dynamic> _$NoiseDatumToJson(NoiseDatum instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('timestamp', instance.timestamp?.toIso8601String());
  writeNotNull('mean_decibel', instance.meanDecibel);
  writeNotNull('std_decibel', instance.stdDecibel);
  writeNotNull('min_decibel', instance.minDecibel);
  writeNotNull('max_decibel', instance.maxDecibel);
  return val;
}

AudioMeasure _$AudioMeasureFromJson(Map<String, dynamic> json) {
  return AudioMeasure(
      json['type'] == null
          ? null
          : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
      name: json['name'],
      enabled: json['enabled'],
      frequency: json['frequency'],
      duration: json['duration'],
      studyId: json['study_id'] as String)
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$AudioMeasureToJson(AudioMeasure instance) {
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
  writeNotNull('frequency', instance.frequency);
  writeNotNull('duration', instance.duration);
  writeNotNull('study_id', instance.studyId);
  return val;
}

NoiseMeasure _$NoiseMeasureFromJson(Map<String, dynamic> json) {
  return NoiseMeasure(
      json['type'] == null
          ? null
          : MeasureType.fromJson(json['type'] as Map<String, dynamic>),
      name: json['name'],
      enabled: json['enabled'],
      frequency: json['frequency'],
      duration: json['duration'],
      samplingRate: json['sampling_rate'] as int)
    ..c__ = json['c__'] as String
    ..configuration = (json['configuration'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    );
}

Map<String, dynamic> _$NoiseMeasureToJson(NoiseMeasure instance) {
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
  writeNotNull('frequency', instance.frequency);
  writeNotNull('duration', instance.duration);
  writeNotNull('sampling_rate', instance.samplingRate);
  return val;
}
