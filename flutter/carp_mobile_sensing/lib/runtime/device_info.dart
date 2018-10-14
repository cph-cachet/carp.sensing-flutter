/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// Provides (static) information about the local device.
///
/// This class is a singleton that one time access the information from the local device
/// to be used in the sensing framework.
class Device {
  // Basic device info about the device from which this datum were collected from.
  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  static String platform;
  static String hardware;
  static String deviceID;
  static String deviceName;
  static String deviceManufacturer;
  static String deviceModel;
  static String operatingSystem;

  static Map<String, dynamic> deviceData = <String, dynamic>{};

  static getDeviceInfo() async {
    Map<String, dynamic> _deviceData;

    //print('getting device info...');
    try {
      if (Platform.isAndroid) {
        //print('Android');
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        //print('IOS');
        deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }

    deviceData = _deviceData;
  }

  static Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    platform = 'Android';
    hardware = build.hardware;
    deviceID = build.id;
    deviceName = build.device;
    deviceManufacturer = build.manufacturer;
    deviceModel = build.model;
    operatingSystem = build.version.baseOS;

    return <String, dynamic>{
      'platform': 'Android',
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
    };
  }

  static Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    platform = 'IOS';
    hardware = data.utsname.machine;
    deviceID = data.identifierForVendor;
    deviceName = data.name;
    deviceManufacturer = 'Apple';
    deviceModel = data.model;
    operatingSystem = data.systemName;

    return <String, dynamic>{
      'platform': 'IOS',
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }
}
