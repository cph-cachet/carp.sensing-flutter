/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// Describes any type of electronic device, such as a smartphone, wearable device,
/// a sensor, video camera, or desktop computer that collects data which can be
/// part of a [Study] configuration and which collects measures via a master
/// device (potentially itself).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DeviceDescriptor extends Serializable {
  static final String DEVICE_TYPE_SMARTPHONE = 'smarthone';

  DeviceDescriptor({
    this.deviceType,
    this.name,
    this.roleName,
    this.isMasterDevice,
    this.collectingMeasureTypes,
  }) : super();

  /// The unique device type.
  /// For example [DEVICE_TYPE_SMARTPHONE].
  String deviceType;

  /// A printer-fiendly name of this device.
  String name;

  /// Is this the master device?
  bool isMasterDevice;

  /// The role name of this device in a specific [Study].
  /// For example, 'Patient's phone'
  String roleName;

  /// The list of measures that this device is collecting as part of a
  /// [Study].
  List<MeasureType> collectingMeasureTypes;

  Function get fromJsonFunction => _$DeviceDescriptorFromJson;
  factory DeviceDescriptor.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DeviceDescriptorToJson(this);

  String toString() =>
      '$runtimeType - deviceType: $deviceType, name: $name, isMasterDevice: $isMasterDevice, roleName: $roleName';
}
