/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_common;

/// Configuration of an internet-connected smartphone with built-in [sensors].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Smartphone
    extends PrimaryDeviceConfiguration<SmartphoneDeviceRegistration> {
  /// The type of a smartphone device.
  static const String DEVICE_TYPE =
      '${DeviceConfiguration.DEVICE_NAMESPACE}.Smartphone';

  /// The default role name for a smartphone.
  static const String DEFAULT_ROLENAME = 'Primary Phone';

  @override
  DataTypeSamplingSchemeMap? get dataTypeSamplingSchemes =>
      DataTypeSamplingSchemeMap.from([
        DataTypeSamplingScheme(
            CarpDataTypes().types[CarpDataTypes.GEOLOCATION_TYPE_NAME]!,
            GranularitySamplingConfiguration(Granularity.Balanced)),
        DataTypeSamplingScheme(
          CarpDataTypes().types[CarpDataTypes.STEP_COUNT_TYPE_NAME]!,
          NoOptionsSamplingConfiguration(),
        ),
        DataTypeSamplingScheme(CarpDataTypes()
            .types[CarpDataTypes.NON_GRAVITATIONAL_ACCELERATION_TYPE_NAME]!),
        DataTypeSamplingScheme(
            CarpDataTypes().types[CarpDataTypes.ACCELERATION_TYPE_NAME]!),
      ]);

  /// Create a new Smartphone device descriptor.
  /// If [roleName] is not specified, then the [DEFAULT_ROLENAME] is used.
  Smartphone({
    super.roleName = Smartphone.DEFAULT_ROLENAME,
  });

  @override
  SmartphoneDeviceRegistration createRegistration({
    String? deviceId,
    String? deviceDisplayName,
    String? platform,
    String? hardware,
    String? deviceName,
    String? deviceManufacturer,
    String? deviceModel,
    String? operatingSystem,
    String? sdk,
    String? release,
  }) =>
      SmartphoneDeviceRegistration(
        deviceId: deviceId,
        deviceDisplayName: deviceDisplayName,
        platform: platform,
        hardware: hardware,
        deviceName: deviceName,
        deviceManufacturer: deviceManufacturer,
        deviceModel: deviceModel,
        operatingSystem: operatingSystem,
        sdk: sdk,
        release: release,
      );

  @override
  Function get fromJsonFunction => _$SmartphoneFromJson;
  factory Smartphone.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Smartphone;
  @override
  Map<String, dynamic> toJson() => _$SmartphoneToJson(this);
}

/// A [DeviceRegistration] for [Smartphone] specifying details of the phone.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class SmartphoneDeviceRegistration extends DeviceRegistration {
  String? platform;
  String? hardware;
  String? deviceName;
  String? deviceManufacturer;
  String? deviceModel;
  String? operatingSystem;
  String? sdk;
  String? release;

  SmartphoneDeviceRegistration({
    super.deviceId,
    super.deviceDisplayName,
    super.registrationCreatedOn,
    this.platform,
    this.hardware,
    this.deviceName,
    this.deviceManufacturer,
    this.deviceModel,
    this.operatingSystem,
    this.sdk,
    this.release,
  });

  @override
  Function get fromJsonFunction => _$SmartphoneDeviceRegistrationFromJson;
  factory SmartphoneDeviceRegistration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SmartphoneDeviceRegistration;
  @override
  Map<String, dynamic> toJson() => _$SmartphoneDeviceRegistrationToJson(this);
}
