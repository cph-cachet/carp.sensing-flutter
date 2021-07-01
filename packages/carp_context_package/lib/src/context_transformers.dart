part of context;

/// A [TransformedDatum] that holds an OMH [Geoposition](https://pub.dartlang.org/documentation/openmhealth_schemas/latest/domain_omh_geoposition/Geoposition-class.html)
class OMHGeopositionDatum extends Datum implements TransformedDatum {
  static const DataFormat DATA_FORMAT = DataFormat(
      omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.GEOPOSITION);

  DataFormat get format => DATA_FORMAT;

  omh.Geoposition geoposition;

  OMHGeopositionDatum(this.geoposition);

  factory OMHGeopositionDatum.fromLocationDatum(LocationDatum location) =>
      OMHGeopositionDatum(omh.Geoposition(
          latitude: omh.PlaneAngleUnitValue(
              unit: omh.PlaneAngleUnit.DEGREE_OF_ARC, value: location.latitude),
          longitude: omh.PlaneAngleUnitValue(
              unit: omh.PlaneAngleUnit.DEGREE_OF_ARC,
              value: location.longitude),
          positioningSystem: omh.PositioningSystem.GPS));

  factory OMHGeopositionDatum.fromJson(Map<String, dynamic> json) =>
      OMHGeopositionDatum(omh.Geoposition.fromJson(json));

  Map<String, dynamic> toJson() => geoposition.toJson();

  static DatumTransformer get transformer => ((datum) =>
      OMHGeopositionDatum.fromLocationDatum(datum as LocationDatum));
}

/// A [TransformedDatum] that holds an OMH [PhysicalActivity](https://pub.dartlang.org/documentation/openmhealth_schemas/latest/domain_omh_activity/PhysicalActivity-class.html)
class OMHPhysicalActivityDatum extends Datum implements TransformedDatum {
  static const DataFormat DATA_FORMAT = DataFormat(
      omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.GEOPOSITION);

  DataFormat get format => DATA_FORMAT;

  omh.PhysicalActivity activity;

  OMHPhysicalActivityDatum(this.activity);

  factory OMHPhysicalActivityDatum.fromActivityDatum(ActivityDatum act) =>
      OMHPhysicalActivityDatum(
          omh.PhysicalActivity(activityName: act.typeString));

  factory OMHPhysicalActivityDatum.fromJson(Map<String, dynamic> json) =>
      OMHPhysicalActivityDatum(omh.PhysicalActivity.fromJson(json));

  Map<String, dynamic> toJson() => activity.toJson();

  static DatumTransformer get transformer => ((datum) =>
      OMHPhysicalActivityDatum.fromActivityDatum(datum as ActivityDatum));
}
