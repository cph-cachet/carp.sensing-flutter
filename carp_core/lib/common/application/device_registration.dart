/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_common;

/// A [DeviceRegistration] configures a [DeviceConfiguration] as part of the
/// deployment of a [StudyProtocol].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class DeviceRegistration extends Serializable {
  /// An ID for the device, used to disambiguate between devices of the same type,
  /// as provided by the device itself.
  /// It is up to specific types of devices to guarantee uniqueness across all
  /// devices of the same type.
  late String deviceId;

  /// An optional concise textual representation for display purposes describing
  /// the key specifications of the device.
  /// E.g., device manufacturer, name, and operating system version.
  String? deviceDisplayName;

  /// The registration time in zulu time.
  late DateTime registrationCreatedOn;

  /// Create a new [DeviceRegistration]
  ///  * [deviceId] - a unique id for this device.
  ///    If not specified, a unique id will be generated.
  ///  * [deviceDisplayName] - An optional concise textual representation for display
  ///    purposes describing the key specifications of the device.
  ///  * [registrationCreatedOn] - the timestamp in zulu when this registration was created.
  ///    If not specified, the time of creation will be used.
  DeviceRegistration({
    String? deviceId,
    this.deviceDisplayName,
    DateTime? registrationCreatedOn,
  }) : super() {
    this.registrationCreatedOn =
        registrationCreatedOn ?? DateTime.now().toUtc();
    this.deviceId = deviceId ?? const Uuid().v1();
  }

  @override
  Function get fromJsonFunction => _$DeviceRegistrationFromJson;
  factory DeviceRegistration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DeviceRegistration;
  @override
  Map<String, dynamic> toJson() => _$DeviceRegistrationToJson(this);
  @override
  String get jsonType =>
      'dk.cachet.carp.common.application.devices.$runtimeType';

  @override
  String toString() =>
      '$runtimeType - deviceId: $deviceId, deviceDisplayName: $deviceDisplayName, registrationCreatedOn: $registrationCreatedOn';
}

/// A concrete [DeviceRegistration] which solely implements the base properties
/// and nothing else.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class DefaultDeviceRegistration extends DeviceRegistration {
  DefaultDeviceRegistration({
    super.deviceId,
    super.deviceDisplayName,
    super.registrationCreatedOn,
  });

  @override
  Function get fromJsonFunction => _$DefaultDeviceRegistrationFromJson;
  factory DefaultDeviceRegistration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DefaultDeviceRegistration;
  @override
  Map<String, dynamic> toJson() => _$DefaultDeviceRegistrationToJson(this);
}

/// A [DeviceRegistration] for [AltBeacon] specifying which beacon to listen to.
///
/// The beacon ID is 20 bytes, made up out of the recommended subdivision
/// [organizationId], [majorId], and [minorId].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: true)
class AltBeaconDeviceRegistration extends DeviceRegistration {
  /// The beacon device manufacturer's company identifier code as maintained by
  /// the Bluetooth SIG assigned numbers database.
  int? manufacturerId;

  /// The first 16 bytes of the beacon identifier which should be unique to the
  /// advertiser's organizational unit.
  String? organizationId;

  /// The first 2 bytes of the beacon identifier after the [organizationId],
  /// commonly named major ID.
  int? majorId;

  /// The last 2 bytes of the beacon identifier, commonly named minor ID.
  int? minorId;

  /// The average received signal strength at 1 meter from the beacon in
  /// decibel-milliwatts (dBm).
  /// This value is constrained from -127 to 0.
  int? referenceRssi;

  AltBeaconDeviceRegistration({
    super.deviceId,
    super.deviceDisplayName,
    super.registrationCreatedOn,
    this.manufacturerId,
    this.organizationId,
    this.majorId,
    this.minorId,
    this.referenceRssi,
  });

  @override
  Function get fromJsonFunction => _$AltBeaconDeviceRegistrationFromJson;
  factory AltBeaconDeviceRegistration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AltBeaconDeviceRegistration;
  @override
  Map<String, dynamic> toJson() => _$AltBeaconDeviceRegistrationToJson(this);
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
