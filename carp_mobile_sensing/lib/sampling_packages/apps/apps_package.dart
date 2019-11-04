part of apps;

class AppsSamplingPackage implements SamplingPackage {
  static const String APPS = "apps";
  static const String APP_USAGE = "app_usage";

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

  List<PermissionGroup> get permissions => []; // no permission needed

  void onRegister() {} // does nothing for this device sampling package

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) app sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          APPS,
          Measure(
            MeasureType(NameSpace.CARP, APPS),
            name: 'Installed Apps',
          )),
      MapEntry(
          APP_USAGE,
          AppUsageMeasure(
            MeasureType(NameSpace.CARP, APP_USAGE),
            name: 'Apps Usage',
            enabled: true,
            duration: 60 * 60 * 1000, // collect app usage once pr. hour
          )),
    ]);

  SamplingSchema get light => common;

  SamplingSchema get minimum => common;

  SamplingSchema get normal => common;

  SamplingSchema get debug => SamplingSchema()
    ..type = SamplingSchemaType.DEBUG
    ..name = 'Debugging app sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          APPS,
          Measure(
            MeasureType(NameSpace.CARP, APPS),
            name: 'Installed Apps',
          )),
      MapEntry(
          APP_USAGE,
          AppUsageMeasure(
            MeasureType(NameSpace.CARP, APP_USAGE),
            name: 'Apps Usage',
            enabled: true,
            duration: 60 * 1000,
          )),
    ]);
}
