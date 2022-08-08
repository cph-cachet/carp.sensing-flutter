/*
 * Copyright 2019-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of movisens;

/// A [Datum] which can hold an OMH [DataPoint](https://www.openmhealth.org/documentation/#/schema-docs/schema-library/schemas/omh_data-point)
/// and provide its correct OMH [format] and [provenance].
class OMHMovisensDataPoint extends Datum {
  static const DataFormat DATA_FORMAT =
      DataFormat(NameSpace.OMH, omh.SchemaSupport.DATA_POINT);
  @override
  DataFormat get format => DATA_FORMAT;

  omh.DataPoint datapoint;

  static omh.DataPointAcquisitionProvenance provenance(MovisensDatum datum) {
    String source = '{'
        '"smartphone": "${DeviceInfo().deviceID!}", '
        '"app": "${Settings().appName}", '
        '"sensor_type": "movisens", '
        '"sensor_name": "${datum.movisensDeviceName}" '
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
    implements DatumTransformerFactory {
  static const String DEFAULT_HR_UNIT = "beats/min";

  OMHHeartRateDataPoint(omh.DataPoint datapoint) : super(datapoint);

  factory OMHHeartRateDataPoint.fromMovisensHRDatum(MovisensHRDatum datum) {
    var hr = omh.HeartRate(
        heartRate: omh.HeartRateUnitValue(
            unit: DEFAULT_HR_UNIT, value: double.tryParse(datum.hr!)!));
    var source = '{'
        '"smartphone": "${DeviceInfo().deviceID}", '
        '"app": "${Settings().appName}", '
        '"sensor_type": "movisens", '
        '"sensor_name": "${datum.movisensDeviceName}" '
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

  static DatumTransformer get transformer => ((datum) =>
      OMHHeartRateDataPoint.fromMovisensHRDatum(datum as MovisensHRDatum));
}

/// A [TransformedDatum] that holds an OMH [StepCount](https://pub.dev/documentation/openmhealth_schemas/latest/domain_omh_activity/StepCount-class.html)
class OMHStepCountDataPoint extends OMHMovisensDataPoint
    implements DatumTransformerFactory {
  OMHStepCountDataPoint(omh.DataPoint datapoint) : super(datapoint);

  factory OMHStepCountDataPoint.fromMovisensStepCountDatum(
      MovisensStepCountDatum datum) {
    DateTime? time = DateTime.tryParse(datum.movisensTimestamp!);

    var steps = omh.StepCount(stepCount: int.tryParse(datum.stepCount!)!)
      ..effectiveTimeFrame = (omh.TimeFrame()
        ..timeInterval =
            omh.TimeInterval(startDateTime: time, endDateTime: time));
    var source = '{'
        '"smartphone": "${DeviceInfo().deviceID}", '
        '"app": "${Settings().appName}", '
        '"sensor_type": "movisens", '
        '"sensor_name": "${datum.movisensDeviceName}" '
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

  static DatumTransformer get transformer =>
      ((datum) => OMHStepCountDataPoint.fromMovisensStepCountDatum(
          datum as MovisensStepCountDatum));
}

/// A [Datum] that holds an FHIR [Heart Rate Observation](http://hl7.org/fhir/heartrate.html).
class FHIRHeartRateObservation extends Datum
    implements DatumTransformerFactory {
  static const DataFormat DATA_FORMAT =
      DataFormat(NameSpace.FHIR, "observation-vitalsigns");
  static const String DEFAULT_HR_UNIT = "beats/min";

  @override
  DataFormat get format => DATA_FORMAT;

  Map<String, dynamic> fhirJson;

  FHIRHeartRateObservation(this.fhirJson) : super();

  factory FHIRHeartRateObservation.fromMovisensHRDatum(MovisensHRDatum datum) {
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
        '"device" : "${datum.movisensDeviceName}",'
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

  static DatumTransformer get transformer => ((datum) =>
      FHIRHeartRateObservation.fromMovisensHRDatum(datum as MovisensHRDatum));
}
