part of mobile_sensing_app;

class ProbeDescriptor {
  String name, description;
  ProbeDescriptor(this.name, this.description);
}

class ProbeDescription {
  static Map<String, ProbeDescriptor> get descriptors => {
        DeviceSamplingPackage.FREE_MEMORY: ProbeDescriptor(
          'Memory',
          'Collecting free physical and virtual memory.',
        ),
        DeviceSamplingPackage.DEVICE_INFORMATION: ProbeDescriptor(
          'Device',
          'Basic Device (Phone) Information.',
        ),
        DeviceSamplingPackage.BATTERY_STATE: ProbeDescriptor(
          'Battery',
          'Collecting battery level and charging status.',
        ),
        SensorSamplingPackage.STEP_COUNT: ProbeDescriptor(
          'Pedometer',
          'Collecting step counts on a regular basis.',
        ),
        SensorSamplingPackage.ACCELERATION: ProbeDescriptor(
          'Accelerometer',
          "Collecting sensor data from the phone's onboard accelerometer.",
        ),
        SensorSamplingPackage.ROTATION: ProbeDescriptor(
          'Gyroscope',
          "Collecting sensor data from the phone's onboard gyroscope.",
        ),
        SensorSamplingPackage.AMBIENT_LIGHT: ProbeDescriptor(
          'Light',
          'Measures ambient light in lux on a regular basis.',
        ),
        ConnectivitySamplingPackage.BLUETOOTH: ProbeDescriptor(
          'Bluetooth',
          'Collecting nearby bluetooth devices on a regular basis.',
        ),
        ConnectivitySamplingPackage.WIFI: ProbeDescriptor(
          'Wifi',
          'Collecting names of connected wifi networks (SSID and BSSID)',
        ),
        ConnectivitySamplingPackage.CONNECTIVITY: ProbeDescriptor(
          'Connectivity',
          'Collecting information on connectivity status and mode.',
        ),
        MediaSamplingPackage.AUDIO: ProbeDescriptor(
          'Audio',
          'Records ambient sound on a regular basis.',
        ),
        MediaSamplingPackage.NOISE: ProbeDescriptor(
          'Noise',
          'Measures noise level in decibel on a regular basis.',
        ),
        AppsSamplingPackage.APPS: ProbeDescriptor(
          'Apps',
          'Collecting a list of installed apps.',
        ),
        AppsSamplingPackage.APP_USAGE: ProbeDescriptor(
          'App Usage',
          'Collects app usage statistics.',
        ),
        // CommunicationSamplingPackage.TEXT_MESSAGE_LOG: ProbeDescriptor(
        //   'Text Messages',
        //   'Collects the SMS message log.',
        // ),
        // CommunicationSamplingPackage.TEXT_MESSAGE: ProbeDescriptor(
        //   'Text Message',
        //   'Collecting in/out-going SMS text messages.',
        // ),
        // CommunicationSamplingPackage.PHONE_LOG: ProbeDescriptor(
        //   'Phone Log',
        //   'Collects the phone call log.',
        // ),
        // CommunicationSamplingPackage.CALENDAR: ProbeDescriptor(
        //   'Calendar',
        //   'Collects entries from phone calendars.',
        // ),
        DeviceSamplingPackage.SCREEN_EVENT: ProbeDescriptor(
          'Screen',
          'Collecting screen events (on/off/unlock).',
        ),
        ContextSamplingPackage.CURRENT_LOCATION: ProbeDescriptor(
          'Current Location',
          'Collecting location information.',
        ),
        ContextSamplingPackage.LOCATION: ProbeDescriptor(
          'Location Tracking',
          'Collecting location information.',
        ),
        ContextSamplingPackage.ACTIVITY: ProbeDescriptor(
          'Activity',
          'Recognize physical activity, e.g. sitting, walking, biking.',
        ),
        ContextSamplingPackage.WEATHER: ProbeDescriptor(
          'Weather',
          'Collects local weather.',
        ),
        ContextSamplingPackage.AIR_QUALITY: ProbeDescriptor(
          'Air Quality',
          'Collects local air quality.',
        ),
        ContextSamplingPackage.GEOFENCE: ProbeDescriptor(
          'Geofence',
          'Track movement in/out of this geofence.',
        ),
        ContextSamplingPackage.MOBILITY: ProbeDescriptor(
          'Mobility',
          'Mobility features calculated from location data.',
        ),
        ESenseSamplingPackage.ESENSE_BUTTON: ProbeDescriptor(
          'eSense Button',
          'eSense button events.',
        ),
        ESenseSamplingPackage.ESENSE_SENSOR: ProbeDescriptor(
          'eSense Movement',
          'eSense IMU sensor events.',
        ),
        PolarSamplingPackage.ACCELEROMETER: ProbeDescriptor(
          'Polar Accelerometer',
          'Polar IMU sensor events.',
        ),
        PolarSamplingPackage.GYROSCOPE: ProbeDescriptor(
          'Polar Gyroscope',
          'Polar IMU sensor events.',
        ),
        PolarSamplingPackage.MAGNETOMETER: ProbeDescriptor(
          'Polar Magnetometer',
          'Polar IMU sensor events.',
        ),
        PolarSamplingPackage.ECG: ProbeDescriptor(
          'Polar ECG',
          'Polar Electrocardiogram.',
        ),
        PolarSamplingPackage.HR: ProbeDescriptor(
          'Polar HR',
          'Polar Heart Rate.',
        ),
        PolarSamplingPackage.PPG: ProbeDescriptor(
          'Polar PPG',
          'Polar Photoplethysmograpy.',
        ),
        PolarSamplingPackage.PPI: ProbeDescriptor(
          'Polar PPI',
          'Polar Pulse-to-Pulse Interval.',
        ),
      };

