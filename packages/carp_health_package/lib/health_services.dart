/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of health_package;

/// An [OnlineService] for the [health](https://pub.dev/packages/health) service.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class HealthService extends OnlineService {
  /// The type of the health service.
  static const String DEVICE_TYPE =
      '${DeviceConfiguration.DEVICE_NAMESPACE}.HealthService';

  /// The default role name for a health service.
  static const String DEFAULT_ROLENAME = 'Health Service';

  /// API key for the Open Weather API.
  String apiKey;

  HealthService({
    String? roleName,
    required this.apiKey,
  }) : super(
          roleName: roleName ?? DEFAULT_ROLENAME,
        );

  @override
  Function get fromJsonFunction => _$HealthServiceFromJson;
  factory HealthService.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as HealthService;
  @override
  Map<String, dynamic> toJson() => _$HealthServiceToJson(this);
}

/// A [DeviceManager] for the [WeatherService].
class HealthServiceManager extends OnlineServiceManager<HealthService> {
  weather.WeatherFactory? _service;

  /// A handle to the [WeatherFactory] plugin.
  weather.WeatherFactory? get service => (_service != null)
      ? _service
      : (configuration?.apiKey != null)
          ? _service = weather.WeatherFactory(configuration!.apiKey)
          : null;

  @override
  String get id => configuration!.apiKey;

  @override
  String? get displayName => 'Weather Service (OW)';

  HealthServiceManager([
    HealthService? configuration,
  ]) : super(HealthService.DEVICE_TYPE, configuration);

  @override
  // ignore: avoid_renaming_method_parameters
  void onInitialize(HealthService service) {}

  @override
  Future<bool> canConnect() async {
    try {
      var data = await service?.currentWeatherByLocation(
          40.63047005003576, -74.12938368359374);
      return (data != null);
    } catch (_) {
      return false;
    }
  }

  @override
  Future<DeviceStatus> onConnect() async =>
      (service != null) ? DeviceStatus.connected : DeviceStatus.disconnected;

  @override
  Future<bool> onDisconnect() async => true;
}
