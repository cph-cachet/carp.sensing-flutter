part of connectivity;

class ConnectivitySamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for continous collection of connectivity status of the phone
  /// (none/mobile/wifi).
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String CONNECTIVITY = "${NameSpace.CARP}.connectivity";

  /// Measure type for collection of nearby Bluetooth devices on a regular basis.
  ///  * Periodic measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use a [PeriodicSamplingConfiguration] for configuration.
  static const String BLUETOOTH = "${NameSpace.CARP}.bluetooth";

  /// Measure type for collection of wifi information (SSID, BSSID, IP).
  ///  * Interval-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use a [IntervalSamplingConfiguration] for configuration.
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

  /// Default samplings schema for:
  ///  * [BLUETOOTH] - scanning every 5 minutes, sampling for 5 seconds
  ///  * [WIFI] - collecting every 10 minutes
  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        BLUETOOTH,
        PeriodicSamplingConfiguration(
          interval: const Duration(minutes: 5),
          duration: const Duration(seconds: 5),
        ))
    ..addConfiguration(
        WIFI,
        IntervalSamplingConfiguration(
          interval: const Duration(minutes: 10),
        ));
}
