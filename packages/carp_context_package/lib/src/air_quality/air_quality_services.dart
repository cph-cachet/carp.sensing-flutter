/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// An [OnlineService] for the air quality service.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class AirQualityService extends OnlineService {
  /// The type of a air quality service.
  static const String DEVICE_TYPE =
      '${DeviceDescriptor.DEVICE_NAMESPACE}.AirQualityService';

  /// The default rolename for a air quality service.
  static const String DEFAULT_ROLENAME = 'air_quality_service';

  /// API key for the WAQI API.
  String apiKey;

  AirQualityService({
    String? roleName,
    List<String>? supportedDataTypes,
    required this.apiKey,
  }) : super(
          roleName: roleName ?? DEFAULT_ROLENAME,
          supportedDataTypes: supportedDataTypes,
        );

  Function get fromJsonFunction => _$AirQualityServiceFromJson;
  factory AirQualityService.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AirQualityService;
  Map<String, dynamic> toJson() => _$AirQualityServiceToJson(this);
}

/// A [DeviceManager] for the [AirQualityService].
class AirQualityServiceManager
    extends OnlineServiceManager<DeviceRegistration, AirQualityService> {
  /// A handle to the [AirQuality] plugin.
  AirQuality? service;

  @override
  String get id =>
      deviceDescriptor?.roleName ?? AirQualityService.DEFAULT_ROLENAME;

  @override
  void onInitialize(AirQualityService service) {}

  @override
  bool canConnect() => true;

  @override
  Future<bool> onConnect() async => (deviceDescriptor?.apiKey != null)
      ? (service = AirQuality(deviceDescriptor!.apiKey)) != null
      : false;

  @override
  Future<bool> onDisconnect() async => true;
}
