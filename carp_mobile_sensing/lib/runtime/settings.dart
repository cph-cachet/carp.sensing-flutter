part of runtime;

/// Misc. settings for CAMS.
///
/// This class is a singleton, access using `Settings()`.
///
/// Supports:
///  * setting debug level - see [debugLevel]
///  * getting shared preferences - see [preferences]
///  * getting app info - see [packageInfo]
///  * generating a unique and annonymous user id - see [userId]
///  * keeping track of study start time - see [studyStartTimestamp]
///
class Settings {
  static const String USER_ID_KEY = 'user_id';
  static const String STUDY_START_KEY = 'study_start';
  static final Settings _instance = Settings._();

  factory Settings() => _instance;

  Settings._() {
    // registerFromJsonFunctions();
  }

  SharedPreferences? _preferences;
  PackageInfo? _packageInfo;

  /// The global debug level setting.
  ///
  /// See [DebugLevel] for valid debug level settings.
  /// Can be changed on runtime.
  int debugLevel = DebugLevel.WARNING;

  /// The app name.
  /// `CFBundleDisplayName` on iOS, `application/label` on Android.
  String? appName;

  /// The package name.
  /// `bundleIdentifier` on iOS, `getPackageName` on Android.
  String? packageName;

  /// The package version.
  /// `CFBundleShortVersionString` on iOS, `versionName` on Android.
  String? version;

  /// The build number.
  /// `CFBundleVersion` on iOS, `versionCode` on Android.
  String? buildNumber;

  /// Wraps NSUserDefaults (on iOS) and SharedPreferences (on Android), providing
  /// a persistent store for simple data.
  SharedPreferences? get preferences => _preferences;

  /// Package information
  PackageInfo? get packageInfo => _packageInfo;

  /// Initialize settings. Call before start using it.
  Future init() async {
    _preferences ??= await SharedPreferences.getInstance();
    _packageInfo ??= await PackageInfo.fromPlatform();

    appName = _packageInfo!.appName;
    packageName = _packageInfo!.packageName;
    version = _packageInfo!.version;
    buildNumber = _packageInfo!.buildNumber;

    debug('Shared Preferences:');
    _preferences!
        .getKeys()
        .forEach((key) => debug('[$key] : ${_preferences!.get(key)}'));
    info('$runtimeType initialized');
  }

  String? _userId;
  String get _userIdKey => '$appName.$USER_ID_KEY'.toLowerCase();

  /// Generate a user id that is;
  ///  * unique
  ///  * anonymous
  ///  * persistent
  ///
  /// This id is generated the first time this method is called and then stored
  /// on the phone in-between sessions, and will therefore be the same for
  /// the same app on the same phone.
  Future<String?> get userId async {
    if (_userId == null) {
      _userId = preferences!.get(_userIdKey) as String?;
      if (_userId == null) {
        _userId = Uuid().v4();
        await preferences!.setString(_userIdKey, _userId!);
      }
    }
    return _userId;
  }

  DateTime? _studyStartTimestamp;
  String get _studyStartTimestampKey =>
      '$appName.$STUDY_START_KEY'.toLowerCase();

  /// The timestamp (in UTC) when the current study was started on this phone.
  /// This timestamp is save on the phone the first time a study is started.
  Future<DateTime?> get studyStartTimestamp async {
    if (_studyStartTimestamp == null) {
      String? str = preferences!.get(_studyStartTimestampKey) as String?;
      _studyStartTimestamp = (str != null) ? DateTime.parse(str) : null;
      if (_studyStartTimestamp == null) {
        _studyStartTimestamp = DateTime.now().toUtc();
        await preferences!.setString(
            _studyStartTimestampKey, _studyStartTimestamp.toString());
      }
    }
    return _studyStartTimestamp;
  }
}

class DebugLevel {
  static const int NONE = 0;
  static const int INFO = 1;
  static const int WARNING = 2;
  static const int DEBUG = 3;
}
