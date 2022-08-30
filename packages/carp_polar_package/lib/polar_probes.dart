/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_polar_package;

abstract class _PolarProbe extends StreamProbe {
  @override
  PolarDeviceManager get deviceManager =>
      super.deviceManager as PolarDeviceManager;
}

abstract class _FeatureReadyPolarProbe extends _PolarProbe {
  @override
  Future<void> onResume() async {
    if (deviceManager.polarFeaturesAvailable) {
      super.onResume();
    } else {
      // if the Polar features are not available yet, try to wait and then resume the probe
      debug('$runtimeType - delaying resume for 10 secs and restarting...');
      Future.delayed(const Duration(seconds: 10), () => super.onResume());
    }
  }
}

/// Collects accelerometer data from the Polar device.
class PolarAccelerometerProbe extends _FeatureReadyPolarProbe {
  @override
  Stream<Datum>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(DeviceStreamingFeature.acc)
          ? deviceManager.polar
              .startAccStreaming(deviceManager.id)
              .map((event) => PolarAccelerometerDatum.fromPolarData(event))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects gyroscope data from the Polar device.
class PolarGyroscopeProbe extends _FeatureReadyPolarProbe {
  @override
  Stream<Datum>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(DeviceStreamingFeature.gyro)
          ? deviceManager.polar
              .startGyroStreaming(deviceManager.id)
              .map((event) => PolarGyroscopeDatum.fromPolarData(event))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects magnetometer data from the Polar device.
class PolarMagnetometerProbe extends _FeatureReadyPolarProbe {
  @override
  Stream<Datum>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(DeviceStreamingFeature.magnetometer)
          ? deviceManager.polar
              .startMagnetometerStreaming(deviceManager.id)
              .map((event) => PolarMagnetometerDatum.fromPolarData(event))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects exercise data from the Polar device.
class PolarExerciseProbe extends _PolarProbe {
  // TODO - how to collect Polar exercise data?
  @override
  Stream<Datum>? get stream => null;
}

/// Collects PPG data from the Polar device.
class PolarPPGProbe extends _FeatureReadyPolarProbe {
  @override
  Stream<Datum>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(DeviceStreamingFeature.ppg)
          ? deviceManager.polar
              .startOhrStreaming(deviceManager.id)
              .map((event) => PolarPPGDatum.fromPolarData(event))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects PPI data from the Polar device.
class PolarPPIProbe extends _FeatureReadyPolarProbe {
  @override
  Stream<Datum>? get stream => (deviceManager.isConnected)
      ? deviceManager.features.contains(DeviceStreamingFeature.ppi)
          ? deviceManager.polar
              .startOhrPPIStreaming(deviceManager.id)
              .map((event) => PolarPPIDatum.fromPolarData(event))
              .asBroadcastStream()
          : null
      : null;
}

/// Collects ECG data from the Polar device.
class PolarECGProbe extends _FeatureReadyPolarProbe {
  @override
  Stream<Datum>? get stream {
    debug('$runtimeType - features: ${deviceManager.features}');
    return (deviceManager.isConnected)
        ? deviceManager.features.contains(DeviceStreamingFeature.ecg)
            ? deviceManager.polar
                .startEcgStreaming(deviceManager.id)
                .map((event) => PolarECGDatum.fromPolarData(event))
                .asBroadcastStream()
            : null
        : null;
  }
}

/// Collects HR data from the Polar device.
class PolarHRProbe extends _PolarProbe {
  @override
  Stream<Datum>? get stream => (deviceManager.isConnected)
      ? deviceManager.polar.heartRateStream
          .map((event) =>
              PolarHRDatum.fromPolarData(event.identifier, event.data))
          .asBroadcastStream()
      : null;
}
