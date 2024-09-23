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

Map<String, dynamic> _$AmbientLightToJson(AmbientLight instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData?.toJson());
  val['meanLux'] = instance.meanLux;
  val['stdLux'] = instance.stdLux;
  val['minLux'] = instance.minLux;
  val['maxLux'] = instance.maxLux;
  return val;
}

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
    AccelerationFeatures instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  writeNotNull('sensorSpecificData', instance.sensorSpecificData?.toJson());
  val['count'] = instance.count;
  writeNotNull('xMean', instance.xMean);
  writeNotNull('yMean', instance.yMean);
  writeNotNull('zMean', instance.zMean);
  writeNotNull('xStd', instance.xStd);
  writeNotNull('yStd', instance.yStd);
  writeNotNull('zStd', instance.zStd);
  writeNotNull('xAad', instance.xAad);
  writeNotNull('yAad', instance.yAad);
  writeNotNull('zAad', instance.zAad);
  writeNotNull('xMin', instance.xMin);
  writeNotNull('yMin', instance.yMin);
  writeNotNull('zMin', instance.zMin);
  writeNotNull('xMax', instance.xMax);
  writeNotNull('yMax', instance.yMax);
  writeNotNull('zMax', instance.zMax);
  writeNotNull('xMaxMinDiff', instance.xMaxMinDiff);
  writeNotNull('yMaxMinDiff', instance.yMaxMinDiff);
  writeNotNull('zMaxMinDiff', instance.zMaxMinDiff);
  writeNotNull('xMedian', instance.xMedian);
  writeNotNull('yMedian', instance.yMedian);
  writeNotNull('zMedian', instance.zMedian);
  writeNotNull('xMad', instance.xMad);
  writeNotNull('yMad', instance.yMad);
  writeNotNull('zMad', instance.zMad);
  writeNotNull('xIqr', instance.xIqr);
  writeNotNull('yIqr', instance.yIqr);
  writeNotNull('zIqr', instance.zIqr);
  writeNotNull('xNegCount', instance.xNegCount);
  writeNotNull('yNegCount', instance.yNegCount);
  writeNotNull('zNegCount', instance.zNegCount);
  writeNotNull('xPosCount', instance.xPosCount);
  writeNotNull('yPosCount', instance.yPosCount);
  writeNotNull('zPosCount', instance.zPosCount);
  writeNotNull('xAboveMean', instance.xAboveMean);
  writeNotNull('yAboveMean', instance.yAboveMean);
  writeNotNull('zAboveMean', instance.zAboveMean);
  writeNotNull('xEnergy', instance.xEnergy);
  writeNotNull('yEnergy', instance.yEnergy);
  writeNotNull('zEnergy', instance.zEnergy);
  writeNotNull('avgResultAcceleration', instance.avgResultAcceleration);
  writeNotNull('signalMagnitudeArea', instance.signalMagnitudeArea);
  return val;
}
