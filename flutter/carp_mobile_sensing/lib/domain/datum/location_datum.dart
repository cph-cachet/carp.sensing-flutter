/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:json_annotation/json_annotation.dart';

part 'location_datum.g.dart';

/// Holds location information.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class LocationDatum extends CARPDatum {
  static CARPDataFormat CARP_DATA_FORMAT = new CARPDataFormat(NameSpace.CARP_NAMESPACE, ProbeRegistry.LOCATION_MEASURE);

  double latitude;
  double longitude;
  double accuracy;
  double altitude;
  double speed;
  double speedAccuracy; // Will always be 0 on iOS

  LocationDatum() : super();

  get gpsCoordinates => [latitude, longitude];

  factory LocationDatum.fromJson(Map<String, dynamic> json) => _$LocationDatumFromJson(json);
  Map<String, dynamic> toJson() => _$LocationDatumToJson(this);

  @override
  CARPDataFormat getCARPDataFormat() => CARP_DATA_FORMAT;

  @override
  String toString() =>
      "${getCARPDataFormat().toString()} : {latitude: $latitude, longitude: $longitude, accuracy; $accuracy, altitude: $altitude, speed: $speed, speed_accuracy: $speedAccuracy}";
}
