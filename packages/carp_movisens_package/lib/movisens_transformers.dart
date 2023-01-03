/*
 * Copyright 2019-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_movisens_package;

/// A [Data] object which can hold an OMH [DataPoint](https://www.openmhealth.org/documentation/#/schema-docs/schema-library/schemas/omh_data-point)
/// and provide its correct OMH [format] and [provenance].
class OMHMovisensDataPoint extends Data {
  static const dataType = "${NameSpace.OMH}.${omh.SchemaSupport.DATA_POINT}";

  omh.DataPoint datapoint;

  static omh.DataPointAcquisitionProvenance provenance(MovisensData datum) {
    String source = '{'
        '"smartphone": "${DeviceInfo().deviceID!}", '
        '"app": "${Settings().appName}", '
        '"sensor_type": "movisens", '
        '"sensor_name": "${datum.deviceId}" '
        '}';
    return omh.DataPointAcquisitionProvenance(
      sourceName: source,
      modality: omh.DataPointModality.SENSED,
    );
  }

  OMHMovisensDataPoint(this.datapoint);

  @override
  Map<String, dynamic> toJson() => datapoint.toJson();
}

/// A [Datum] that holds an OMH [HeartRate](https://www.openmhealth.org/documentation/#/schema-docs/schema-library/schemas/omh_heart-rate)
class OMHHeartRateDataPoint extends OMHMovisensDataPoint
    implements DataTransformerFactory {
  static const String DEFAULT_HR_UNIT = "beats/min";

  OMHHeartRateDataPoint(omh.DataPoint datapoint) : super(datapoint);

  factory OMHHeartRateDataPoint.fromMovisensHRDatum(MovisensHR datum) {
    var hr = omh.HeartRate(
        heartRate: omh.HeartRateUnitValue(
            unit: DEFAULT_HR_UNIT, value: double.tryParse(datum.hr!)!));
    var source = '{'
        '"smartphone": "${DeviceInfo().deviceID}", '
        '"app": "${Settings().appName}", '
        '"sensor_type": "movisens", '
        '"sensor_name": "${datum.deviceId}" '
        '}';

    return OMHHeartRateDataPoint(omh.DataPoint(
      body: hr,
      provenance: omh.DataPointAcquisitionProvenance(
        sourceName: source,
        modality: omh.DataPointModality.SENSED,
      ),
    ));
  }

  factory OMHHeartRateDataPoint.fromJson(Map<String, dynamic> json) =>
      OMHHeartRateDataPoint(omh.DataPoint.fromJson(json));

  static DataTransformer get transformer => ((datum) =>
      OMHHeartRateDataPoint.fromMovisensHRDatum(datum as MovisensHR));
}

/// A [TransformedDatum] that holds an OMH [StepCount](https://pub.dev/documentation/openmhealth_schemas/latest/domain_omh_activity/StepCount-class.html)
class OMHStepCountDataPoint extends OMHMovisensDataPoint
    implements DataTransformerFactory {
  OMHStepCountDataPoint(omh.DataPoint datapoint) : super(datapoint);

  factory OMHStepCountDataPoint.fromMovisensStepCountDatum(
      MovisensStepCount datum) {
    DateTime? time = DateTime.tryParse(datum.movisensTimestamp!);

    var steps = omh.StepCount(stepCount: int.tryParse(datum.stepCount!)!)
      ..effectiveTimeFrame = (omh.TimeFrame()
        ..timeInterval =
            omh.TimeInterval(startDateTime: time, endDateTime: time));
    var source = '{'
        '"smartphone": "${DeviceInfo().deviceID}", '
        '"app": "${Settings().appName}", '
        '"sensor_type": "movisens", '
        '"sensor_name": "${datum.deviceId}" '
        '}';

    return OMHStepCountDataPoint(omh.DataPoint(
      body: steps,
      provenance: omh.DataPointAcquisitionProvenance(
        sourceName: source,
        modality: omh.DataPointModality.SENSED,
      ),
    ));
  }

  factory OMHStepCountDataPoint.fromJson(Map<String, dynamic> json) =>
      OMHStepCountDataPoint(omh.DataPoint.fromJson(json));

  static DataTransformer get transformer =>
      ((datum) => OMHStepCountDataPoint.fromMovisensStepCountDatum(
          datum as MovisensStepCount));
}

/// A [Datum] that holds an FHIR [Heart Rate Observation](http://hl7.org/fhir/heartrate.html).
class FHIRHeartRateObservation extends Data implements DataTransformerFactory {
  static const dataType = "${NameSpace.OMH}.observation-vitalsigns";
  static const String DEFAULT_HR_UNIT = "beats/min";

  Map<String, dynamic> fhirJson;

  FHIRHeartRateObservation(this.fhirJson) : super();

  factory FHIRHeartRateObservation.fromMovisensHRDatum(MovisensHR datum) {
    final String fhirString = '{'
        '"resourceType": "Observation",'
        '"id": "heart-rate",'
        '"meta": {'
        '  "profile": ['
        '    "http://hl7.org/fhir/StructureDefinition/vitalsigns"'
        '  ]'
        '},'
        '"text": "Heartrate reading from Movisen MoveEcg4",'
        '"status": "final",'
        '"category": ['
        '  {'
        '    "coding": ['
        '      {'
        '        "system": "http://terminology.hl7.org/CodeSystem/observation-category",'
        '        "code": "vital-signs",'
        '        "display": "Vital Signs"'
        '      }'
        '    ],'
        '    "text": "Vital Signs"'
        '  }'
        '],'
        '"code": {'
        '  "coding": ['
        '    {'
        '      "system": "http://loinc.org",'
        '      "code": "8867-4",'
        '      "display": "Heart rate"'
        '    }'
        '  ],'
        '  "text": "Heart rate"'
        '},'
        '"subject": {'
        '  "reference": "Patient/example"'
        '},'
        '"effectiveDateTime": "${datum.movisensTimestamp}",'
        '"device" : "${datum.deviceId}",'
        '"valueQuantity": {'
        '  "value": ${datum.hr},'
        '  "unit": "beats/minute",'
        '  "system": "http://unitsofmeasure.org",'
        '  "code": "/min"'
        '}'
        '}';

    return FHIRHeartRateObservation(
        json.decode(fhirString) as Map<String, dynamic>);
  }

  @override
  Map<String, dynamic> toJson() => fhirJson;
  factory FHIRHeartRateObservation.fromJson(Map<String, dynamic> json) =>
      FHIRHeartRateObservation(json);

  static DataTransformer get transformer => ((datum) =>
      FHIRHeartRateObservation.fromMovisensHRDatum(datum as MovisensHR));
}
