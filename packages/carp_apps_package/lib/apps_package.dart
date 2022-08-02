part of carp_apps_package;

class AppsSamplingPackage extends SmartphoneSamplingPackage {
  /// Measure type for one-time collection of apps installed on this phone.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String APPS = "dk.cachet.carp.apps";

  /// Measure type for one-time collection app usage information on apps that
  /// are installed on the phone.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use the [HistoricSamplingConfiguration] for configuration.
  static const String APP_USAGE = "dk.cachet.carp.app_usage";

  @override
  List<String> get dataTypes => [
        APPS,
        APP_USAGE,
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
  void onRegister() {} // does nothing for this device sampling package

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
