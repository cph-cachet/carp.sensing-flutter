// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connectivity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connectivity _$ConnectivityFromJson(Map<String, dynamic> json) => Connectivity()
  ..$type = json['__type'] as String?
  ..connectivityStatus = (json['connectivityStatus'] as List<dynamic>)
      .map((e) => $enumDecode(_$ConnectivityStatusEnumMap, e))
      .toList();

Map<String, dynamic> _$ConnectivityToJson(Connectivity instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'connectivityStatus': instance.connectivityStatus
          .map((e) => _$ConnectivityStatusEnumMap[e]!)
          .toList(),
    };

const _$ConnectivityStatusEnumMap = {
  ConnectivityStatus.bluetooth: 'bluetooth',
  ConnectivityStatus.wifi: 'wifi',
  ConnectivityStatus.ethernet: 'ethernet',
  ConnectivityStatus.mobile: 'mobile',
  ConnectivityStatus.none: 'none',
  ConnectivityStatus.vpn: 'vpn',
  ConnectivityStatus.unknown: 'unknown',
};

Bluetooth _$BluetoothFromJson(Map<String, dynamic> json) => Bluetooth(
      startScan: json['startScan'] == null
          ? null
          : DateTime.parse(json['startScan'] as String),
      endScan: json['endScan'] == null
          ? null
          : DateTime.parse(json['endScan'] as String),
    )
      ..$type = json['__type'] as String?
      ..scanResult = (json['scanResult'] as List<dynamic>)
          .map((e) => BluetoothDevice.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$BluetoothToJson(Bluetooth instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'startScan': instance.startScan.toIso8601String(),
      if (instance.endScan?.toIso8601String() case final value?)
        'endScan': value,
      'scanResult': instance.scanResult.map((e) => e.toJson()).toList(),
    };

BluetoothDevice _$BluetoothDeviceFromJson(Map<String, dynamic> json) =>
    BluetoothDevice(
      advertisementName: json['advertisementName'] as String,
      bluetoothDeviceId: json['bluetoothDeviceId'] as String,
      bluetoothDeviceName: json['bluetoothDeviceName'] as String,
      connectable: json['connectable'] as bool,
      rssi: (json['rssi'] as num).toInt(),
      txPowerLevel: (json['txPowerLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$BluetoothDeviceToJson(BluetoothDevice instance) =>
    <String, dynamic>{
      'advertisementName': instance.advertisementName,
      'bluetoothDeviceId': instance.bluetoothDeviceId,
      'bluetoothDeviceName': instance.bluetoothDeviceName,
      'connectable': instance.connectable,
      if (instance.txPowerLevel case final value?) 'txPowerLevel': value,
      'rssi': instance.rssi,
    };

BeaconDevice _$BeaconDeviceFromJson(Map<String, dynamic> json) => BeaconDevice(
      rssi: (json['rssi'] as num).toInt(),
      uuid: json['uuid'] as String?,
      major: (json['major'] as num?)?.toInt(),
      minor: (json['minor'] as num?)?.toInt(),
      accuracy: (json['accuracy'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BeaconDeviceToJson(BeaconDevice instance) =>
    <String, dynamic>{
      'rssi': instance.rssi,
      if (instance.uuid case final value?) 'uuid': value,
      if (instance.major case final value?) 'major': value,
      if (instance.minor case final value?) 'minor': value,
      if (instance.accuracy case final value?) 'accuracy': value,
    };

Wifi _$WifiFromJson(Map<String, dynamic> json) => Wifi(
      ssid: json['ssid'] as String?,
      bssid: json['bssid'] as String?,
      ip: json['ip'] as String?,
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$WifiToJson(Wifi instance) => <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.ssid case final value?) 'ssid': value,
      if (instance.bssid case final value?) 'bssid': value,
      if (instance.ip case final value?) 'ip': value,
    };

BeaconData _$BeaconDataFromJson(Map<String, dynamic> json) => BeaconData(
      startScan: json['startScan'] == null
          ? null
          : DateTime.parse(json['startScan'] as String),
      endScan: json['endScan'] == null
          ? null
          : DateTime.parse(json['endScan'] as String),
    )
      ..$type = json['__type'] as String?
      ..scanResult = (json['scanResult'] as List<dynamic>)
          .map((e) => BeaconDevice.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$BeaconDataToJson(BeaconData instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'startScan': instance.startScan.toIso8601String(),
      if (instance.endScan?.toIso8601String() case final value?)
        'endScan': value,
      'scanResult': instance.scanResult.map((e) => e.toJson()).toList(),
    };

BeaconRegion _$BeaconRegionFromJson(Map<String, dynamic> json) => BeaconRegion(
      identifier: json['identifier'] as String,
      uuid: json['uuid'] as String,
      major: (json['major'] as num?)?.toInt(),
      minor: (json['minor'] as num?)?.toInt(),
    )..$type = json['__type'] as String?;

Map<String, dynamic> _$BeaconRegionToJson(BeaconRegion instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      'identifier': instance.identifier,
      'uuid': instance.uuid,
      if (instance.major case final value?) 'major': value,
      if (instance.minor case final value?) 'minor': value,
    };

BluetoothScanPeriodicSamplingConfiguration
    _$BluetoothScanPeriodicSamplingConfigurationFromJson(
            Map<String, dynamic> json) =>
        BluetoothScanPeriodicSamplingConfiguration(
          interval: Duration(microseconds: (json['interval'] as num).toInt()),
          duration: Duration(microseconds: (json['duration'] as num).toInt()),
          withServices: (json['withServices'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
          withRemoteIds: (json['withRemoteIds'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              const [],
        )
          ..$type = json['__type'] as String?
          ..lastTime = json['lastTime'] == null
              ? null
              : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$BluetoothScanPeriodicSamplingConfigurationToJson(
        BluetoothScanPeriodicSamplingConfiguration instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.lastTime?.toIso8601String() case final value?)
        'lastTime': value,
      'interval': instance.interval.inMicroseconds,
      'duration': instance.duration.inMicroseconds,
      'withServices': instance.withServices,
      'withRemoteIds': instance.withRemoteIds,
    };

BeaconRangingPeriodicSamplingConfiguration
    _$BeaconRangingPeriodicSamplingConfigurationFromJson(
            Map<String, dynamic> json) =>
        BeaconRangingPeriodicSamplingConfiguration(
          interval: Duration(microseconds: (json['interval'] as num).toInt()),
          duration: Duration(microseconds: (json['duration'] as num).toInt()),
          beaconRegions: (json['beaconRegions'] as List<dynamic>?)
                  ?.map((e) => e == null
                      ? null
                      : BeaconRegion.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              const [],
          beaconDistance: (json['beaconDistance'] as num?)?.toInt() ?? 2,
        )
          ..$type = json['__type'] as String?
          ..lastTime = json['lastTime'] == null
              ? null
              : DateTime.parse(json['lastTime'] as String);

Map<String, dynamic> _$BeaconRangingPeriodicSamplingConfigurationToJson(
        BeaconRangingPeriodicSamplingConfiguration instance) =>
    <String, dynamic>{
      if (instance.$type case final value?) '__type': value,
      if (instance.lastTime?.toIso8601String() case final value?)
        'lastTime': value,
      'interval': instance.interval.inMicroseconds,
      'duration': instance.duration.inMicroseconds,
      'beaconRegions': instance.beaconRegions.map((e) => e?.toJson()).toList(),
      'beaconDistance': instance.beaconDistance,
    };
