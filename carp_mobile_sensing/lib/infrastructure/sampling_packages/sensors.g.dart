// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmbientLight _$AmbientLightFromJson(Map<String, dynamic> json) => AmbientLight(
      json['meanLux'] as num,
      json['stdLux'] as num,
      json['minLux'] as num,
      json['maxLux'] as num,
    )
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>);

Map<String, dynamic> _$AmbientLightToJson(AmbientLight instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.sensorSpecificData?.toJson() case final value?)
        'sensorSpecificData': value,
      'meanLux': instance.meanLux,
      'stdLux': instance.stdLux,
      'minLux': instance.minLux,
      'maxLux': instance.maxLux,
    };

AccelerationFeatures _$AccelerationFeaturesFromJson(
        Map<String, dynamic> json) =>
    AccelerationFeatures()
      ..$type = json['__type'] as String?
      ..sensorSpecificData = json['sensorSpecificData'] == null
          ? null
          : Data.fromJson(json['sensorSpecificData'] as Map<String, dynamic>)
      ..count = (json['count'] as num).toInt()
      ..xMean = json['xMean'] as num?
      ..yMean = json['yMean'] as num?
      ..zMean = json['zMean'] as num?
      ..xStd = json['xStd'] as num?
      ..yStd = json['yStd'] as num?
      ..zStd = json['zStd'] as num?
      ..xAad = json['xAad'] as num?
      ..yAad = json['yAad'] as num?
      ..zAad = json['zAad'] as num?
      ..xMin = json['xMin'] as num?
      ..yMin = json['yMin'] as num?
      ..zMin = json['zMin'] as num?
      ..xMax = json['xMax'] as num?
      ..yMax = json['yMax'] as num?
      ..zMax = json['zMax'] as num?
      ..xMaxMinDiff = json['xMaxMinDiff'] as num?
      ..yMaxMinDiff = json['yMaxMinDiff'] as num?
      ..zMaxMinDiff = json['zMaxMinDiff'] as num?
      ..xMedian = json['xMedian'] as num?
      ..yMedian = json['yMedian'] as num?
      ..zMedian = json['zMedian'] as num?
      ..xMad = json['xMad'] as num?
      ..yMad = json['yMad'] as num?
      ..zMad = json['zMad'] as num?
      ..xIqr = json['xIqr'] as num?
      ..yIqr = json['yIqr'] as num?
      ..zIqr = json['zIqr'] as num?
      ..xNegCount = json['xNegCount'] as num?
      ..yNegCount = json['yNegCount'] as num?
      ..zNegCount = json['zNegCount'] as num?
      ..xPosCount = json['xPosCount'] as num?
      ..yPosCount = json['yPosCount'] as num?
      ..zPosCount = json['zPosCount'] as num?
      ..xAboveMean = json['xAboveMean'] as num?
      ..yAboveMean = json['yAboveMean'] as num?
      ..zAboveMean = json['zAboveMean'] as num?
      ..xEnergy = json['xEnergy'] as num?
      ..yEnergy = json['yEnergy'] as num?
      ..zEnergy = json['zEnergy'] as num?
      ..avgResultAcceleration = json['avgResultAcceleration'] as num?
      ..signalMagnitudeArea = json['signalMagnitudeArea'] as num?;

Map<String, dynamic> _$AccelerationFeaturesToJson(
        AccelerationFeatures instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.sensorSpecificData?.toJson() case final value?)
        'sensorSpecificData': value,
      'count': instance.count,
      if (instance.xMean case final value?) 'xMean': value,
      if (instance.yMean case final value?) 'yMean': value,
      if (instance.zMean case final value?) 'zMean': value,
      if (instance.xStd case final value?) 'xStd': value,
      if (instance.yStd case final value?) 'yStd': value,
      if (instance.zStd case final value?) 'zStd': value,
      if (instance.xAad case final value?) 'xAad': value,
      if (instance.yAad case final value?) 'yAad': value,
      if (instance.zAad case final value?) 'zAad': value,
      if (instance.xMin case final value?) 'xMin': value,
      if (instance.yMin case final value?) 'yMin': value,
      if (instance.zMin case final value?) 'zMin': value,
      if (instance.xMax case final value?) 'xMax': value,
      if (instance.yMax case final value?) 'yMax': value,
      if (instance.zMax case final value?) 'zMax': value,
      if (instance.xMaxMinDiff case final value?) 'xMaxMinDiff': value,
      if (instance.yMaxMinDiff case final value?) 'yMaxMinDiff': value,
      if (instance.zMaxMinDiff case final value?) 'zMaxMinDiff': value,
      if (instance.xMedian case final value?) 'xMedian': value,
      if (instance.yMedian case final value?) 'yMedian': value,
      if (instance.zMedian case final value?) 'zMedian': value,
      if (instance.xMad case final value?) 'xMad': value,
      if (instance.yMad case final value?) 'yMad': value,
      if (instance.zMad case final value?) 'zMad': value,
      if (instance.xIqr case final value?) 'xIqr': value,
      if (instance.yIqr case final value?) 'yIqr': value,
      if (instance.zIqr case final value?) 'zIqr': value,
      if (instance.xNegCount case final value?) 'xNegCount': value,
      if (instance.yNegCount case final value?) 'yNegCount': value,
      if (instance.zNegCount case final value?) 'zNegCount': value,
      if (instance.xPosCount case final value?) 'xPosCount': value,
      if (instance.yPosCount case final value?) 'yPosCount': value,
      if (instance.zPosCount case final value?) 'zPosCount': value,
      if (instance.xAboveMean case final value?) 'xAboveMean': value,
      if (instance.yAboveMean case final value?) 'yAboveMean': value,
      if (instance.zAboveMean case final value?) 'zAboveMean': value,
      if (instance.xEnergy case final value?) 'xEnergy': value,
      if (instance.yEnergy case final value?) 'yEnergy': value,
      if (instance.zEnergy case final value?) 'zEnergy': value,
      if (instance.avgResultAcceleration case final value?)
        'avgResultAcceleration': value,
      if (instance.signalMagnitudeArea case final value?)
        'signalMagnitudeArea': value,
    };
