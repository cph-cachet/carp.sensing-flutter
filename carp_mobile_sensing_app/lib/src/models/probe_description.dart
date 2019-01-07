part of mobile_sensing_app;

class ProbeDescription {
  static Map<String, String> get probeTypeDescription => {
        DataType.MEMORY: 'Collecting free physical and virtual memory.',
        DataType.PEDOMETER: 'Collecting step counts on a regular basis.',
        DataType.ACCELEROMETER: "Collecting sensor data from the phone's onboard accelerometer.",
        DataType.GYROSCOPE: "Collecting sensor data from the phone's onboard gyroscope.",
        DataType.BATTERY: 'Collecting battery level and charging status.',
        DataType.BLUETOOTH: 'Collecting nearby bluetooth devices on a regular basis.',
        DataType.AUDIO: 'Records ambient sound on a regular basis.',
        DataType.NOISE: 'Measures noise level in decibel on a regular basis.',
        DataType.LOCATION: 'Collecting location information when moving.',
        DataType.CONNECTIVITY: 'Collecting information on connectivity status and mode.',
        DataType.LIGHT: 'Measures ambient light in lux on a regular basis.',
        DataType.APPS: 'Collecting a list of installed apps.',
        DataType.APP_USAGE: 'Collecting app usage statistics.',
        DataType.TEXT_MESSAGE_LOG: 'Collecting the SMS message log.',
        DataType.TEXT_MESSAGE: 'Collecting in/out-going SMS text messages.',
        DataType.SCREEN: 'Collecting screen events (on/off/unlock).',
        DataType.PHONE_LOG: 'Collects the phone call log.',
        DataType.ACTIVITY: 'Recognize physical activity, e.g. sitting, walking, biking, etc.',
        DataType.APPLE_HEALTHKIT: 'Collects health data from Apple Health Kit.',
        DataType.GOOGLE_FIT: 'Collects health data from Google Fit.',
        DataType.WEATHER: 'Collects local weather on a regular basis.'
      };

  static Map<String, Icon> get probeTypeIcon => {
        DataType.MEMORY: Icon(Icons.memory, color: CACHET.GREY_4),
        DataType.PEDOMETER: Icon(Icons.directions_walk, color: CACHET.LIGHT_PURPLE),
        DataType.ACCELEROMETER: Icon(Icons.adb, color: CACHET.GREY_4),
        DataType.GYROSCOPE: Icon(Icons.adb, color: CACHET.GREY_4),
        DataType.BATTERY: Icon(Icons.battery_charging_full, color: CACHET.GREEN),
        DataType.BLUETOOTH: Icon(Icons.bluetooth_searching, color: CACHET.DARK_BLUE),
        DataType.AUDIO: Icon(Icons.mic, color: CACHET.ORANGE),
        DataType.NOISE: Icon(Icons.hearing, color: CACHET.YELLOW),
        DataType.LOCATION: Icon(Icons.location_searching, color: CACHET.CYAN),
        DataType.CONNECTIVITY: Icon(Icons.wifi, color: CACHET.GREEN),
        DataType.LIGHT: Icon(Icons.highlight, color: CACHET.YELLOW),
        DataType.APPS: Icon(Icons.apps, color: CACHET.LIGHT_GREEN),
        DataType.APP_USAGE: Icon(Icons.get_app, color: CACHET.LIGHT_GREEN),
        DataType.TEXT_MESSAGE_LOG: Icon(Icons.textsms, color: CACHET.LIGHT_PURPLE),
        DataType.TEXT_MESSAGE: Icon(Icons.text_fields, color: CACHET.LIGHT_PURPLE),
        DataType.SCREEN: Icon(Icons.screen_lock_portrait, color: CACHET.LIGHT_PURPLE),
        DataType.PHONE_LOG: Icon(Icons.phone_android, color: CACHET.ORANGE),
        DataType.ACTIVITY: Icon(Icons.directions_bike, color: CACHET.ORANGE),
        DataType.APPLE_HEALTHKIT: Icon(Icons.healing, color: CACHET.RED),
        DataType.GOOGLE_FIT: Icon(Icons.directions_run, color: CACHET.GREEN),
        DataType.WEATHER: Icon(Icons.cloud, color: CACHET.LIGHT_BLUE_2)
      };

  static Map<ProbeStateType, Icon> get probeStateIcon => {
        ProbeStateType.created: Icon(Icons.child_care, color: CACHET.GREY_4),
        ProbeStateType.initialized: Icon(Icons.check, color: CACHET.LIGHT_PURPLE),
        ProbeStateType.resumed: Icon(Icons.play_arrow, color: CACHET.GREEN),
        ProbeStateType.paused: Icon(Icons.pause, color: CACHET.RED),
        ProbeStateType.stopped: Icon(Icons.close, color: CACHET.GREY_2)
      };
}
