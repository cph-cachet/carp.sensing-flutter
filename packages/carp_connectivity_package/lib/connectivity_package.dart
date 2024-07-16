part of connectivity;

class ConnectivitySamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for continuous collection of connectivity status of the phone
  /// (none/mobile/wifi).
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String CONNECTIVITY = "${NameSpace.CARP}.connectivity";

  /// Measure type for collection of nearby Bluetooth devices on a regular basis.
  ///  * Event-based (Periodic) measure - default every 10 minutes for 10 seconds.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use a [PeriodicSamplingConfiguration] for configuration.
  static const String BLUETOOTH = "${NameSpace.CARP}.bluetooth";

  /// Measure type for collection of wifi information (SSID, BSSID, IP).
  ///  * Event-based (Interval) measure - default every 10 minutes.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use a [IntervalSamplingConfiguration] for configuration.
  static const String WIFI = "${NameSpace.CARP}.wifi";

  @override
  DataTypeSamplingSchemeMap get samplingSchemes =>
      DataTypeSamplingSchemeMap.from([
        DataTypeSamplingScheme(
          CAMSDataTypeMetaData(
            type: CONNECTIVITY,
            displayName: "Connectivity Status",
            timeType: DataTimeType.POINT,
          ),
        ),
        DataTypeSamplingScheme(
            CAMSDataTypeMetaData(
              type: BLUETOOTH,
              displayName: "Bluetooth Scan of Nearby Devices",
              timeType: DataTimeType.TIME_SPAN,
              permissions: [Permission.bluetoothScan],
            ),
            PeriodicSamplingConfiguration(
              interval: const Duration(minutes: 10),
              duration: const Duration(seconds: 10),
            )),
        DataTypeSamplingScheme(
            CAMSDataTypeMetaData(
              type: WIFI,
              displayName: "Wifi Connectivity Status",
              timeType: DataTimeType.POINT,
            ),
            IntervalSamplingConfiguration(
              interval: const Duration(minutes: 10),
            )),
      ]);

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
    // register all data types
    FromJsonFactory().registerAll([
      Connectivity(),
      Bluetooth(),
      Wifi(),
    ]);

    // registering default privacy functions
    DataTransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .add(BLUETOOTH, blueetothNameAnoymizer);
    DataTransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .add(WIFI, wifiNameAnoymizer);
  }
}
