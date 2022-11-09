// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_core_data;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataStreamsConfiguration _$DataStreamsConfigurationFromJson(
        Map<String, dynamic> json) =>
    DataStreamsConfiguration(
      studyDeploymentId: json['studyDeploymentId'] as String,
      expectedDataStreams: (json['expectedDataStreams'] as List<dynamic>)
          .map((e) => ExpectedDataStream.fromJson(e as Map<String, dynamic>))
          .toSet(),
    );

Map<String, dynamic> _$DataStreamsConfigurationToJson(
        DataStreamsConfiguration instance) =>
    <String, dynamic>{
      'studyDeploymentId': instance.studyDeploymentId,
      'expectedDataStreams': instance.expectedDataStreams.toList(),
    };

ExpectedDataStream _$ExpectedDataStreamFromJson(Map<String, dynamic> json) =>
    ExpectedDataStream(
      deviceRoleName: json['deviceRoleName'] as String,
      dataType: json['dataType'] as String,
    );

Map<String, dynamic> _$ExpectedDataStreamToJson(ExpectedDataStream instance) =>
    <String, dynamic>{
      'deviceRoleName': instance.deviceRoleName,
      'dataType': instance.dataType,
    };

DataStreamId _$DataStreamIdFromJson(Map<String, dynamic> json) => DataStreamId(
      studyDeploymentId: json['studyDeploymentId'] as String,
      deviceRoleName: json['deviceRoleName'] as String,
      dataType: json['dataType'] as String,
    );

Map<String, dynamic> _$DataStreamIdToJson(DataStreamId instance) =>
    <String, dynamic>{
      'studyDeploymentId': instance.studyDeploymentId,
      'deviceRoleName': instance.deviceRoleName,
      'dataType': instance.dataType,
    };

DataStreamBatch _$DataStreamBatchFromJson(Map<String, dynamic> json) =>
    DataStreamBatch(
      dataStream:
          DataStreamId.fromJson(json['dataStream'] as Map<String, dynamic>),
      firstSequenceId: json['firstSequenceId'] as int,
      measurements: (json['measurements'] as List<dynamic>)
          .map((e) => Measurement.fromJson(e as Map<String, dynamic>))
          .toList(),
      triggerIds:
          (json['triggerIds'] as List<dynamic>).map((e) => e as int).toList(),
    );

Map<String, dynamic> _$DataStreamBatchToJson(DataStreamBatch instance) =>
    <String, dynamic>{
      'dataStream': instance.dataStream,
      'firstSequenceId': instance.firstSequenceId,
      'measurements': instance.measurements,
      'triggerIds': instance.triggerIds,
    };

