part of mobile_sensing_app;

class ProbeDescription {
  static Map<String, String> get probeTypeDescription => {
        DataType.MEMORY: 'Collecting memory usage.',
        DataType.PEDOMETER: 'Collecting step counts on a regular basis.',
        DataType.ACCELEROMETER: "Collecting sensor data from the phone's onboard accelerometer.",
        DataType.GYROSCOPE: "Collecting sensor data from the phone's onboard gyroscope.",
        DataType.BATTERY: 'Collecting battery level and charging status.',
        DataType.BLUETOOTH: 'Collecting nearby bluetooth devices on a regular basis.',
        DataType.AUDIO: 'Records ambient sound on a regular basis.',
        DataType.NOISE: 'Records ambient noise level in decibel on a regular basis.',
        DataType.LOCATION: 'Collecting location information when moving.',
        DataType.CONNECTIVITY: 'Collecting information on connectivity status and mode.',
        DataType.LIGHT: 'Collecting ambient light in lux on a regular basis.',
        DataType.APPS: 'Collecting a list of installed apps.',
        DataType.APP_USAGE: 'Collecting app usage statistics.',
        DataType.TEXT_MESSAGE_LOG: 'Collecting the SMS message log.',
        DataType.TEXT_MESSAGE: 'Collecting in/out-going SMS text messages.',
        DataType.SCREEN: 'Collecting screen events (lock/unlock).',
        DataType.PHONE_LOG: 'Collects the phone call log.',
        DataType.ACTIVITY: 'Recognize the human activity, e.g. sitting, walking, biking, etc.',
        DataType.APPLE_HEALTHKIT: 'Collects health data from Apple Health Kit.',
        DataType.GOOGLE_FIT: 'Collects health data from Google Fit.',
        DataType.WEATHER: 'Collects local weather on a regular basis.'
      };

  static Map<String, Icon> get probeTypeIcon => {
        DataType.MEMORY: Icon(Icons.memory),
        DataType.PEDOMETER: Icon(Icons.directions_walk),
        DataType.ACCELEROMETER: Icon(Icons.adb),
        DataType.GYROSCOPE: Icon(Icons.adb),
        DataType.BATTERY: Icon(Icons.battery_charging_full),
        DataType.BLUETOOTH: Icon(Icons.bluetooth_searching),
        DataType.AUDIO: Icon(Icons.mic),
        DataType.NOISE: Icon(Icons.hearing),
        DataType.LOCATION: Icon(Icons.location_searching),
        DataType.CONNECTIVITY: Icon(Icons.wifi),
        DataType.LIGHT: Icon(Icons.highlight),
        DataType.APPS: Icon(Icons.apps),
        DataType.APP_USAGE: Icon(Icons.get_app),
        DataType.TEXT_MESSAGE_LOG: Icon(Icons.textsms),
        DataType.TEXT_MESSAGE: Icon(Icons.text_fields),
        DataType.SCREEN: Icon(Icons.screen_lock_portrait),
        DataType.PHONE_LOG: Icon(Icons.phone_android),
        DataType.ACTIVITY: Icon(Icons.directions_bike),
        DataType.APPLE_HEALTHKIT: Icon(Icons.healing),
        DataType.GOOGLE_FIT: Icon(Icons.directions_run),
        DataType.WEATHER: Icon(Icons.cloud)
      };
}
