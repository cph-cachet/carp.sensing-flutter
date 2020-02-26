part of health_lib;

/// Specify the configuration on how to collect health data.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class HealthMeasure extends Measure {
  /// The list of [HealthDataType]s to collect.
  List<HealthDataType> healthDataTypes;

  /// The duration back in time to collect the data for. E.g. one day.
  Duration duration;

  HealthMeasure(MeasureType type, this.healthDataTypes, this.duration, {name, enabled})
      : super(
          type,
          name: name,
          enabled: enabled,
        );

  static Function get fromJsonFunction => _$HealthMeasureFromJson;

  factory HealthMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);

  Map<String, dynamic> toJson() => _$HealthMeasureToJson(this);

  String toString() => 'HealthMeasure: $healthDataTypes ($duration)';
}

/// A [Datum] that holds a [HealthDataPoint] data point information
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class HealthDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, HealthSamplingPackage.HEALTH);

  DataFormat get format => CARP_DATA_FORMAT;

  /// The value of the health data.
  num value;

  /// Unit of health data.
  String unit;

  DateTime dateFrom;
  DateTime dateTo;

  /// The type of health data -- see [HealthDataType] in the `health` package.
  String dataType;

  /// The platform from which this health data point came from (Android, IOS).
  String platform;

  HealthDatum(this.value, this.unit, int dateFrom, int dateTo, this.dataType, this.platform) : super() {
    this.dateFrom = DateTime.fromMillisecondsSinceEpoch(dateFrom);
    this.dateTo = DateTime.fromMillisecondsSinceEpoch(dateTo);
  }

  factory HealthDatum.fromHealthDataPoint(HealthDataPoint healthDataPoint) => HealthDatum(
      healthDataPoint.value,
      healthDataPoint.unit,
      healthDataPoint.dateFrom,
      healthDataPoint.dateTo,
      healthDataPoint.dataType,
      healthDataPoint.platform);

  factory HealthDatum.fromJson(Map<String, dynamic> json) => _$HealthDatumFromJson(json);
  Map<String, dynamic> toJson() => _$HealthDatumToJson(this);

  String toString() =>
      super.toString() +
      ', dataType: $dataType, '
          'platform: $platform, '
          'value: $value, '
          'unit: $unit, '
          'dateFrom: $dateFrom, '
          'dateTo: $dateTo';
}

///// A [Datum] that holds a [HealthDataPoint] datapoint information collected through the [World's Air Quality Index (WAQI)](https://waqi.info) API.
//@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
//class HealthDatum extends CARPDatum {
//  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, HealthSamplingPackage.HEALTH);
//  DataFormat get format => CARP_DATA_FORMAT;
//
////  num value;
////  String unit;
////  int dateFrom;
////  int dateTo;
////  String dataType;
////  String platform;
//  List<Map<String, dynamic>> healthData;
//
//  HealthDatum(this.healthData) : super();
//
//  factory HealthDatum.fromHealthDataPointList(List<HealthDataPoint> points) => HealthDatum(points
//      .map((p) => {
//            'value': p.value,
//            'unit': p.unit,
//            'dateFrom': p.dateFrom,
//            'dateTo': p.dateTo,
//            'dataType': p.dataType,
//            'platform': p.platform
//          })
//      .toList());
//
//  factory HealthDatum.fromJson(Map<String, dynamic> json) => _$HealthDatumFromJson(json);
//
//  Map<String, dynamic> toJson() => _$HealthDatumToJson(this);
//}