Measurement _$MeasurementFromJson(Map<String, dynamic> json) => Measurement(
      sensorStartTime: json['sensorStartTime'] as int,
      sensorEndTime: json['sensorEndTime'] as int?,
      data: Data.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MeasurementToJson(Measurement instance) {
  final val = <String, dynamic>{
    'sensorStartTime': instance.sensorStartTime,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('sensorEndTime', instance.sensorEndTime);
  val['data'] = instance.data;
  return val;
}

Data _$DataFromJson(Map<String, dynamic> json) =>
    Data()..$type = json['__type'] as String?;

Map<String, dynamic> _$DataToJson(Data instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  return val;
}

Acceleration _$AccelerationFromJson(Map<String, dynamic> json) => Acceleration(
      (json['x'] as num).toDouble(),
      (json['y'] as num).toDouble(),
      (json['z'] as num).toDouble(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensor_specific_data'] == null
          ? null
          : Data.fromJson(json['sensor_specific_data'] as Map<String, dynamic>);

Map<String, dynamic> _$AccelerationToJson(Acceleration instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensor_specific_data', instance.sensorSpecificData);
  val['x'] = instance.x;
  val['y'] = instance.y;
  val['z'] = instance.z;
  return val;
}

Geolocation _$GeolocationFromJson(Map<String, dynamic> json) => Geolocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensor_specific_data'] == null
          ? null
          : Data.fromJson(json['sensor_specific_data'] as Map<String, dynamic>);

Map<String, dynamic> _$GeolocationToJson(Geolocation instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensor_specific_data', instance.sensorSpecificData);
  val['latitude'] = instance.latitude;
  val['longitude'] = instance.longitude;
  return val;
}

SignalStrength _$SignalStrengthFromJson(Map<String, dynamic> json) =>
    SignalStrength(
      rssi: json['rssi'] as int,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensor_specific_data'] == null
          ? null
          : Data.fromJson(json['sensor_specific_data'] as Map<String, dynamic>);

Map<String, dynamic> _$SignalStrengthToJson(SignalStrength instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensor_specific_data', instance.sensorSpecificData);
  val['rssi'] = instance.rssi;
  return val;
}

StepCount _$StepCountFromJson(Map<String, dynamic> json) => StepCount(
      json['steps'] as int,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensor_specific_data'] == null
          ? null
          : Data.fromJson(json['sensor_specific_data'] as Map<String, dynamic>);

Map<String, dynamic> _$StepCountToJson(StepCount instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensor_specific_data', instance.sensorSpecificData);
  val['steps'] = instance.steps;
  return val;
}

HeartRate _$HeartRateFromJson(Map<String, dynamic> json) => HeartRate(
      bpm: json['bpm'] as int,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensor_specific_data'] == null
          ? null
          : Data.fromJson(json['sensor_specific_data'] as Map<String, dynamic>);

Map<String, dynamic> _$HeartRateToJson(HeartRate instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensor_specific_data', instance.sensorSpecificData);
  val['bpm'] = instance.bpm;
  return val;
}

ECG _$ECGFromJson(Map<String, dynamic> json) => ECG(
      milliVolt: (json['milli_volt'] as num).toDouble(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensor_specific_data'] == null
          ? null
          : Data.fromJson(json['sensor_specific_data'] as Map<String, dynamic>);

Map<String, dynamic> _$ECGToJson(ECG instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensor_specific_data', instance.sensorSpecificData);
  val['milli_volt'] = instance.milliVolt;
  return val;
}

EDA _$EDAFromJson(Map<String, dynamic> json) => EDA(
      microSiemens: (json['micro_siemens'] as num).toDouble(),
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensor_specific_data'] == null
          ? null
          : Data.fromJson(json['sensor_specific_data'] as Map<String, dynamic>);

Map<String, dynamic> _$EDAToJson(EDA instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensor_specific_data', instance.sensorSpecificData);
  val['micro_siemens'] = instance.microSiemens;
  return val;
}

CompletedTask _$CompletedTaskFromJson(Map<String, dynamic> json) =>
    CompletedTask(
      taskName: json['task_name'] as String,
      taskData: json['task_data'] == null
          ? null
          : Data.fromJson(json['task_data'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$CompletedTaskToJson(CompletedTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['task_name'] = instance.taskName;
  writeNotNull('task_data', instance.taskData);
  return val;
}

TriggeredTask _$TriggeredTaskFromJson(Map<String, dynamic> json) =>
    TriggeredTask(
      triggerId: json['trigger_id'] as int,
      taskName: json['task_name'] as String,
      destinationDeviceRoleName: json['destination_device_role_name'] as String,
      control: TaskControl.fromJson(json['control'] as Map<String, dynamic>),
      triggerData: json['trigger_data'] == null
          ? null
          : Data.fromJson(json['trigger_data'] as Map<String, dynamic>),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$TriggeredTaskToJson(TriggeredTask instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['trigger_id'] = instance.triggerId;
  val['task_name'] = instance.taskName;
  val['destination_device_role_name'] = instance.destinationDeviceRoleName;
  val['control'] = instance.control;
  writeNotNull('trigger_data', instance.triggerData);
  return val;
}
