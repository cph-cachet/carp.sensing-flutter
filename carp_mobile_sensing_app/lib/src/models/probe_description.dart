part of mobile_sensing_app;

class ProbeDescription {
  static Map<String, String> get probeTypeDescription => {
        DataType.UNKNOWN: 'Unknown Probe',
        DataType.NONE: 'Non-configured Probe',
        DataType.MEMORY: 'Collecting free physical and virtual memory.',
        DataType.DEVICE: 'Basic Device (Phone) Information.',
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
        DataType.WEATHER: 'Collects local weather on a regular basis.',
        DataType.GEOFENCE: 'Track movement in/our of this geofence.',
        CommunicationSamplingPackage.CALENDAR: 'Collects entries from phone calendars'
      };

  static Map<String, Icon> get probeTypeIcon => {
        DataType.UNKNOWN: Icon(Icons.error, size: 50, color: CACHET.GREY_4),
        DataType.NONE: Icon(Icons.report_problem, size: 50, color: CACHET.GREY_4),
        DataType.MEMORY: Icon(Icons.memory, size: 50, color: CACHET.GREY_4),
        DataType.DEVICE: Icon(Icons.phone_android, size: 50, color: CACHET.GREY_4),
        DataType.PEDOMETER: Icon(Icons.directions_walk, size: 50, color: CACHET.LIGHT_PURPLE),
        DataType.ACCELEROMETER: Icon(Icons.adb, size: 50, color: CACHET.GREY_4),
        DataType.GYROSCOPE: Icon(Icons.adb, size: 50, color: CACHET.GREY_4),
        DataType.BATTERY: Icon(Icons.battery_charging_full, size: 50, color: CACHET.GREEN),
        DataType.BLUETOOTH: Icon(Icons.bluetooth_searching, size: 50, color: CACHET.DARK_BLUE),
        DataType.AUDIO: Icon(Icons.mic, size: 50, color: CACHET.ORANGE),
        DataType.NOISE: Icon(Icons.hearing, size: 50, color: CACHET.YELLOW),
        DataType.LOCATION: Icon(Icons.location_searching, size: 50, color: CACHET.CYAN),
        DataType.CONNECTIVITY: Icon(Icons.wifi, size: 50, color: CACHET.GREEN),
        DataType.LIGHT: Icon(Icons.highlight, size: 50, color: CACHET.YELLOW),
        DataType.APPS: Icon(Icons.apps, size: 50, color: CACHET.LIGHT_GREEN),
        DataType.APP_USAGE: Icon(Icons.get_app, size: 50, color: CACHET.LIGHT_GREEN),
        DataType.TEXT_MESSAGE_LOG: Icon(Icons.textsms, size: 50, color: CACHET.LIGHT_PURPLE),
        DataType.TEXT_MESSAGE: Icon(Icons.text_fields, size: 50, color: CACHET.LIGHT_PURPLE),
        DataType.SCREEN: Icon(Icons.screen_lock_portrait, size: 50, color: CACHET.LIGHT_PURPLE),
        DataType.PHONE_LOG: Icon(Icons.phone_in_talk, size: 50, color: CACHET.ORANGE),
        DataType.ACTIVITY: Icon(Icons.directions_bike, size: 50, color: CACHET.ORANGE),
        DataType.APPLE_HEALTHKIT: Icon(Icons.healing, size: 50, color: CACHET.RED),
        DataType.GOOGLE_FIT: Icon(Icons.directions_run, size: 50, color: CACHET.GREEN),
        DataType.WEATHER: Icon(Icons.cloud, size: 50, color: CACHET.LIGHT_BLUE_2),
        DataType.GEOFENCE: Icon(Icons.location_on, size: 50, color: CACHET.CYAN),
        CommunicationSamplingPackage.CALENDAR: Icon(Icons.event, size: 50, color: CACHET.CYAN)
      };

  static Map<ProbeState, Icon> get probeStateIcon => {
        ProbeState.created: Icon(Icons.child_care, color: CACHET.GREY_4),
        ProbeState.initialized: Icon(Icons.check, color: CACHET.LIGHT_PURPLE),
        ProbeState.resumed: Icon(Icons.radio_button_checked, color: CACHET.GREEN),
        ProbeState.paused: Icon(Icons.radio_button_unchecked, color: CACHET.RED),
        ProbeState.stopped: Icon(Icons.close, color: CACHET.GREY_2)
      };
}
