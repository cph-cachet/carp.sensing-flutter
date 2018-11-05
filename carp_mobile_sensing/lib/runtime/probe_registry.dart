/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

//TODO : change probes to use Dart Isolates in order to support dynamic class loading (and isolation).
/// The [ProbeRegistry] can create an instance of a relevant probe based on the measure type.
///
/// Right now registration of probes has to be done manually.
/// Later this will be implemented using Dart Isolates.
class ProbeRegistry {
  static const String MEASURE = "measure";
  static const String STRING_MEASURE = "string";
  static const String ERROR_MEASURE = "error";
  static const String MEMORY_MEASURE = "memory";
  static const String PEDOMETER_MEASURE = "pedometer";
  static const String ACCELEROMETER_MEASURE = "accelerometer";
  static const String GYROSCOPE_MEASURE = "gyroscope";
  static const String BATTERY_MEASURE = "battery";
  static const String BLUETOOTH_MEASURE = "bluetooth";
  static const String AUDIO_MEASURE = "audio";
  static const String NOICE_MEASURE = "noice";
  static const String LOCATION_MEASURE = "location";
  static const String CONNECTIVITY_MEASURE = "connectivity";
  static const String LIGHT_MEASURE = "light";
  static const String APPS_MEASURE = "apps";
  static const String TEXT_MESSAGE_LOG_MEASURE = "text_message_log";
  static const String TEXT_MESSAGE_MEASURE = "text_message";
  static const String SCREEN_MEASURE = "screen";
  static const String PHONELOG_MEASURE = "phone_log";
  static const String SOUND_MEASURE = "sound";
  static const String ACTIVITY_MEASURE = "activity";
  static const String APPLE_HEALTHKIT_MEASURE = "apple_healthkit";
  static const String GOOGLE_FIT_MEASURE = "google_fit";

  static List<Probe> _probes = new List();

  /// Returns a list of running probes.
  static List<Probe> get probes => _probes;

  /// If you create a probe manually, i.e. outside of the [ProbeRegistry] you can register it here.
  static void register(Probe probe) {
    _probes.add(probe);
  }

  /// Create an instance of a probe based on the measure type.
  static Probe create(Measure measure) {
    String type = measure.measureType;
    Probe _probe;

    switch (type) {
      case MEMORY_MEASURE:
        _probe = new MemoryPollingProbe(measure);
        break;
      case PEDOMETER_MEASURE:
        _probe = new PedometerProbe(measure);
        break;
      case ACCELEROMETER_MEASURE:
        _probe = new AccelerometerProbe(measure);
        break;
      case GYROSCOPE_MEASURE:
        _probe = new GyroscopeProbe(measure);
        break;
      case BATTERY_MEASURE:
        _probe = new BatteryProbe(measure);
        break;
      case BLUETOOTH_MEASURE:
        _probe = new BluetoothProbe(measure);
        break;
      case LOCATION_MEASURE:
        _probe = new LocationProbe(measure);
        break;
      case CONNECTIVITY_MEASURE:
        _probe = new ConnectivityProbe(measure);
        break;
      case LIGHT_MEASURE:
        _probe = new LightProbe(measure);
        break;
      case APPS_MEASURE:
        _probe = new AppsProbe(measure);
        break;
      case TEXT_MESSAGE_LOG_MEASURE:
        _probe = new TextMessageLogProbe(measure);
        break;
      case TEXT_MESSAGE_MEASURE:
        _probe = new TextMessageProbe(measure);
        break;
      case SCREEN_MEASURE:
        _probe = new ScreenProbe(measure);
        break;
      case PHONELOG_MEASURE:
        _probe = new PhoneLogProbe(measure);
        break;
      case AUDIO_MEASURE:
        _probe = new AudioProbe(measure);
        break;
      default:
        //_probe = new UserProbe(measure);
        break;
    }

    if (_probe != null) {
      _probe.name = measure.name;
      register(_probe);
    }

    return _probe;
  }
}
