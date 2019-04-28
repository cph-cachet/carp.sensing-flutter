part of connectivity;

class ConnectivitySamplingPackage implements SamplingPackage {
  static const String CONNECTIVITY = "connectivity";
  static const String BLUETOOTH = "bluetooth";

  List<String> get dataTypes => [
        CONNECTIVITY,
        BLUETOOTH,
      ];

  Probe create(String type) {
    switch (type) {
      case CONNECTIVITY:
        return ConnectivityProbe();
      case BLUETOOTH:
        return BluetoothProbe();
      default:
        return null;
    }
  }

  void onRegister() {
    TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).add(BLUETOOTH, blueetoth_name_anoymizer);
  }

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) connectivity sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          DataType.CONNECTIVITY,
          Measure(MeasureType(NameSpace.CARP, DataType.CONNECTIVITY),
              name: 'Connectivity (wifi/3G/...)', enabled: true)),
      MapEntry(
          DataType.BLUETOOTH,
          PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.BLUETOOTH),
              name: 'Nearby Devices (Bluetooth Scan)', enabled: true, frequency: 10 * 60 * 1000, duration: 10 * 1000)),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light connectivity sampling'
    ..measures[BLUETOOTH].enabled = false;

  SamplingSchema get minimum => light
    ..type = SamplingSchemaType.MINIMUM
    ..name = 'Minimum connectivity sampling'
    ..measures[CONNECTIVITY].enabled = false;

  SamplingSchema get normal => common;
}
