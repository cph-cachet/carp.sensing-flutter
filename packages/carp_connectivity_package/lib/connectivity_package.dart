part of connectivity;

class ConnectivitySamplingPackage extends SmartphoneSamplingPackage {
  static const String CONNECTIVITY = "${NameSpace.CARP}.connectivity";
  static const String BLUETOOTH = "${NameSpace.CARP}.bluetooth";
  static const String WIFI = "${NameSpace.CARP}.wifi";

  @override
  List<String> get dataTypes => [
        CONNECTIVITY,
        BLUETOOTH,
        WIFI,
      ];

  @override
  Probe? create(String type) {
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

  @override
  void onRegister() {
    // registering default privacy functions
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .add(BLUETOOTH, blueetothNameAnoymizer);
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .add(WIFI, wifiNameAnoymizer);
  }

  // Bluetooth scan requires access to location - for some strange reason...
  @override
  List<Permission> get permissions => [
        Permission.location,
        Permission.bluetoothScan,
      ];

  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        BLUETOOTH,
        IntervalSamplingConfiguration(
          interval: const Duration(minutes: 10),
        ))
    ..addConfiguration(
        WIFI,
        IntervalSamplingConfiguration(
          interval: const Duration(minutes: 10),
        ));
}
