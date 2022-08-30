/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

// Identifiers for CACHET test devices:
//  * PVSO : B36B5B21 [03813-21-03667]
//  * H10  : B5FC172F [00634-17-03667]

/// A [CARP Mobile Sensing](https://pub.dev/packages/carp_mobile_sensing)
/// sampling package for collecting data from the Polar H10, H9, and Polar Verity
/// Sense Optical (PVSO) heart rate sensors as follows.
///
/// **H10 Heart rate sensor**
///
/// * Heart rate as beats per minute. RR Interval in ms and 1/1024 format.
/// * Electrocardiography (ECG) data in µV. Default epoch for timestamp is 1.1.2000
/// * Accelerometer data with sample rates of 25Hz, 50Hz, 100Hz and 200Hz and range of 2G, 4G and 8G. Axis specific acceleration data in mG. Default epoch for timestamp is 1.1.2000
/// * Start and stop of internal recording and request for internal recording status. Recording supports RR, HR with one second sampletime or HR with five second sampletime.
///
/// **H9 Heart rate sensor**
///
/// * Heart rate as beats per minute. RR Interval in ms and 1/1024 format.
/// * Heart rate broadcast.
///
/// **Polar Verity Sense Optical heart rate sensor**
///
/// * Heart rate as beats per minute.
/// * Photoplethysmograpy (PPG) values.
/// * PP interval (milliseconds) representing cardiac pulse-to-pulse interval extracted from PPG signal.
/// * Accelerometer data with sample rate of 52Hz and range of 8G. Axis specific acceleration data in mG.
/// * Gyroscope data with sample rate of 52Hz and ranges of 250dps, 500dps, 1000dps and 2000dps. Axis specific gyroscope data in dps.
/// * Magnetometer data with sample rates of 10Hz, 20Hz, 50HZ and 100Hz and range of +/-50 Gauss. Axis specific magnetometer data in Gauss.
library carp_polar_package;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:polar/polar.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'polar_datum.dart';
part 'polar_probes.dart';
part "carp_polar_package.g.dart";
part 'polar_device_manager.dart';

/// The Polar sampling package supporting the following measures (depending on the
/// type of Polar device used):
///
///  * dk.cachet.carp.polar.accelerometer
///  * dk.cachet.carp.polar.gyroscope
///  * dk.cachet.carp.polar.magnetometer
///  * dk.cachet.carp.polar.ecg
///  * dk.cachet.carp.polar.ppi
///  * dk.cachet.carp.polar.ppg
///  * dk.cachet.carp.polar.hr
///
/// All measure types are continous collection of Polar data from a Polar device,
/// which are:
///
///  * Event-based measures.
///  * Uses the [PolarDevice] connected device for data collection.
///  * No sampling configuration needed.
///
/// An example of a study protocol configuration is:
///
/// ```dart
///   // Add a background task that immediately starts collecting Polar PPG and
///   // PPI data from a Polar Verity Sense Optical heart rate sensor
///   protocol.addTriggeredTask(
///       ImmediateTrigger(),
///       BackgroundTask()
///         ..addMeasure(Measure(type: PolarSamplingPackage.POLAR_PPG))
///         ..addMeasure(Measure(type: PolarSamplingPackage.POLAR_PPI)),
///       polar);
/// ```
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(PolarSamplingPackage());
/// ```
class PolarSamplingPackage implements SamplingPackage {
  static const String POLAR_NAMESPACE = "${NameSpace.CARP}.polar";

  // static const String POLAR_BATTERY = "$POLAR_NAMESPACE.battery";
  // static const String POLAR_CONNECTIVITY = "$POLAR_NAMESPACE.connectivity";
  static const String POLAR_ACCELEROMETER = "$POLAR_NAMESPACE.accelerometer";
  static const String POLAR_GYROSCOPE = "$POLAR_NAMESPACE.gyroscope";
  static const String POLAR_MAGNETOMETER = "$POLAR_NAMESPACE.magnetometer";

  // TODO - can we collect this? Not sure - check.
  static const String POLAR_EXERCISE = "$POLAR_NAMESPACE.exercise";
  static const String POLAR_PPG = "$POLAR_NAMESPACE.ppg";
  static const String POLAR_PPI = "$POLAR_NAMESPACE.ppi";
  static const String POLAR_ECG = "$POLAR_NAMESPACE.ecg";
  static const String POLAR_HR = "$POLAR_NAMESPACE.hr";

  final DeviceManager _deviceManager = PolarDeviceManager();

  @override
  void onRegister() {
    FromJsonFactory().register(PolarDevice());
  }

  @override
  String get deviceType => PolarDevice.DEVICE_TYPE;

  @override
  DeviceManager get deviceManager => _deviceManager;

  @override
  List<Permission> get permissions => [
        Permission.location,
        Permission.bluetooth,
        Permission.bluetoothConnect,
        Permission.bluetoothScan,
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case POLAR_ACCELEROMETER:
        return PolarAccelerometerProbe();
      case POLAR_GYROSCOPE:
        return PolarGyroscopeProbe();
      case POLAR_MAGNETOMETER:
        return PolarMagnetometerProbe();
      case POLAR_EXERCISE:
        return PolarExerciseProbe();
      case POLAR_ECG:
        return PolarECGProbe();
      case POLAR_PPI:
        return PolarPPIProbe();
      case POLAR_PPG:
        return PolarPPGProbe();
      case POLAR_HR:
        return PolarHRProbe();
      default:
        return null;
    }
  }

  @override
  List<String> get dataTypes => [
        POLAR_ACCELEROMETER,
        POLAR_GYROSCOPE,
        POLAR_MAGNETOMETER,
        POLAR_EXERCISE,
        POLAR_ECG,
        POLAR_PPI,
        POLAR_PPG,
        POLAR_HR,
      ];

  @override
  SamplingSchema get samplingSchema => SamplingSchema();
}
