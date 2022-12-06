part of carp_context_package;

/// A [Data] which can hold an OMH [DataPoint](https://www.openmhealth.org/documentation/#/schema-docs/schema-library/schemas/omh_data-point)
/// and provide its correct OMH [format] and [provenance].
class OMHContextDataPointData extends Data {
  static const dataType = "${NameSpace.OMH}.${omh.SchemaSupport.DATA_POINT}";

  omh.DataPoint datapoint;

  static String get source =>
      '{smartphone:${DeviceInfo().deviceID},app:${Settings().appName}}';

  static omh.DataPointAcquisitionProvenance get provenance =>
      omh.DataPointAcquisitionProvenance(
          sourceName: source, modality: omh.DataPointModality.SENSED);

  OMHContextDataPointData(this.datapoint);

  @override
  Map<String, dynamic> toJson() => datapoint.toJson();
}

/// Holds an OMH [Geoposition](https://pub.dartlang.org/documentation/openmhealth_schemas/latest/domain_omh_geoposition/Geoposition-class.html)
/// data point.
class OMHGeopositionDataPoint extends OMHContextDataPointData
    implements DataTransformerFactory {
  OMHGeopositionDataPoint(omh.DataPoint datapoint) : super(datapoint);

  factory OMHGeopositionDataPoint.fromLocationData(LocationData location) {
    var pos = omh.Geoposition(
        latitude: omh.PlaneAngleUnitValue(
            unit: omh.PlaneAngleUnit.DEGREE_OF_ARC, value: location.latitude),
        longitude: omh.PlaneAngleUnitValue(
            unit: omh.PlaneAngleUnit.DEGREE_OF_ARC, value: location.longitude),
        positioningSystem: omh.PositioningSystem.GPS);

    return OMHGeopositionDataPoint(omh.DataPoint(
        body: pos, provenance: OMHContextDataPointData.provenance));
  }

  factory OMHGeopositionDataPoint.fromJson(Map<String, dynamic> json) =>
      OMHGeopositionDataPoint(omh.DataPoint.fromJson(json));

  static DataTransformer get transformer => ((data) =>
      OMHGeopositionDataPoint.fromLocationData(data as LocationData));
}

/// Holds an OMH [PhysicalActivity](https://pub.dartlang.org/documentation/openmhealth_schemas/latest/domain_omh_activity/PhysicalActivity-class.html)
/// data point.
class OMHPhysicalActivityDataPoint extends OMHContextDataPointData
    implements DataTransformerFactory {
  OMHPhysicalActivityDataPoint(omh.DataPoint datapoint) : super(datapoint);

  factory OMHPhysicalActivityDataPoint.fromActivityData(ActivityData activity) {
    var act = omh.PhysicalActivity(activityName: activity.typeString);

    return OMHPhysicalActivityDataPoint(omh.DataPoint(
        body: act, provenance: OMHContextDataPointData.provenance));
  }

  factory OMHPhysicalActivityDataPoint.fromJson(Map<String, dynamic> json) =>
      OMHPhysicalActivityDataPoint(omh.DataPoint.fromJson(json));

  static DataTransformer get transformer => ((data) =>
      OMHPhysicalActivityDataPoint.fromActivityData(data as ActivityData));
}
