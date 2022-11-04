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
  DeviceRegistration([
    String? deviceId,
    this.deviceDisplayName,
    DateTime? registrationCreatedOn,
  ]) : super() {
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
      'dk.cachet.carp.protocols.domain.devices.DefaultDeviceRegistration';

  @override
  String toString() =>
      '$runtimeType - deviceId: $deviceId, deviceDisplayName: $deviceDisplayName, registrationCreatedOn: $registrationCreatedOn';
}
