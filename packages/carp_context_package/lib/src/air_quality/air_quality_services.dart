/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_context_package;

/// An [OnlineService] for the air quality service.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class AirQualityService extends OnlineService {
  /// The type of a air quality service.
  static const String DEVICE_TYPE =
      '${DeviceConfiguration.DEVICE_NAMESPACE}.AirQualityService';

  /// The default role name for an air quality service.
  static const String DEFAULT_ROLENAME = 'Air Quality Service';

  /// API key for the WAQI API.
  String apiKey;

  AirQualityService({
    String? roleName,
    required this.apiKey,
  }) : super(
          roleName: roleName ?? DEFAULT_ROLENAME,
        );

  @override
  Function get fromJsonFunction => _$AirQualityServiceFromJson;
  factory AirQualityService.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AirQualityService;
  @override
  Map<String, dynamic> toJson() => _$AirQualityServiceToJson(this);
}

/// A [DeviceManager] for the [AirQualityService].
class AirQualityServiceManager extends OnlineServiceManager<AirQualityService> {
  waqi.AirQuality? _service;

  /// A handle to the [AirQuality] plugin.
  waqi.AirQuality? get service => (_service != null)
      ? _service
      : (configuration?.apiKey != null)
          ? _service = waqi.AirQuality(configuration!.apiKey)
          : null;

  @override
  String get id => configuration!.apiKey;

  @override
  String? get displayName => 'Air Quality Service (WAQI)';

  AirQualityServiceManager([
    AirQualityService? configuration,
  ]) : super(AirQualityService.DEVICE_TYPE, configuration);

  @override
  // ignore: avoid_renaming_method_parameters
  void onInitialize(AirQualityService service) {}

  @override
  Future<bool> canConnect() async {
    try {
      var data = await service?.feedFromGeoLocation(
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
