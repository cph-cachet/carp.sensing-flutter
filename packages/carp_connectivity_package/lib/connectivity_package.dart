part of connectivity;

class ConnectivitySamplingPackage extends SmartphoneSamplingPackage {
  static const String CONNECTIVITY = "${NameSpace.CARP}.connectivity";
  static const String BLUETOOTH = "${NameSpace.CARP}.bluetooth";
  static const String WIFI = "${NameSpace.CARP}.wifi";

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
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)
        .add(BLUETOOTH, blueetothNameAnoymizer);
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)
        .add(WIFI, wifiNameAnoymizer);
  }

  // Bluetooth scan requires access to location - for some strange reason...
  List<Permission> get permissions => [Permission.location];

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.common
    ..name = 'Common (default) connectivity sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          CONNECTIVITY,
          CAMSMeasure(
            type: CONNECTIVITY,
            name: 'Connectivity (wifi/3G/...)',
            description: "Collects the phone's connectivity status",
            enabled: true,
          )),
      MapEntry(
          BLUETOOTH,
          PeriodicMeasure(
            type: BLUETOOTH,
            name: 'Nearby Devices',
            description: "Collects nearby devices using Bluetooth LE",
            enabled: true,
            frequency: Duration(minutes: 10),
            duration: Duration(seconds: 5),
          )),
      MapEntry(
          WIFI,
          PeriodicMeasure(
            type: WIFI,
            name: 'Wifi network names',
            description: "Collects the SSID and BSSID of nearby wifi network",
            enabled: true,
            frequency: Duration(minutes: 10),
            duration: Duration(seconds: 5),
          )),
    ]);

  SamplingSchema get light {
    SamplingSchema light = common
      ..type = SamplingSchemaType.light
      ..name = 'Light context sampling';
    (light.measures[BLUETOOTH] as PeriodicMeasure).enabled = false;
    return light;
  }

  SamplingSchema get minimum {
    SamplingSchema minimum = light
      ..type = SamplingSchemaType.light
      ..name = 'Light context sampling';
    (minimum.measures[CONNECTIVITY] as CAMSMeasure).enabled = false;
    (minimum.measures[WIFI] as PeriodicMeasure).enabled = false;
    return minimum;
  }

  SamplingSchema get normal => common..type = SamplingSchemaType.normal;

  SamplingSchema get debug => SamplingSchema()
    ..type = SamplingSchemaType.debug
    ..name = 'Debug connectivity sampling'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          CONNECTIVITY,
          CAMSMeasure(
            type: CONNECTIVITY,
            enabled: true,
          )),
      MapEntry(
          BLUETOOTH,
          PeriodicMeasure(
            type: BLUETOOTH,
            enabled: true,
            frequency: Duration(minutes: 1),
            duration: Duration(seconds: 2),
          )),
      MapEntry(
          WIFI,
          PeriodicMeasure(
            type: WIFI,
            enabled: true,
            frequency: Duration(minutes: 1),
            duration: Duration(seconds: 5),
          )),
    ]);
}
