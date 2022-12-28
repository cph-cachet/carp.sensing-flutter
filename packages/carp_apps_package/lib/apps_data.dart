/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_apps_package;

/// Holds a list of names of apps installed on the device.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Apps extends Data {
  static const dataType = AppsSamplingPackage.APPS;

  /// List of of installed apps.
  List<App> installedApps = [];

  Apps(this.installedApps) : super();

  factory Apps.fromJson(Map<String, dynamic> json) => _$AppsFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppsToJson(this);

  @override
  String toString() => '${super.toString()}, installedApps: $installedApps';
}

/// An application installed on the device
/// Depending on the Android version, some attributes may not be available
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class App {
  /// Name of the package
  String? packageName;

  /// Displayable name of the application
  String? appName;

  /// Full path to the base APK for this application
  String? apkFilePath;

  /// Public name of the application (eg: 1.0.0)
  /// The version name of this package, as specified by the <manifest> tag's
  /// `versionName` attribute
  String? versionName;

  /// Unique version id for the application
  int? versionCode;

  /// Full path to the default directory assigned to the package for its
  /// persistent data
  String? dataDir;

  /// Whether the application is installed in the device's system image
  /// An application downloaded by the user won't be a system app
  bool? systemApp;

  /// The time at which the app was first installed
  int? installTimeMillis;

  /// The time at which the app was last updated
  int? updateTimeMillis;

  /// The category of this application
  /// The information may come from the application itself or the system
  String? category;

  /// Whether the app is enabled (installed and visible)
  /// or disabled (installed, but not visible)
  bool? enabled;

  App({
    this.packageName,
    this.appName,
    this.apkFilePath,
    this.versionName,
    this.versionCode,
    this.dataDir,
    this.systemApp,
    this.installTimeMillis,
    this.updateTimeMillis,
    this.category,
    this.enabled,
  }) : super();

  App.fromApplication(Application application) : super() {
    packageName = application.packageName;
    appName = application.appName;
    apkFilePath = application.apkFilePath;
    versionName = application.versionName;
    versionCode = application.versionCode;
    dataDir = application.dataDir;
    systemApp = application.systemApp;
    installTimeMillis = application.installTimeMillis;
    updateTimeMillis = application.updateTimeMillis;
    enabled = application.enabled;
    category = application.category.name;
  }

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppToJson(this);

  @override
  String toString() {
    return 'App {'
        'appName: $appName, '
        'apkFilePath: $apkFilePath, '
        'packageName: $packageName, '
        'versionName: $versionName, '
        'versionCode: $versionCode, '
        'dataDir: $dataDir, '
        'systemApp: $systemApp, '
        'installTimeMillis: $installTimeMillis, '
        'updateTimeMillis: $updateTimeMillis, '
        'category: $category, '
        'enabled: $enabled'
        '}';
  }
}

/// Holds a map of names of apps and their corresponding usage in seconds.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class AppUsage extends Data {
  static const dataType = AppsSamplingPackage.APP_USAGE;

  DateTime start, end;

  /// A map of names of apps and their usage in seconds.
  Map<String, int> usage = {};

  AppUsage(this.start, this.end, [this.usage = const {}]) : super();

  factory AppUsage.fromJson(Map<String, dynamic> json) =>
      _$AppUsageFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AppUsageToJson(this);

  @override
  String toString() =>
      '${super.toString()}, start: $start, end: $end, usage: $usage';
}
