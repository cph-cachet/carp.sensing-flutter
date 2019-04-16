part of context;

/// A [TransformedDatum] that holds an OMH [Geoposition](https://pub.dartlang.org/documentation/openmhealth_schemas/latest/domain_omh_geoposition/Geoposition-class.html)
class OMHGeopositionDatum extends CARPDatum implements TransformedDatum {
  static const DataFormat DATA_FORMAT = DataFormat(omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.GEOPOSITION);
  DataFormat get format => DATA_FORMAT;

  static DatumTransformer get transformer => ((datum) => OMHGeopositionDatum.fromLocationDatum(datum));

  omh.Geoposition geoposition;

  OMHGeopositionDatum(this.geoposition);

  factory OMHGeopositionDatum.fromLocationDatum(LocationDatum location) => OMHGeopositionDatum(omh.Geoposition(
      omh.PlaneAngleUnitValue(omh.PlaneAngleUnit.DEGREE_OF_ARC, location.latitude),
      omh.PlaneAngleUnitValue(omh.PlaneAngleUnit.DEGREE_OF_ARC, location.longitude),
      positioningSystem: omh.PositioningSystem.GPS));

  factory OMHGeopositionDatum.fromJson(Map<String, dynamic> json) =>
      OMHGeopositionDatum(omh.Geoposition.fromJson(json));
  Map<String, dynamic> toJson() => geoposition.toJson();
}

/// A [TransformedDatum] that holds an OMH [PhysicalActivity](https://pub.dartlang.org/documentation/openmhealth_schemas/latest/domain_omh_activity/PhysicalActivity-class.html)
class OMHPhysicalActivityDatum extends CARPDatum implements TransformedDatum {
  static const DataFormat DATA_FORMAT = DataFormat(omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.GEOPOSITION);
  DataFormat get format => DATA_FORMAT;

  static DatumTransformer get transformer => ((datum) => OMHPhysicalActivityDatum.fromActivityDatum(datum));

  omh.PhysicalActivity activity;

  OMHPhysicalActivityDatum(this.activity);

  factory OMHPhysicalActivityDatum.fromActivityDatum(ActivityDatum act) =>
      OMHPhysicalActivityDatum(omh.PhysicalActivity(act.type));

  factory OMHPhysicalActivityDatum.fromJson(Map<String, dynamic> json) =>
      OMHPhysicalActivityDatum(omh.PhysicalActivity.fromJson(json));
  Map<String, dynamic> toJson() => activity.toJson();
}
