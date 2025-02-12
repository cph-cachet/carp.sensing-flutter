/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of 'apps.dart';

/// Holds a list of names of apps installed on the device.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class Apps extends Data {
  static const dataType = AppsSamplingPackage.APPS;

  /// List of of installed apps.
  List<App> installedApps = [];

  Apps(this.installedApps) : super();

  @override
  Function get fromJsonFunction => _$AppsFromJson;
  factory Apps.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<Apps>(json);
  @override
  Map<String, dynamic> toJson() => _$AppsToJson(this);

  @override
  String toString() => '${super.toString()}, installedApps: $installedApps';
}

/// An application installed on the device.
/// Depending on the Android version, some attributes may not be available.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class App {
  /// Name of the package.
  String? packageName;

  /// Displayable name of the application.
  String? appName;

  /// Full path to the base APK for this application.
  String? apkFilePath;

  /// Public name of the application (e.g., 1.0.0).
  /// The version name of this package, as specified by the <manifest> tag's
  /// `versionName` attribute.
  String? versionName;

  /// Unique version id for the application.
  int? versionCode;

  /// Full path to the default directory assigned to the package for its
  /// persistent data.
  String? dataDir;

  /// Whether the application is installed in the device's system image
  /// An application downloaded by the user won't be a system app.
  bool? systemApp;

  /// The time at which the app was first installed in milliseconds.
  int? installTimeMillis;

  /// The time at which the app was last updated in milliseconds.
  int? updateTimeMillis;

  /// The category of this application.
  /// The information may come from the application itself or the system.
  String? category;

  /// Whether the app is enabled (installed and visible)
  /// or disabled (installed, but not visible).
  bool? enabled;

  /// What framework the app was built with.
  ///  * flutter,
  ///  * react_native,
  ///  * xamarin,
  ///  * ionic,
  ///  * native_or_others,
  String? builtWith;

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

  // App.fromApplication(Application application) : super() {
  //   packageName = application.packageName;
  //   appName = application.appName;
  //   apkFilePath = application.apkFilePath;
  //   versionName = application.versionName;
  //   versionCode = application.versionCode;
  //   dataDir = application.dataDir;
  //   systemApp = application.systemApp;
  //   installTimeMillis = application.installTimeMillis;
  //   updateTimeMillis = application.updateTimeMillis;
  //   enabled = application.enabled;
  //   category = application.category.name;
  // }

  /// Create an [App] object from an [AppInfo] object.
  App.fromAppInfo(AppInfo app) : super() {
    packageName = app.packageName;
    appName = app.name;
    // apkFilePath = app.apkFilePath;
    versionName = app.versionName;
    versionCode = app.versionCode;
    // dataDir = app.dataDir;
    // systemApp = app.systemApp;
    installTimeMillis = app.installedTimestamp;
    // updateTimeMillis = app.updateTimeMillis;
    // enabled = app.enabled;
    // category = app.category.name;
    builtWith = app.builtWith.name;
  }

  factory App.fromJson(Map<String, dynamic> json) => _$AppFromJson(json);
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

/// Holds a map of names of apps and their usage, as defined in [AppUsageInfo].
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class AppUsage extends Data {
  static const dataType = AppsSamplingPackage.APP_USAGE;

  DateTime start, end;

  /// A map from the full package name of an app and its usage.
  Map<String, AppUsageInfo> usage = {};

  AppUsage(this.start, this.end, [this.usage = const {}]) : super();

  @override
  Function get fromJsonFunction => _$AppUsageFromJson;
  factory AppUsage.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson<AppUsage>(json);
  @override
  Map<String, dynamic> toJson() => _$AppUsageToJson(this);

  @override
  String toString() =>
      '${super.toString()}, start: $start, end: $end, usage: $usage';
}

/// Holds information about usage for a specific app.
@JsonSerializable(includeIfNull: false, explicitToJson: true)
class AppUsageInfo {
  /// The full name of the application package
  String packageName;

  /// The name of the application
  String appName;

  /// The amount of time the application has been used
  /// in the specified interval
  Duration usage;

  /// The start of the interval
  DateTime startDate;

  /// The end of the interval
  DateTime endDate;

  /// Last time app was in foreground
  DateTime lastForeground;

  AppUsageInfo(
    this.packageName,
    this.appName,
    this.usage,
    this.startDate,
    this.endDate,
    this.lastForeground,
  );

  AppUsageInfo.fromAppUsageInfo(app_usage.AppUsageInfo info)
      : this(
          info.packageName,
          info.appName,
          info.usage,
          info.startDate,
          info.endDate,
          info.lastForeground,
        );

  factory AppUsageInfo.fromJson(Map<String, dynamic> json) =>
      _$AppUsageInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AppUsageInfoToJson(this);

  @override
  String toString() =>
      'App Usage: $packageName - $appName, duration: $usage [$startDate, $endDate]';
}
