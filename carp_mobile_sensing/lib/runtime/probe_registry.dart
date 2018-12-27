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
/// based on the [DataType].
class ProbeRegistry {
  static Map<String, Probe> _probes = new Map<String, Probe>();

  /// Returns a list of running probes.
  static Map<String, Probe> get probes => _probes;

  /// If you create a probe manually, i.e. outside of the [ProbeRegistry] you can register it here.
  static void register(Probe probe) {
    _probes[probe.measure.type.name] = probe;
  }

  /// Create an instance of a probe based on the measure type.
  static Probe create(Measure measure) {
    String type = measure.type.name;
    Probe _probe;

    switch (type) {
      case DataType.MEMORY:
        _probe = new MemoryPollingProbe(measure);
        break;
      case DataType.PEDOMETER:
        _probe = new PedometerProbe(measure);
        break;
      case DataType.ACCELEROMETER:
        _probe = new BufferingAccelerometerProbe(measure);
        break;
      case DataType.GYROSCOPE:
        _probe = new BufferingGyroscopeProbe(measure);
        break;
      case DataType.BATTERY:
        _probe = new BatteryProbe(measure);
        break;
      case DataType.BLUETOOTH:
        _probe = new BluetoothProbe(measure);
        break;
      case DataType.LOCATION:
        _probe = new LocationProbe(measure);
        break;
      case DataType.CONNECTIVITY:
        _probe = new ConnectivityProbe(measure);
        break;
      case DataType.LIGHT:
        _probe = new LightProbe(measure);
        break;
      case DataType.APPS:
        _probe = new AppsProbe(measure);
        break;
      case DataType.APP_USAGE:
        _probe = new AppUsageProbe(measure);
        break;
      case DataType.TEXT_MESSAGE_LOG:
        _probe = new TextMessageLogProbe(measure);
        break;
      case DataType.TEXT_MESSAGE:
        _probe = new TextMessageProbe(measure);
        break;
      case DataType.SCREEN:
        _probe = new ScreenProbe(measure);
        break;
      case DataType.PHONE_LOG:
        _probe = new PhoneLogProbe(measure);
        break;
      case DataType.AUDIO:
        _probe = new AudioProbe(measure);
        break;
      case DataType.NOISE:
        _probe = new NoiseProbe(measure);
        break;
      case DataType.ACTIVITY:
        _probe = new ActivityProbe(measure);
        break;
      case DataType.WEATHER:
        _probe = new WeatherProbe(measure);
        break;
      case DataType.APPLE_HEALTHKIT:
        throw "Not Implemented Yet";
        break;
      case DataType.GOOGLE_FIT:
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
