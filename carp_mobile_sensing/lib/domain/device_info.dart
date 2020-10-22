/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

//TODO - make this a singleton class -- e.g. Device().deviceID

/// Provides (static) information about the local device.
///
/// This class is a singleton that one time access the information from the
/// local device to be used in the sensing framework.
class Device {
  /// Device info about the device from which this datum were collected from.
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  static String platform;
  static String hardware;
  static String deviceID;
  static String deviceName;
  static String deviceManufacturer;
  static String deviceModel;
  static String operatingSystem;
  static String sdk;
  static String release;

  /// The device info for this device.
  static Map<String, dynamic> deviceData = <String, dynamic>{};

  /// Get the device info using the [DeviceInfoPlugin].
  static void getDeviceInfo() async {
    Map<String, dynamic> _deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }
    deviceData = _deviceData;
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo info) {
    platform = 'Android';
    hardware = info.hardware;
    deviceID = info.id;
    deviceName = info.device;
    deviceManufacturer = info.manufacturer;
    deviceModel = info.model;
    operatingSystem = info.version.codename;
    sdk = info.version.sdkInt.toString();
    release = info.version.release;

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

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo info) {
    platform = 'IOS';
    hardware = info.utsname.machine;
    deviceID = info.identifierForVendor;
    deviceName = info.name;
    deviceManufacturer = 'Apple';
    deviceModel = info.model;
    operatingSystem = info.systemName;
    sdk = info.utsname.release;
    release = info.utsname.version;

    return <String, dynamic>{
      'platform': 'IOS',
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
