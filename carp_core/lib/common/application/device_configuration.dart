/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_common;

/// Describes any type of electronic device, such as a sensor, video camera,
/// desktop computer, or smartphone that collects data which can be incorporated
/// into the platform after it has been processed by a primary device (potentially itself).
/// Optionally, a device can present output and receive user input.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeviceConfiguration extends Serializable {
  static const DEVICE_NAMESPACE = 'dk.cachet.carp.common.application.devices';

  /// The device type identifier
  @JsonKey(ignore: true)
  String get type => jsonType;

  /// A name which describes how the device participates within the study protocol;
  /// it's 'role'.
  /// For example, 'Parent's phone' or 'Child phone'.
  String roleName;

  /// Determines whether device registration for this device is optional prior to
  /// starting a study, i.e., whether the study can run without this device or not.
  bool? isOptional;

  /// The set of data types which can be collected on this device.
  List<String>? supportedDataTypes;

  /// Sampling configurations which override the default configurations for
  /// data types available on this device.
  Map<String, SamplingConfiguration>? defaultSamplingConfiguration = {};

  DeviceConfiguration({
    required this.roleName,
    this.isOptional,
    this.supportedDataTypes,
  }) : super();

  @override
  String toString() =>
      '$runtimeType - roleName: $roleName, isOptional: $isOptional';

  @override
  Function get fromJsonFunction => _$DeviceConfigurationFromJson;
  factory DeviceConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DeviceConfiguration;
  @override
  Map<String, dynamic> toJson() => _$DeviceConfigurationToJson(this);
  @override
  String get jsonType => '$DEVICE_NAMESPACE.$runtimeType';
}

/// A device which aggregates, synchronizes, and optionally uploads incoming
/// data received from one or more connected devices (potentially just itself).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PrimaryDeviceConfiguration extends DeviceConfiguration {
  PrimaryDeviceConfiguration({
    required super.roleName,
    super.supportedDataTypes,
  }) : super(isOptional: null);

  // This property is only here for (de)serialization purposes.
  // For unknown types we need to know whether to treat them as primary
  // devices or not (in the case of 'DeviceConfiguration' collections).
  bool isPrimaryDevice = true;

  @override
  Function get fromJsonFunction => _$PrimaryDeviceConfigurationFromJson;
  factory PrimaryDeviceConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PrimaryDeviceConfiguration;
  @override
  Map<String, dynamic> toJson() => _$PrimaryDeviceConfigurationToJson(this);
}

/// A general-purpose primary device for custom protocols.
/// Only used when downloading custom protocols from the CARP web service.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CustomProtocolDevice extends PrimaryDeviceConfiguration {
  /// The default rolename for a custom protocol device.
  static const String DEFAULT_ROLENAME = 'Custom device';

  /// Create a new [CustomProtocolDevice] device descriptor.
  /// If [roleName] is not specified, then the  [DEFAULT_ROLENAME] is used.
  CustomProtocolDevice({
    super.roleName = CustomProtocolDevice.DEFAULT_ROLENAME,
    super.supportedDataTypes,
  });

  @override
  Function get fromJsonFunction => _$CustomProtocolDeviceFromJson;
  factory CustomProtocolDevice.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as CustomProtocolDevice;
  @override
  Map<String, dynamic> toJson() => _$CustomProtocolDeviceToJson(this);
}

/// An internet-connected phone with built-in sensors.
/// Typically this phone for a [StudyProtocol] running on this phone.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Smartphone extends PrimaryDeviceConfiguration {
  /// The type of a smartphone primary device.
  static const String DEVICE_TYPE =
      '${DeviceConfiguration.DEVICE_NAMESPACE}.Smartphone';

  /// The default role name for a smartphone primary device.
  static const String DEFAULT_ROLENAME = 'primaryphone';

  /// Create a new Smartphone device descriptor.
  /// If [roleName] is not specified, then the [DEFAULT_ROLENAME] is used.
  Smartphone({
    super.roleName = Smartphone.DEFAULT_ROLENAME,
    super.supportedDataTypes,
  });

  @override
  Function get fromJsonFunction => _$SmartphoneFromJson;
  factory Smartphone.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Smartphone;
  @override
  Map<String, dynamic> toJson() => _$SmartphoneToJson(this);
}

/// A beacon meeting the open AltBeacon standard.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class AltBeacon extends DeviceConfiguration {
  AltBeacon({
    super.roleName = 'AltBeacon',
    super.supportedDataTypes,
  }) : super(isOptional: true);

  @override
  Function get fromJsonFunction => _$AltBeaconFromJson;
  factory AltBeacon.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AltBeacon;
  @override
  Map<String, dynamic> toJson() => _$AltBeaconToJson(this);
}