  static Map<String, Icon> get probeTypeIcon => {
        DeviceSamplingPackage.FREE_MEMORY:
            Icon(Icons.memory, size: 50, color: CACHET.GREY_4),
        DeviceSamplingPackage.DEVICE_INFORMATION:
            Icon(Icons.phone_android, size: 50, color: CACHET.GREY_4),
        DeviceSamplingPackage.BATTERY_STATE:
            Icon(Icons.battery_charging_full, size: 50, color: CACHET.GREEN),
        SensorSamplingPackage.STEP_COUNT:
            Icon(Icons.directions_walk, size: 50, color: CACHET.LIGHT_PURPLE),
        SensorSamplingPackage.ACCELERATION:
            Icon(Icons.adb, size: 50, color: CACHET.GREY_4),
        SensorSamplingPackage.ROTATION:
            Icon(Icons.adb, size: 50, color: CACHET.GREY_4),
        SensorSamplingPackage.AMBIENT_LIGHT:
            Icon(Icons.highlight, size: 50, color: CACHET.YELLOW),
        ConnectivitySamplingPackage.BLUETOOTH:
            Icon(Icons.bluetooth_searching, size: 50, color: CACHET.DARK_BLUE),
        ConnectivitySamplingPackage.WIFI:
            Icon(Icons.wifi, size: 50, color: CACHET.LIGHT_PURPLE),
        ConnectivitySamplingPackage.CONNECTIVITY:
            Icon(Icons.cast_connected, size: 50, color: CACHET.GREEN),
        MediaSamplingPackage.AUDIO:
            Icon(Icons.mic, size: 50, color: CACHET.ORANGE),
        MediaSamplingPackage.NOISE:
            Icon(Icons.hearing, size: 50, color: CACHET.YELLOW),
        AppsSamplingPackage.APPS:
            Icon(Icons.apps, size: 50, color: CACHET.LIGHT_GREEN),
        AppsSamplingPackage.APP_USAGE:
            Icon(Icons.get_app, size: 50, color: CACHET.LIGHT_GREEN),
        // CommunicationSamplingPackage.TEXT_MESSAGE_LOG:
        //     Icon(Icons.textsms, size: 50, color: CACHET.LIGHT_PURPLE),
        // CommunicationSamplingPackage.TEXT_MESSAGE:
        //     Icon(Icons.text_fields, size: 50, color: CACHET.LIGHT_PURPLE),
        // CommunicationSamplingPackage.PHONE_LOG:
        //     Icon(Icons.phone_in_talk, size: 50, color: CACHET.ORANGE),
        // CommunicationSamplingPackage.CALENDAR:
        //     Icon(Icons.event, size: 50, color: CACHET.CYAN),
        DeviceSamplingPackage.SCREEN_EVENT: Icon(Icons.screen_lock_portrait,
            size: 50, color: CACHET.LIGHT_PURPLE),
        ContextSamplingPackage.CURRENT_LOCATION:
            Icon(Icons.location_searching, size: 50, color: CACHET.GREY_1),
        ContextSamplingPackage.LOCATION:
            Icon(Icons.location_searching, size: 50, color: CACHET.CYAN),
        ContextSamplingPackage.ACTIVITY:
            Icon(Icons.directions_bike, size: 50, color: CACHET.ORANGE),
        ContextSamplingPackage.WEATHER:
            Icon(Icons.cloud, size: 50, color: CACHET.LIGHT_BLUE_2),
        ContextSamplingPackage.AIR_QUALITY:
            Icon(Icons.air, size: 50, color: CACHET.GREY_3),
        ContextSamplingPackage.GEOFENCE:
            Icon(Icons.location_on, size: 50, color: CACHET.CYAN),
        ContextSamplingPackage.MOBILITY:
            Icon(Icons.location_on, size: 50, color: CACHET.ORANGE),
        ESenseSamplingPackage.ESENSE_BUTTON: Icon(Icons.radio_button_checked,
            size: 50, color: CACHET.LIGHT_PURPLE),
        ESenseSamplingPackage.ESENSE_SENSOR:
            Icon(Icons.headset, size: 50, color: CACHET.LIGHT_PURPLE),
        PolarSamplingPackage.ACCELEROMETER:
            Icon(Icons.moving, size: 50, color: CACHET.LIGHT_PURPLE),
        PolarSamplingPackage.GYROSCOPE:
            Icon(Icons.moving, size: 50, color: CACHET.LIGHT_PURPLE),
        PolarSamplingPackage.MAGNETOMETER:
            Icon(Icons.iron, size: 50, color: CACHET.LIGHT_PURPLE),
        PolarSamplingPackage.ECG:
            Icon(Icons.monitor_heart_rounded, size: 50, color: CACHET.GREEN),
        PolarSamplingPackage.HR:
            Icon(Icons.heart_broken, size: 50, color: CACHET.RED),
        PolarSamplingPackage.PPG:
            Icon(Icons.add_link, size: 50, color: CACHET.GREY_2),
        PolarSamplingPackage.PPI:
            Icon(Icons.link, size: 50, color: CACHET.GREY_3),
      };

  static Map<ExecutorState, String> get probeStateLabel => {
        ExecutorState.created: "Created",
        ExecutorState.initialized: "Initialized",
        ExecutorState.started: "Started",
        ExecutorState.stopped: "Stopped",
        ExecutorState.undefined: "Undefined",
      };

  static Map<ExecutorState, Icon> get probeStateIcon => {
        ExecutorState.created: Icon(Icons.child_care, color: CACHET.GREY_4),
        ExecutorState.initialized:
            Icon(Icons.check, color: CACHET.LIGHT_PURPLE),
        ExecutorState.started:
            Icon(Icons.radio_button_checked, color: CACHET.GREEN),
        ExecutorState.stopped:
            Icon(Icons.radio_button_unchecked, color: CACHET.GREEN),
        ExecutorState.undefined: Icon(Icons.error_outline, color: CACHET.RED),
      };
}
