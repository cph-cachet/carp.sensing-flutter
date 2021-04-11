part of health_package;

String enumToString(e) => e.toString().split('.').last;

/// Diet, Alcohol, Smoking, Exercise, Sleep (DASES) data types.
enum DasesHealthDataType {
  /// Number of calories consumed.
  CALORIES_INTAKE,

  /// Units of alcohol.
  ALCOHOL,

  /// Blood alcohol content in percentage.
  BLOOD_ALCOHOL_CONTENT,

  /// Number of smoked cigarettes.
  SMOKED_CIGARETTES,

  /// Number of smoked other thing (pipe, cigar, ...).
  SMOKED_OTHER,

  /// Duration of exercise.
  EXERCISE,

  /// Duration of sleep.
  SLEEP,
}

/// Map a [DasesHealthDataType] to a [HealthDataUnit].
const Map<DasesHealthDataType, HealthDataUnit> dasesDataTypeToUnit = {
  DasesHealthDataType.CALORIES_INTAKE: HealthDataUnit.CALORIES,
  DasesHealthDataType.ALCOHOL: HealthDataUnit.COUNT,
  DasesHealthDataType.BLOOD_ALCOHOL_CONTENT: HealthDataUnit.PERCENTAGE,
  DasesHealthDataType.SMOKED_CIGARETTES: HealthDataUnit.COUNT,
  DasesHealthDataType.SMOKED_OTHER: HealthDataUnit.COUNT,
  DasesHealthDataType.EXERCISE: HealthDataUnit.NO_UNIT,
  DasesHealthDataType.SLEEP: HealthDataUnit.NO_UNIT,
};

/// Specify the configuration on how to collect health data.
///
/// The [healthDataType] specify which [HealthDataType](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html)
/// to collect.
@JsonSerializable(
    fieldRename: FieldRename.none, includeIfNull: false, explicitToJson: true)
class HealthMeasure extends MarkedMeasure {
  /// The [HealthDataType](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html) to collect.
  HealthDataType healthDataType;

  HealthMeasure({
    String type,
    Map<String, MeasureDescription> measureDescription,
    bool enabled,
    Duration history = const Duration(days: 1),
    this.healthDataType,
  })
      : super(
          type: type,
          measureDescription: measureDescription,
          enabled: enabled,
          history: history,
        );

  Function get fromJsonFunction => _$HealthMeasureFromJson;
  factory HealthMeasure.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$HealthMeasureToJson(this);

  String tag() => '$type.$healthDataType';

  String toString() => super.toString() + ', healthDataType: $healthDataType';
}

/// A [Datum] that holds a [HealthDataPoint](https://pub.dev/documentation/health/latest/health/HealthDataPoint-class.html) data point information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class HealthDatum extends Datum {
  /// The format of this health datum is `carp.health.<healthdatatype>`,
  /// where `<healthdatatype>` is the lowercase of the [HealthDataType](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html) collected.
  DataFormat get format => DataFormat
      .fromString('${HealthSamplingPackage.HEALTH}.${dataType.toLowerCase()}');

  /// The value of the health data.
  num value;

  /// Unit of health data.
  ///
  /// Note that the uppercase version is used, e.g. `COUNT` in the case of step counts.
  String unit;

  /// Start date-time for this health data.
  DateTime dateFrom;

  /// End date-time for this health data.
  DateTime dateTo;

  /// The type of health data -- see [HealthDataType](https://pub.dev/documentation/health/latest/health/HealthDataType-class.html).
  ///
  /// Note that the uppercase version is used, e.g. `STEPS`.
  String dataType;

  /// The platform from which this health data point came from (ANDROID, IOS).
  String platform;

  /// The device id of the phone
  String deviceId;

  /// The UUID of the data point s.t. points can be unique
  String uuid;

  HealthDatum(this.value, this.unit, this.dataType, this.dateFrom, this.dateTo,
      this.platform, this.deviceId, this.uuid)
      : super();

  factory HealthDatum.fromHealthDataPoint(HealthDataPoint h) {
    String _uuid = Uuid().v5(Uuid.NAMESPACE_URL, h.toJson().toString());
    return HealthDatum(h.value, h.unitString, h.typeString, h.dateFrom,
        h.dateTo, enumToString(h.platform), h.deviceId, _uuid);
  }

  factory HealthDatum.fromJson(Map<String, dynamic> json) =>
      _$HealthDatumFromJson(json);

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
