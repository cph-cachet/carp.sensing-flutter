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
  static const String STUDY_DEPLOYMENT_ID_KEY = 'study_deployment_id';

  static const String CARP_DATA_FILE_PATH = 'data';
  static const String CARP_RESOURCE_FILE_PATH = 'resources';
  // static const String CARP_QUEUE_FILE_PATH = 'queue';
  // static const String CARP_DEPLOYMENT_FILE_PATH = 'deployment';

  static final Settings _instance = Settings._();
  factory Settings() => _instance;
  Settings._();

  SharedPreferences? _preferences;
  PackageInfo? _packageInfo;
  String? _localApplicationPath;
  String? _deploymentBasePath;
  // String? _dataPath;
  // String? _queuePath;
  // String? _deploymentPath;

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

  /// Path to a directory where the application may place data that is
  /// user-generated.
  String? get localApplicationPath => _localApplicationPath;

  /// The base path for storing all CARP related files on the form
  ///
  ///  `<localApplicationPath>/carp/deployments/<study_deployment_id>`
  ///
  Future<String?> get deploymentBasePath async {
    assert(
      studyDeploymentId != null,
      'Cannot create file path for deployment - studyDeploymentId is null',
    );
    if (_deploymentBasePath == null) {
      final directory = await Directory(
              '$_localApplicationPath/carp/deployments/$studyDeploymentId')
          .create(recursive: true);
      _deploymentBasePath = directory.path;
    }

    return _deploymentBasePath;
  }

  // /// The path to use on the device for storing CARP data files.
  // String? get dataPath => _dataPath;

  // /// The path to use on the device for storing the AppTask queue.
  // String? get queuePath => _queuePath;

  // /// The path to use on the device for storing CARP study files.
  // String? get deploymentPath => _deploymentPath;

  /// Initialize settings. Must be called before using any settings.
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

  String? _studyDeploymentId;

  String get _studyDeploymentIdKey =>
      '$appName.$STUDY_DEPLOYMENT_ID_KEY'.toLowerCase();

  /// Returns the study deployment id for the currently running deployment.
  /// Returns the deployment id cached locally on the phone (if available).
  /// Returns `null` if no study is deployed (yet).
  String? get studyDeploymentId =>
      (_studyDeploymentId ??= preferences!.getString(_studyDeploymentIdKey));

  /// Set the study deployment id for the currently running deployment.
  /// This deployment id will be cached locally on the phone.
  set studyDeploymentId(String? id) {
    assert(
        id != null,
        'Cannot set the study deployment id to null in Settings. '
        "Use the 'eraseStudyDeployment()' method to erase study deployment information.");
    _studyDeploymentId = id;
    preferences!.setString(_studyDeploymentIdKey, id!);
  }

  /// Erase all study deployment information cached locally on this phone.
  Future<void> eraseStudyDeployment() async {
    _studyDeploymentId = null;
    _studyDeploymentStartTime = null;
    await preferences!.remove(_studyDeploymentIdKey);
    await preferences!.remove(_studyDeploymentStartTimesKey);
  }

  DateTime? _studyDeploymentStartTime;
  String get _studyDeploymentStartTimesKey =>
      '$studyDeploymentId.${Settings.STUDY_START_KEY}'.toLowerCase();

  /// The timestamp (in UTC) when the current study deployment was started on
  /// this phone.
  ///
  /// By using the [markStudyDeploymentAsStarted] method, this timestamp is save
  /// on the phone the first time a study is deployed and persistently saved
  /// across app restarts.
  ///
  /// Returns `null` if no timestamp is found. In this case, consider calling
  /// [markStudyDeploymentAsStarted].
  Future<DateTime?> get studyDeploymentStartTime async {
    assert(preferences != null,
        "Setting is not initialized. Call 'Setting().init()' first.");
    assert(studyDeploymentId != null,
        "Study deployment id is not set. Assign the 'studyDeploymentId' first.");
    if (_studyDeploymentStartTime == null) {
      String? str = preferences!.get(_studyDeploymentStartTimesKey) as String?;
      _studyDeploymentStartTime = (str != null) ? DateTime.parse(str) : null;
    }
    return _studyDeploymentStartTime;
  }

  /// Mark the study deployment as started.
  Future<void> markStudyDeploymentAsStarted() async {
    _studyDeploymentStartTime = DateTime.now().toUtc();
    await preferences!.setString(
        _studyDeploymentStartTimesKey, _studyDeploymentStartTime.toString());
    info(
        '$runtimeType - Study deployment start time set to $_studyDeploymentStartTime');
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
    if (_localApplicationPath == null) {
      final directory = await getApplicationDocumentsDirectory();
      _localApplicationPath = directory.path;
    }
    // if (_dataPath == null) {
    //   final directory =
    //       await Directory('$_localApplicationPath/$CARP_DATA_FILE_PATH')
    //           .create(recursive: true);
    //   _dataPath = directory.path;
    // }
    // if (_queuePath == null) {
    //   final directory =
    //       await Directory('$_localApplicationPath/$CARP_QUEUE_FILE_PATH')
    //           .create(recursive: true);
    //   _queuePath = directory.path;
    // }
    // if (_deploymentPath == null) {
    //   final directory =
    //       await Directory('$_localApplicationPath/$CARP_DEPLOYMENT_FILE_PATH')
    //           .create(recursive: true);
    //   _deploymentPath = directory.path;
    // }
  }
}

enum DebugLevel { NONE, INFO, WARNING, DEBUG }
