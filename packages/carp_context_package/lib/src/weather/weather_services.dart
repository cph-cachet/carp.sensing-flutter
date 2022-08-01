/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// An [OnlineService] for the weather service.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class WeatherService extends OnlineService {
  /// The type of a air quality service.
  static const String DEVICE_TYPE =
      '${DeviceDescriptor.DEVICE_NAMESPACE}.WeatherService';

  /// The default rolename for a air quality service.
  static const String DEFAULT_ROLENAME = 'weather_service';

  /// API key for the WAQI API.
  String apiKey;

  WeatherService({
    String? roleName,
    List<String>? supportedDataTypes,
    required this.apiKey,
  }) : super(
          roleName: roleName ?? DEFAULT_ROLENAME,
          supportedDataTypes: supportedDataTypes,
        );

  @override
  Function get fromJsonFunction => _$WeatherServiceFromJson;
  factory WeatherService.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as WeatherService;
  @override
  Map<String, dynamic> toJson() => _$WeatherServiceToJson(this);
}

/// A [DeviceManager] for the [WeatherService].
class WeatherServiceManager
    extends OnlineServiceManager<DeviceRegistration, WeatherService> {
  WeatherFactory? _service;

  /// A handle to the [WeatherFactory] plugin.
  WeatherFactory? get service => (_service != null)
      ? _service
      : (deviceDescriptor?.apiKey != null)
          ? _service = WeatherFactory(deviceDescriptor!.apiKey)
          : null;

  @override
  String get id =>
      deviceDescriptor?.roleName ?? WeatherService.DEFAULT_ROLENAME;

  @override
  // ignore: avoid_renaming_method_parameters
  void onInitialize(WeatherService service) {}

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
  Future<bool> onConnect() async => (service != null);

  @override
  Future<bool> onDisconnect() async => true;
}
