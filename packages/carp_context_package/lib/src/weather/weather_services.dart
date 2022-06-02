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

  Function get fromJsonFunction => _$WeatherServiceFromJson;
  factory WeatherService.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as WeatherService;
  Map<String, dynamic> toJson() => _$WeatherServiceToJson(this);
}

/// A [DeviceManager] for the [WeatherService].
class WeatherServiceManager
    extends OnlineServiceManager<DeviceRegistration, WeatherService> {
  /// A handle to the [WeatherFactory] plugin.
  WeatherFactory? service;

  @override
  String get id =>
      deviceDescriptor?.roleName ?? WeatherService.DEFAULT_ROLENAME;

  @override
  void onInitialize(WeatherService service) {}

  @override
  Future<bool> onConnect() async => (deviceDescriptor?.apiKey != null)
      ? (service = WeatherFactory(deviceDescriptor!.apiKey)) != null
      : false;

  @override
  Future<bool> onDisconnect() async => true;
}
