part of carp_apps_package;

class AppsSamplingPackage extends SmartphoneSamplingPackage {
  static const String APPS = "dk.cachet.carp.apps";
  static const String APP_USAGE = "dk.cachet.carp.app_usage";

  List<String> get dataTypes => [
        APPS,
        APP_USAGE,
      ];

  Probe create(String type) {
    switch (type) {
      case APPS:
        return AppsProbe();
      case APP_USAGE:
        return AppUsageProbe();
      default:
        return null;
    }
  }

  List<Permission> get permissions => []; // no permission needed

  void onRegister() {} // does nothing for this device sampling package

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.common
    ..name = 'Common (default) app sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          APPS,
          CAMSMeasure(
            type: APPS,
            measureDescription: {
              'en': MeasureDescription(
                name: 'Installed Apps',
                description:
                    "Collects an list of the apps installed on this phone",
              )
            },
          )),
      MapEntry(
          APP_USAGE,
          MarkedMeasure(
            type: APP_USAGE,
            measureDescription: {
              'en': MeasureDescription(
                name: 'Apps Usage',
                description: "Collects an log of the use of apps on the phone",
              )
            },
            enabled: true,
          )),
    ]);

  SamplingSchema get light => common;
  SamplingSchema get minimum => common;
  SamplingSchema get normal => common;

  SamplingSchema get debug => SamplingSchema()
    ..type = SamplingSchemaType.debug
    ..name = 'Debugging app sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          APPS,
          CAMSMeasure(
            type: APPS,
          )),
      MapEntry(
          APP_USAGE,
          MarkedMeasure(
            type: APP_USAGE,
            enabled: true,
          )),
    ]);
}
