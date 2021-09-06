part of runtime;

/// Misc. settings for CAMS.
///
/// This class is a singleton, access using `Settings()`.
///
/// Supports:
///  * setting debug level - see [debugLevel]
///  * setting whether to save [AppTask]s across app re-start - see [saveAppTaskQueue]
///  * getting shared preferences - see [preferences]
///  * getting app info - see [packageInfo]
///  * generating a unique and annonymous user id - see [userId]
///
class Settings {
  static const String USER_ID_KEY = 'user_id';
  static const String STUDY_START_KEY = 'study_start';

  /// The path to use on the device for storing CARP data files.
  static const String CARP_DATA_FILE_PATH = 'carp/data';

  /// The path to use on the device for storing the AppTask queue.
  static const String CARP_QUEUE_FILE_PATH = 'carp/queue';

  /// The path to use on the device for storing CARP study files.
  static const String CARP_STUDY_FILE_PATH = 'carp/study';

  static final Settings _instance = Settings._();
  factory Settings() => _instance;
  Settings._();

  SharedPreferences? _preferences;
  PackageInfo? _packageInfo;
  String? _localApplicationDir;
  String? _dataPath;
  String? _queuePath;
  String? _studyPath;

  /// The global debug level setting.
  ///
  /// See [DebugLevel] for valid debug level settings.
  /// Can be changed on runtime.
  DebugLevel debugLevel = DebugLevel.WARNING;

  /// Save the queue of [AppTask]s in the [AppTaskController] across
  /// app re-start?
  bool saveAppTaskQueue = true;

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

  /// A simple persistent store for simple data. Note that data is saved in
  /// plain format and should hence **not** be used for sensitive data.
  ///
  /// Wraps NSUserDefaults (on iOS) and SharedPreferences (on Android).
  SharedPreferences? get preferences => _preferences;

  /// Package information
  PackageInfo? get packageInfo => _packageInfo;

  String? get localApplicationDir => _localApplicationDir;
  String? get dataPath => _dataPath;
  String? get queuePath => _queuePath;
  String? get studyPath => _studyPath;

  /// Initialize settings. Call before start using it.
  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    _packageInfo ??= await PackageInfo.fromPlatform();

    await initFilesystem();

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
  Future<String> get userId async {
    assert(_preferences != null,
        "Setting is not initialized. Call 'Setting().init()'' first.");
    if (_userId == null) {
      _userId = preferences!.get(_userIdKey) as String?;
      if (_userId == null) {
        _userId = Uuid().v4();
        await preferences!.setString(_userIdKey, _userId!);
      }
    }
    return _userId!;
  }

  Future<void> initFilesystem() async {
    if (_localApplicationDir == null) {
      final directory = await getApplicationDocumentsDirectory();
      _localApplicationDir = directory.path;
    }
    if (_dataPath == null) {
      final directory =
          await Directory('$_localApplicationDir/$CARP_DATA_FILE_PATH')
              .create(recursive: true);
      _dataPath = directory.path;
    }
    if (_queuePath == null) {
      final directory =
          await Directory('$_localApplicationDir/$CARP_QUEUE_FILE_PATH')
              .create(recursive: true);
      _queuePath = directory.path;
    }
    if (_studyPath == null) {
      final directory =
          await Directory('$_localApplicationDir/$CARP_STUDY_FILE_PATH')
              .create(recursive: true);
      _studyPath = directory.path;
    }
  }
}

enum DebugLevel { NONE, INFO, WARNING, DEBUG }
