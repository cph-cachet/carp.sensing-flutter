part of movisens;

/// A [TransformedDatum] that holds an OMH [HeartRate](https://pub.dev/documentation/openmhealth_schemas/latest/domain_omh_cardio/HeartRate-class.html)
class OMHHeartRateDatum extends CARPDatum implements TransformedDatum {
  static const DataFormat DATA_FORMAT = DataFormat(omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.HEART_RATE);
  DataFormat get format => DATA_FORMAT;

  static const String DEFAULT_HR_UNIT = "beats/min";

  omh.HeartRate hr;

  OMHHeartRateDatum(this.hr);

  factory OMHHeartRateDatum.fromMovisensHRDatum(MovisensHRDatum data) =>
      OMHHeartRateDatum(omh.HeartRate(omh.HeartRateUnitValue(DEFAULT_HR_UNIT, double.tryParse(data.hr))));

  factory OMHHeartRateDatum.fromJson(Map<String, dynamic> json) => OMHHeartRateDatum(omh.HeartRate.fromJson(json));
  Map<String, dynamic> toJson() => hr.toJson();

  static DatumTransformer get transformer => ((datum) => OMHHeartRateDatum.fromMovisensHRDatum(datum));
}

/// A [TransformedDatum] that holds an OMH [StepCount](https://pub.dev/documentation/openmhealth_schemas/latest/domain_omh_activity/StepCount-class.html)
class OMHStepCountDatum extends CARPDatum implements TransformedDatum {
  static const DataFormat DATA_FORMAT = DataFormat(omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.STEP_COUNT);
  DataFormat get format => DATA_FORMAT;

  omh.StepCount stepCount;

  OMHStepCountDatum(this.stepCount);

  factory OMHStepCountDatum.fromMovisensStepCountDatum(MovisensStepCountDatum data) {
    DateTime time = DateTime.tryParse(data.movisensTimestamp);

    return OMHStepCountDatum(omh.StepCount(int.tryParse(data.stepCount))
      ..effectiveTimeFrame =
          (omh.TimeFrame()..timeInterval = omh.TimeInterval(startDateTime: time, endDateTime: time)));
  }

  factory OMHStepCountDatum.fromJson(Map<String, dynamic> json) => OMHStepCountDatum(omh.StepCount.fromJson(json));
  Map<String, dynamic> toJson() => stepCount.toJson();

  static DatumTransformer get transformer => ((datum) => OMHStepCountDatum.fromMovisensStepCountDatum(datum));
}
