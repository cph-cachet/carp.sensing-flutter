/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of movisens;

/// A [TransformedDatum] that holds an OMH [HeartRate](https://pub.dev/documentation/openmhealth_schemas/latest/domain_omh_cardio/HeartRate-class.html)
class OMHHeartRateDatum extends Datum implements TransformedDatum {
  static const DataFormat DATA_FORMAT =
      DataFormat(omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.HEART_RATE);
  DataFormat get format => DATA_FORMAT;

  static const String DEFAULT_HR_UNIT = "beats/min";

  omh.HeartRate hr;

  OMHHeartRateDatum(this.hr);

  factory OMHHeartRateDatum.fromMovisensHRDatum(MovisensHRDatum data) =>
      OMHHeartRateDatum(omh.HeartRate(
          heartRate: omh.HeartRateUnitValue(
              unit: DEFAULT_HR_UNIT, value: double.tryParse(data.hr!)!)));

  factory OMHHeartRateDatum.fromJson(Map<String, dynamic> json) =>
      OMHHeartRateDatum(omh.HeartRate.fromJson(json));
  Map<String, dynamic> toJson() => hr.toJson();

  static DatumTransformer get transformer => ((datum) =>
      OMHHeartRateDatum.fromMovisensHRDatum(datum as MovisensHRDatum));
}

/// A [TransformedDatum] that holds an OMH [StepCount](https://pub.dev/documentation/openmhealth_schemas/latest/domain_omh_activity/StepCount-class.html)
class OMHStepCountDatum extends Datum implements TransformedDatum {
  static const DataFormat DATA_FORMAT =
      DataFormat(omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.STEP_COUNT);
  DataFormat get format => DATA_FORMAT;

  omh.StepCount stepCount;

  OMHStepCountDatum(this.stepCount);

  factory OMHStepCountDatum.fromMovisensStepCountDatum(
      MovisensStepCountDatum data) {
    DateTime? time = DateTime.tryParse(data.movisensTimestamp!);

    return OMHStepCountDatum(
        omh.StepCount(stepCount: int.tryParse(data.stepCount!)!)
          ..effectiveTimeFrame = (omh.TimeFrame()
            ..timeInterval =
                omh.TimeInterval(startDateTime: time, endDateTime: time)));
  }

  factory OMHStepCountDatum.fromJson(Map<String, dynamic> json) =>
      OMHStepCountDatum(omh.StepCount.fromJson(json));
  Map<String, dynamic> toJson() => stepCount.toJson();

  static DatumTransformer get transformer =>
      ((datum) => OMHStepCountDatum.fromMovisensStepCountDatum(
          datum as MovisensStepCountDatum));
}
