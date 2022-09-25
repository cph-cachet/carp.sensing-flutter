part of carp_context_package;

/// A [Datum] which can hold an OMH [DataPoint](https://www.openmhealth.org/documentation/#/schema-docs/schema-library/schemas/omh_data-point)
/// and provide its correct OMH [format] and [provenance].
class OMHContextDataPointDatum extends Datum {
  static const DataFormat DATA_FORMAT =
      DataFormat(NameSpace.OMH, omh.SchemaSupport.DATA_POINT);

  @override
  DataFormat get format => DATA_FORMAT;

  omh.DataPoint datapoint;

  static String get source =>
      '{smartphone:${DeviceInfo().deviceID},app:${Settings().appName}}';

  static omh.DataPointAcquisitionProvenance get provenance =>
      omh.DataPointAcquisitionProvenance(
          sourceName: source, modality: omh.DataPointModality.SENSED);

  OMHContextDataPointDatum(this.datapoint);

  @override
  Map<String, dynamic> toJson() => datapoint.toJson();
}

/// A [TransformedDatum] that holds an OMH [Geoposition](https://pub.dartlang.org/documentation/openmhealth_schemas/latest/domain_omh_geoposition/Geoposition-class.html)
/// data point.
class OMHGeopositionDataPoint extends OMHContextDataPointDatum
    implements DatumTransformerFactory {
  OMHGeopositionDataPoint(omh.DataPoint datapoint) : super(datapoint);

  factory OMHGeopositionDataPoint.fromLocationDatum(LocationDatum location) {
    var pos = omh.Geoposition(
        latitude: omh.PlaneAngleUnitValue(
            unit: omh.PlaneAngleUnit.DEGREE_OF_ARC, value: location.latitude),
        longitude: omh.PlaneAngleUnitValue(
            unit: omh.PlaneAngleUnit.DEGREE_OF_ARC, value: location.longitude),
        positioningSystem: omh.PositioningSystem.GPS);

    return OMHGeopositionDataPoint(omh.DataPoint(
        body: pos, provenance: OMHContextDataPointDatum.provenance));
  }

  factory OMHGeopositionDataPoint.fromJson(Map<String, dynamic> json) =>
      OMHGeopositionDataPoint(omh.DataPoint.fromJson(json));

  static DatumTransformer get transformer => ((datum) =>
      OMHGeopositionDataPoint.fromLocationDatum(datum as LocationDatum));
}

/// A [TransformedDatum] that holds an OMH [PhysicalActivity](https://pub.dartlang.org/documentation/openmhealth_schemas/latest/domain_omh_activity/PhysicalActivity-class.html)
/// data point.
class OMHPhysicalActivityDataPoint extends OMHContextDataPointDatum
    implements DatumTransformerFactory {
  OMHPhysicalActivityDataPoint(omh.DataPoint datapoint) : super(datapoint);

  factory OMHPhysicalActivityDataPoint.fromActivityDatum(
      ActivityDatum activity) {
    var act = omh.PhysicalActivity(activityName: activity.typeString);

    return OMHPhysicalActivityDataPoint(omh.DataPoint(
        body: act, provenance: OMHContextDataPointDatum.provenance));
  }

  factory OMHPhysicalActivityDataPoint.fromJson(Map<String, dynamic> json) =>
      OMHPhysicalActivityDataPoint(omh.DataPoint.fromJson(json));

  static DatumTransformer get transformer => ((datum) =>
      OMHPhysicalActivityDataPoint.fromActivityDatum(datum as ActivityDatum));
}
