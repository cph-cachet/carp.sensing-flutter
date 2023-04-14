/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_common;

/// A Bluetooth Low Energy (BLE) device which implements a GATT Heart
/// Rate service (https://www.bluetooth.com/specifications/gatt/services/).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class BLEHeartRateDevice
    extends DeviceConfiguration<MACAddressDeviceRegistration> {
  BLEHeartRateDevice({
    required super.roleName,
    super.isOptional = true,
  });

  @override
  DataTypeSamplingSchemeMap? get dataTypeSamplingSchemes =>
      DataTypeSamplingSchemeMap.from([
        DataTypeSamplingScheme(
            CarpDataTypes().types[CarpDataTypes.HEART_RATE_TYPE_NAME]!),
        DataTypeSamplingScheme(
            CarpDataTypes().types[CarpDataTypes.INTERBEAT_INTERVAL_TYPE_NAME]!),
        DataTypeSamplingScheme(CarpDataTypes()
            .types[CarpDataTypes.SENSOR_SKIN_CONTACT_TYPE_NAME]!),
      ]);

  @override
  MACAddressDeviceRegistration createRegistration({
    String? deviceId,
    String? deviceDisplayName,
    DateTime? registrationCreatedOn,
    String? address,
  }) =>
      MACAddressDeviceRegistration(
        deviceId: deviceId,
        deviceDisplayName: deviceDisplayName,
        registrationCreatedOn: registrationCreatedOn,
        address: address ?? '??????',
      );

  @override
  Function get fromJsonFunction => _$BLEHeartRateDeviceFromJson;
  factory BLEHeartRateDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as BLEHeartRateDevice;
  @override
  Map<String, dynamic> toJson() => _$BLEHeartRateDeviceToJson(this);
}
