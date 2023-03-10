part of carp_apps_package;

class AppsSamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for one-time collection of apps installed on this phone.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String APPS = "${NameSpace.CARP}.apps";

  /// Measure type for one-time collection app usage information on apps that
  /// are installed on the phone.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use the [HistoricSamplingConfiguration] for configuration.
  static const String APP_USAGE = "${NameSpace.CARP}.appusage";

  @override
  List<DataTypeMetaData> get dataTypes => [
        DataTypeMetaData(
          type: APPS,
          displayName: "Installed Apps",
          timeType: DataTimeType.POINT,
        ),
        DataTypeMetaData(
          type: APP_USAGE,
          displayName: "App Usage",
          timeType: DataTimeType.TIME_SPAN,
        ),
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case APPS:
        return (Platform.isAndroid) ? AppsProbe() : null;
      case APP_USAGE:
        return (Platform.isAndroid) ? AppUsageProbe() : null;
      default:
        return null;
    }
  }

  @override
  List<Permission> get permissions => []; // no permission needed

  @override
  void onRegister() {
    FromJsonFactory().registerAll([
      Apps([]),
      AppUsage(DateTime.now(), DateTime.now()),
    ]);
  }

  /// Default samplings schema for:
  ///  * [APP_USAGE] - one day back in time.
  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        APP_USAGE,
        HistoricSamplingConfiguration(
          future: Duration.zero,
          past: Duration(days: 1),
        ));
}
