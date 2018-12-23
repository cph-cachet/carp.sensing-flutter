/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

//TODO : change probes to use Dart Isolates in order to support dynamic class loading (and isolation).
// Right now registration of probes has to be done manually.
// Later this will be implemented using Dart Isolates.

/// The [ProbeRegistry] can create and register an instance of a relevant probe
/// based on the [MeasureType].
class ProbeRegistry {
  static Map<String, Probe> _probes = new Map<String, Probe>();

  /// Returns a list of running probes.
  static Map<String, Probe> get probes => _probes;

  /// If you create a probe manually, i.e. outside of the [ProbeRegistry] you can register it here.
  static void register(Probe probe) {
    print('adding probe - ${probe.measure.type.name}');
    _probes[probe.measure.type.name] = probe;

    ProbeRegistry.probes.forEach((key, probe) => print('probe fuck! - $key - $probe'));
  }

  /// Create an instance of a probe based on the measure type.
  static Probe create(Measure measure) {
    String type = measure.type.name;
    Probe _probe;

    switch (type) {
      case MeasureType.MEMORY:
        _probe = new MemoryPollingProbe(measure);
        break;
      case MeasureType.PEDOMETER:
        _probe = new PedometerProbe(measure);
        break;
      case MeasureType.ACCELEROMETER:
        _probe = new AccelerometerProbe(measure);
        break;
      case MeasureType.GYROSCOPE:
        _probe = new GyroscopeProbe(measure);
        break;
      case MeasureType.BATTERY:
        _probe = new BatteryProbe(measure);
        break;
      case MeasureType.BLUETOOTH:
        _probe = new BluetoothProbe(measure);
        break;
      case MeasureType.LOCATION:
        _probe = new LocationProbe(measure);
        break;
      case MeasureType.CONNECTIVITY:
        _probe = new ConnectivityProbe(measure);
        break;
      case MeasureType.LIGHT:
        _probe = new LightProbe(measure);
        break;
      case MeasureType.APPS:
        _probe = new AppsProbe(measure);
        break;
      case MeasureType.APP_USAGE:
        _probe = new AppUsageProbe(measure);
        break;
      case MeasureType.TEXT_MESSAGE_LOG:
        _probe = new TextMessageLogProbe(measure);
        break;
      case MeasureType.TEXT_MESSAGE:
        _probe = new TextMessageProbe(measure);
        break;
      case MeasureType.SCREEN:
        _probe = new ScreenProbe(measure);
        break;
      case MeasureType.PHONE_LOG:
        _probe = new PhoneLogProbe(measure);
        break;
      case MeasureType.AUDIO:
        _probe = new AudioProbe(measure);
        break;
      case MeasureType.NOISE:
        _probe = new NoiseProbe(measure);
        break;
      case MeasureType.ACTIVITY:
        _probe = new ActivityProbe(measure);
        break;
      case MeasureType.WEATHER:
        _probe = new WeatherProbe(measure);
        break;
      case MeasureType.APPLE_HEALTHKIT:
        throw "Not Implemented Yet";
        break;
      case MeasureType.GOOGLE_FIT:
        throw "Not Implemented Yet";
        break;
      default:
        break;
    }

    if (_probe != null) {
      _probe.name = measure.name;
      register(_probe);
    }

    return _probe;
  }
}
