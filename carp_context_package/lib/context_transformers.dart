part of context;

class OMHGeopositionDatum extends CARPDatum implements TransformedDatum {
  static const DataFormat DATA_FORMAT = DataFormat(omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.GEOPOSITION);
  DataFormat get format => DATA_FORMAT;

  static DatumTransformer get transformer => ((datum) => OMHGeopositionDatum.fromCARPDatum(datum));

  omh.Geoposition geoposition;

  OMHGeopositionDatum(this.geoposition);

  factory OMHGeopositionDatum.fromCARPDatum(LocationDatum location) => OMHGeopositionDatum(omh.Geoposition(
      omh.PlaneAngleUnitValue(omh.PlaneAngleUnit.DEGREE_OF_ARC, location.latitude),
      omh.PlaneAngleUnitValue(omh.PlaneAngleUnit.DEGREE_OF_ARC, location.longitude),
      positioningSystem: omh.PositioningSystem.GPS));

  factory OMHGeopositionDatum.fromJson(Map<String, dynamic> json) =>
      OMHGeopositionDatum(omh.Geoposition.fromJson(json));
  Map<String, dynamic> toJson() => geoposition.toJson();
}

class OMHPhysicalActivityDatum extends CARPDatum implements TransformedDatum {
  static const DataFormat DATA_FORMAT = DataFormat(omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.GEOPOSITION);
  DataFormat get format => DATA_FORMAT;

  static DatumTransformer get transformer => ((datum) => OMHPhysicalActivityDatum.fromCARPDatum(datum));

  omh.PhysicalActivity activity;

  OMHPhysicalActivityDatum(this.activity);

  factory OMHPhysicalActivityDatum.fromCARPDatum(ActivityDatum act) =>
      OMHPhysicalActivityDatum(omh.PhysicalActivity(act.type));

  factory OMHPhysicalActivityDatum.fromJson(Map<String, dynamic> json) =>
      OMHPhysicalActivityDatum(omh.PhysicalActivity.fromJson(json));
  Map<String, dynamic> toJson() => activity.toJson();
}
