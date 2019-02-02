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
  static void register(String type, Probe probe) => _probes[type] = probe;

  /// Lookup a [Probe] based on its [DataType].
  static Probe lookup(String type) => _probes[type] ?? create(type);

  /// Create an instance of a probe based on the measure.
  static Probe create(String type) {
    Probe _probe;

    switch (type) {
      case DataType.DEVICE:
        _probe = new DeviceProbe();
        break;
      case DataType.MEMORY:
        _probe = new MemoryPollingProbe();
        break;
      case DataType.PEDOMETER:
        _probe = new PedometerProbe();
        break;
      case DataType.ACCELEROMETER:
        _probe = new BufferingAccelerometerProbe();
        break;
      case DataType.GYROSCOPE:
        _probe = new BufferingGyroscopeProbe();
        break;
      case DataType.BATTERY:
        _probe = new BatteryProbe();
        break;
      case DataType.BLUETOOTH:
        _probe = new BluetoothProbe();
        break;
      case DataType.LOCATION:
        _probe = new LocationProbe();
        break;
      case DataType.CONNECTIVITY:
        _probe = new ConnectivityProbe();
        break;
      case DataType.LIGHT:
        _probe = new LightProbe();
        break;
      case DataType.APPS:
        _probe = new AppsProbe();
        break;
      case DataType.APP_USAGE:
        _probe = new AppUsageProbe();
        break;
      case DataType.TEXT_MESSAGE_LOG:
        _probe = new TextMessageLogProbe();
        break;
      case DataType.TEXT_MESSAGE:
        _probe = new TextMessageProbe();
        break;
      case DataType.SCREEN:
        _probe = new ScreenProbe();
        break;
      case DataType.PHONE_LOG:
        _probe = new PhoneLogProbe();
        break;
      case DataType.AUDIO:
        _probe = new AudioProbe();
        break;
      case DataType.NOISE:
        _probe = new NoiseProbe();
        break;
      case DataType.ACTIVITY:
        _probe = new ActivityProbe();
        break;
      case DataType.WEATHER:
        _probe = new WeatherProbe();
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
      register(type, _probe);
    }

    return _probe;
  }
}

/// Create an instance of a probe based on the measure.
//    static Probe create(Measure measure) {
//      Probe _probe;
//
//      switch (measure.type.name) {
//        case DataType.DEVICE:
//          _probe = new DeviceProbe(measure);
//          break;
//        case DataType.MEMORY:
//          _probe = new MemoryPollingProbe(measure);
//          break;
//        case DataType.PEDOMETER:
//          _probe = new PedometerProbe(measure);
//          break;
//        case DataType.ACCELEROMETER:
//          _probe = new BufferingAccelerometerProbe(measure);
//          break;
//        case DataType.GYROSCOPE:
//          _probe = new BufferingGyroscopeProbe(measure);
//          break;
//        case DataType.BATTERY:
//          _probe = new BatteryProbe(measure);
//          break;
//        case DataType.BLUETOOTH:
//          _probe = new BluetoothProbe(measure);
//          break;
//        case DataType.LOCATION:
//          _probe = new LocationProbe(measure);
//          break;
//        case DataType.CONNECTIVITY:
//          _probe = new ConnectivityProbe(measure);
//          break;
//        case DataType.LIGHT:
//          _probe = new LightProbe(measure);
//          break;
//        case DataType.APPS:
//          _probe = new AppsProbe(measure);
//          break;
//        case DataType.APP_USAGE:
//          _probe = new AppUsageProbe(measure);
//          break;
//        case DataType.TEXT_MESSAGE_LOG:
//          _probe = new TextMessageLogProbe(measure);
//          break;
//        case DataType.TEXT_MESSAGE:
//          _probe = new TextMessageProbe(measure);
//          break;
//        case DataType.SCREEN:
//          _probe = new ScreenProbe(measure);
//          break;
//        case DataType.PHONE_LOG:
//          _probe = new PhoneLogProbe(measure);
//          break;
//        case DataType.AUDIO:
//          _probe = new AudioProbe(measure);
//          break;
//        case DataType.NOISE:
//          _probe = new NoiseProbe(measure);
//          break;
//        case DataType.ACTIVITY:
//          _probe = new ActivityProbe(measure);
//          break;
//        case DataType.WEATHER:
//          _probe = new WeatherProbe(measure);
//          break;
//        case DataType.APPLE_HEALTHKIT:
//          throw "Not Implemented Yet";
//          break;
//        case DataType.GOOGLE_FIT:
//          throw "Not Implemented Yet";
//          break;
//        default:
//          break;
//      }
//
//      if (_probe != null) {
//        register(measure.type.name, _probe);
//      }
//
//      return _probe;
//    }
//  }
//}
