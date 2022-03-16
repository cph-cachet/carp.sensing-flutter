part of carp_apps_package;

class AppsSamplingPackage extends SmartphoneSamplingPackage {
  static const String APPS = "dk.cachet.carp.apps";
  static const String APP_USAGE = "dk.cachet.carp.app_usage";

  List<String> get dataTypes => [
        APPS,
        APP_USAGE,
      ];

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

  List<Permission> get permissions => []; // no permission needed

  void onRegister() {} // does nothing for this device sampling package

  SamplingSchema get common => SamplingSchema(
        type: SamplingSchemaType.common,
        name: 'Common (default) app sampling schema',
        powerAware: true,
      )..measures.addEntries([
          MapEntry(
              APPS,
              CAMSMeasure(
                type: APPS,
                name: 'Installed Apps',
                description:
                    "Collects an list of the apps installed on this phone",
              )),
          MapEntry(
              APP_USAGE,
              MarkedMeasure(
                type: APP_USAGE,
                name: 'Apps Usage',
                description: "Collects an log of the use of apps on the phone",
              )),
        ]);

  SamplingSchema get light => common;
  SamplingSchema get minimum => common;
  SamplingSchema get normal => common;
  SamplingSchema get debug => common;
}
