part of connectivity;

class ConnectivitySamplingPackage implements SamplingPackage {
  static const String CONNECTIVITY = "connectivity";
  static const String BLUETOOTH = "bluetooth";
  static const String WIFI = "wifi";

  List<String> get dataTypes => [
        CONNECTIVITY,
        BLUETOOTH,
        WIFI,
      ];

  Probe create(String type) {
    switch (type) {
      case CONNECTIVITY:
        return ConnectivityProbe();
      case BLUETOOTH:
        return BluetoothProbe();
      case WIFI:
        return WifiProbe();
      default:
        return null;
    }
  }

  void onRegister() {
    // registering default privacy functions
    TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).add(BLUETOOTH, blueetothNameAnoymizer);
    TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).add(WIFI, wifiNameAnoymizer);
  }

  //List<PermissionGroup> get permissions => [];

  // Bluetooth scan requires access to location - for some strange reason...
  List<Permission> get permissions => [Permission.location];

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) connectivity sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          CONNECTIVITY,
          Measure(
            MeasureType(NameSpace.CARP, CONNECTIVITY),
            name: 'Connectivity (wifi/3G/...)',
            enabled: true,
          )),
      MapEntry(
          BLUETOOTH,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, BLUETOOTH),
            name: 'Nearby Devices (Bluetooth Scan)',
            enabled: true,
            frequency: Duration(minutes: 10),
            duration: Duration(seconds: 5),
          )),
      MapEntry(
          WIFI,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, WIFI),
            name: 'Wifi network names (SSID / BSSID)',
            enabled: true,
            frequency: Duration(minutes: 10),
            duration: Duration(seconds: 5),
          )),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light connectivity sampling'
    ..measures[BLUETOOTH].enabled = false;

  SamplingSchema get minimum => light
    ..type = SamplingSchemaType.MINIMUM
    ..name = 'Minimum connectivity sampling'
    ..measures[CONNECTIVITY].enabled = false
    ..measures[WIFI].enabled = false;

  SamplingSchema get normal => common..type = SamplingSchemaType.NORMAL;

  SamplingSchema get debug => SamplingSchema()
    ..type = SamplingSchemaType.DEBUG
    ..name = 'Debug connectivity sampling'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          CONNECTIVITY,
          Measure(
            MeasureType(NameSpace.CARP, CONNECTIVITY),
            name: 'Connectivity (wifi/3G/...)',
            enabled: true,
          )),
      MapEntry(
          BLUETOOTH,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, BLUETOOTH),
            name: 'Nearby Devices (Bluetooth Scan)',
            enabled: true,
            frequency: Duration(minutes: 1),
            duration: Duration(seconds: 2),
          )),
      MapEntry(
          WIFI,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, WIFI),
            name: 'Wifi network names (SSID / BSSID)',
            enabled: true,
            frequency: Duration(minutes: 1),
            duration: Duration(seconds: 5),
          )),
    ]);
}
