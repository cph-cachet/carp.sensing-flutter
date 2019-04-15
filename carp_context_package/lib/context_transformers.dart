part of context;

class OMHGeopositionDatum extends CARPDatum {
  static const DataFormat DATA_FORMAT = DataFormat(omh.SchemaSupport.OMH_NAMESPACE, omh.SchemaSupport.GEOPOSITION);
  DataFormat get format => DATA_FORMAT;

  omh.Geoposition _geoposition;

  OMHGeopositionDatum(this._geoposition);

  factory OMHGeopositionDatum.fromCARPLocation(LocationDatum location) => OMHGeopositionDatum(omh.Geoposition(
      omh.PlaneAngleUnitValue(omh.PlaneAngleUnit.DEGREE_OF_ARC, location.latitude),
      omh.PlaneAngleUnitValue(omh.PlaneAngleUnit.DEGREE_OF_ARC, location.longitude),
      positioningSystem: omh.PositioningSystem.GPS));

  factory OMHGeopositionDatum.fromJson(Map<String, dynamic> json) =>
      OMHGeopositionDatum(omh.Geoposition.fromJson(json));
  Map<String, dynamic> toJson() => _geoposition.toJson();
}

Datum Location2GeopositionTransfomer(Datum location) => OMHGeopositionDatum.fromCARPLocation(location);
