/*
 * Copyright 2022 the Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of 'carp_polar_package.dart';

abstract class _PolarProbe extends StreamProbe {
  @override
  PolarDeviceManager get deviceManager =>
      super.deviceManager as PolarDeviceManager;
}

/// Collects accelerometer data from the Polar device.
class PolarAccelerometerProbe extends _PolarProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(PolarDataType.acc)
          ? deviceManager.polar
              .startAccStreaming(deviceManager.id)
              .map((event) =>
                  Measurement.fromData(PolarAccelerometer.fromPolarData(event)))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects gyroscope data from the Polar device.
class PolarGyroscopeProbe extends _PolarProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(PolarDataType.gyro)
          ? deviceManager.polar
              .startGyroStreaming(deviceManager.id)
              .map((event) =>
                  Measurement.fromData(PolarGyroscope.fromPolarData(event)))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects magnetometer data from the Polar device.
class PolarMagnetometerProbe extends _PolarProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(PolarDataType.magnetometer)
          ? deviceManager.polar
              .startMagnetometerStreaming(deviceManager.id)
              .map((event) =>
                  Measurement.fromData(PolarMagnetometer.fromPolarData(event)))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects PPG data from the Polar device.
class PolarPPGProbe extends _PolarProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(PolarDataType.ppg)
          ? deviceManager.polar
              .startPpgStreaming(deviceManager.id)
              .map((event) =>
                  Measurement.fromData(PolarPPG.fromPolarData(event)))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects PPI data from the Polar device.
class PolarPPIProbe extends _PolarProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(PolarDataType.ppi)
          ? deviceManager.polar
              .startPpiStreaming(deviceManager.id)
              .map((event) =>
                  Measurement.fromData(PolarPPI.fromPolarData(event)))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects ECG data from the Polar device.
class PolarECGProbe extends _PolarProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(PolarDataType.ecg)
          ? deviceManager.polar
              .startEcgStreaming(deviceManager.id)
              .map((event) =>
                  Measurement.fromData(PolarECG.fromPolarData(event)))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects HR data from the Polar device.
class PolarHRProbe extends _PolarProbe {
  @override
  Stream<Measurement>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(PolarDataType.hr)
          ? deviceManager.polar
              .startHrStreaming(deviceManager.id)
              .map(
                  (event) => Measurement.fromData(PolarHR.fromPolarData(event)))
              .asBroadcastStream()
          : null
      : null;
}
