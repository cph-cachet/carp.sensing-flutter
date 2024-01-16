/*
 * Copyright 2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of health_package;

/// An [OnlineService] for the [health](https://pub.dev/packages/health) service.
///
/// On Android, this health package always uses Google [Health Connect](https://developer.android.com/health-and-fitness/guides/health-connect).
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class HealthService extends OnlineService {
  /// The type of the health service.
  static const String DEVICE_TYPE =
      '${DeviceConfiguration.DEVICE_NAMESPACE}.HealthService';

  /// The default role name for a health service.
  static const String DEFAULT_ROLE_NAME = 'Health Service';

  /// Which health data types should this service access.
  List<HealthDataType> types;

  HealthService({
    String? roleName,
    required this.types,
  }) : super(
          roleName: roleName ?? DEFAULT_ROLE_NAME,
        );

  @override
  Function get fromJsonFunction => _$HealthServiceFromJson;
  factory HealthService.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as HealthService;
  @override
  Map<String, dynamic> toJson() => _$HealthServiceToJson(this);
}

/// A [DeviceManager] for the [HealthService].
class HealthServiceManager extends OnlineServiceManager<HealthService> {
  HealthFactory? _service;

  /// A handle to the [HealthFactory] plugin.
  /// Returns null if the service is not configured.
  HealthFactory? get service => (configuration != null)
      ? _service ??= HealthFactory(useHealthConnectIfAvailable: true)
      : null;

  @override
  String get id => (configuration != null)
      ? (Platform.isIOS)
          ? "Apple Health"
          : "Google Health Connect"
      : 'N/A';

  @override
  String? get displayName => 'Health Service';

  @override
  List<Permission> get permissions => [];

  HealthServiceManager([
    HealthService? configuration,
  ]) : super(HealthService.DEVICE_TYPE, configuration);

  @override
  // ignore: avoid_renaming_method_parameters
  void onInitialize(HealthService service) {}

  @override
  Future<bool> onHasPermissions() async => (configuration?.types != null)
      ? await service?.hasPermissions(configuration!.types) ?? false
      : true;

  @override
  Future<void> onRequestPermissions() async => (configuration?.types != null)
      ? await service?.requestAuthorization(configuration!.types)
      : null;

  @override
  Future<bool> canConnect() async => true;

  @override
  Future<DeviceStatus> onConnect() async => DeviceStatus.connected;

  @override
  Future<bool> onDisconnect() async => true;
}
