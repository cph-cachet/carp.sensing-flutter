/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// Provides (static) information about the local device.
///
/// This class is a singleton that one time access the information from the
/// local device to be used in the sensing framework.
class DeviceInfo {
  final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static final DeviceInfo _instance = DeviceInfo._();
  factory DeviceInfo() => _instance;
  DeviceInfo._();

  String? name;

  String? platform;
  String? hardware;
  String? deviceID;
  String? deviceName;
  String? deviceManufacturer;
  String? deviceModel;

  /// The name of the current operating system.
  String? operatingSystemName;

  /// The current operating system version.
  String? operatingSystemVersion;

  /// SDK level.
  String? sdk;

  /// Release level.
  String? release;

  /// The full device info for this device.
  /// See [BaseDeviceInfo.data].
  Map<String, dynamic> deviceData = {};

  /// Initialize the device info using the [DeviceInfoPlugin].
  Future<void> init() async {
    // early out if already initialized
    if (deviceData.isNotEmpty) return;

    try {
      if (Platform.isAndroid) {
        deviceData =
            _readAndroidDeviceInfo(await _deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await _deviceInfoPlugin.iosInfo);
      }
    } on Exception {
      deviceData = {};
    }
  }

  @override
  String toString() =>
      '$deviceID - $deviceModel ${deviceManufacturer?.toUpperCase()} [SDK $sdk]';

  Map<String, dynamic> _readAndroidDeviceInfo(AndroidDeviceInfo info) {
    platform = 'Android';
    hardware = info.hardware;
    deviceID = info.id;
    deviceName = info.device;
    deviceManufacturer = info.manufacturer;
    deviceModel = info.model;
    operatingSystemName = info.version.codename;
    operatingSystemVersion = info.version.baseOS;
    sdk = info.version.sdkInt.toString();
    release = info.version.release;

    return info.data;

    return <String, dynamic>{
      'platform': 'Android',
      'version.securityPatch': info.version.securityPatch,
      'version.sdkInt': info.version.sdkInt,
      'version.release': info.version.release,
      'version.previewSdkInt': info.version.previewSdkInt,
      'version.incremental': info.version.incremental,
      'version.codename': info.version.codename,
      'version.baseOS': info.version.baseOS,
      'board': info.board,
      'bootloader': info.bootloader,
      'brand': info.brand,
      'device': info.device,
      'display': info.display,
      'fingerprint': info.fingerprint,
      'hardware': info.hardware,
      'host': info.host,
      'id': info.id,
      'manufacturer': info.manufacturer,
      'model': info.model,
      'product': info.product,
      'supported32BitAbis': info.supported32BitAbis,
      'supported64BitAbis': info.supported64BitAbis,
      'supportedAbis': info.supportedAbis,
      'tags': info.tags,
      'type': info.type,
      'isPhysicalDevice': info.isPhysicalDevice,
    };
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
    platform = 'iOS';
    hardware = info.utsname.machine;
    deviceID = info.identifierForVendor;
    deviceName = info.name;
    deviceManufacturer = 'Apple';
    deviceModel = info.model;
    operatingSystemName = info.systemName;
    operatingSystemVersion = info.systemVersion;
    sdk = info.utsname.release;
    release = info.utsname.version;

    return info.data;

    return <String, dynamic>{
      'platform': 'iOS',
      'name': info.name,
      'systemName': info.systemName,
      'systemVersion': info.systemVersion,
      'model': info.model,
      'localizedModel': info.localizedModel,
      'identifierForVendor': info.identifierForVendor,
      'isPhysicalDevice': info.isPhysicalDevice,
      'utsname.sysname:': info.utsname.sysname,
      'utsname.nodename:': info.utsname.nodename,
      'utsname.release:': info.utsname.release,
      'utsname.version:': info.utsname.version,
      'utsname.machine:': info.utsname.machine,
    };
  }
}
