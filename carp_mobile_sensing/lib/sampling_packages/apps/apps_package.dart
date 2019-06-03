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
        // there is an error in the device_apps plugin
        // see https://github.com/g123k/flutter_plugin_device_apps/issues/12
        // therefore the APPS probe is disabled right now.
        // TODO - add the AppsProbe once the plugin is fixed.
        //return null;
        return AppsProbe();
      case APP_USAGE:
        return AppUsageProbe();
      default:
        return null;
    }
  }

  void onRegister() {} // does nothing for this device sampling package

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) app sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          DataType.APPS,
          PeriodicMeasure(
            MeasureType(NameSpace.CARP, DataType.APPS),
            // collect list of installed apps once pr. day
            name: 'Installed Apps',
            enabled: true,
            frequency: 24 * 60 * 60 * 1000,
            //frequency: 60 * 1000
          )),
      MapEntry(
          DataType.APP_USAGE,
          PeriodicMeasure(MeasureType(NameSpace.CARP, DataType.APP_USAGE),
              // collect app usage every 10 min for the last 10 min
              name: 'Apps Usage',
              enabled: true,
              //frequency: 60 * 1000,
              frequency: 10 * 60 * 1000,
              duration: 10 * 60 * 1000)),
    ]);

  SamplingSchema get light => common;

  SamplingSchema get minimum => common;

  SamplingSchema get normal => common;
}
