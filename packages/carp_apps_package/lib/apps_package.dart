part of carp_apps_package;

class AppsSamplingPackage extends SmartphoneSamplingPackage {
  static const String APPS = "dk.cachet.carp.apps";
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

  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        APP_USAGE,
        HistoricSamplingConfiguration(
          future: Duration.zero,
          past: Duration(days: 1),
        ));
}
