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
  static const String ONE_TIME_TRIGGER_KEY = 'one_time_trigger';

  static const String CARP_DATA_FILE_PATH = 'data';
  static const String CARP_RESOURCE_FILE_PATH = 'resources';
  // static const String CARP_QUEUE_FILE_PATH = 'queue';
  // static const String CARP_DEPLOYMENT_FILE_PATH = 'deployment';

  static final Settings _instance = Settings._();
  factory Settings() => _instance;
  Settings._();

  SharedPreferences? _preferences;
  PackageInfo? _packageInfo;
  String? _appName;
  String? _packageName;
  String? _version;
  String? _buildNumber;
  String? _localApplicationPath;
  String? _deploymentBasePath;

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
  String? get appName => _appName;

  /// The package name.
  /// `bundleIdentifier` on iOS, `getPackageName` on Android.
  String? get packageName => _packageName;

  /// The package version.
  /// `CFBundleShortVersionString` on iOS, `versionName` on Android.
  String? get version => _version;

  /// The build number.
  /// `CFBundleVersion` on iOS, `versionCode` on Android.
  String? get buildNumber => _buildNumber;

  /// A simple persistent store for simple data. Note that data is saved in
  /// plain format and should hence **not** be used for sensitive data.
  ///
  /// Wraps NSUserDefaults (on iOS) and SharedPreferences (on Android).
  SharedPreferences? get preferences => _preferences;

  /// Package information
  PackageInfo? get packageInfo => _packageInfo;

  /// Path to a directory where the application may place data that is
  /// user-generated.
  Future<String> get localApplicationPath async {
    if (_localApplicationPath == null) {
      final directory = await getApplicationDocumentsDirectory();
      _localApplicationPath = directory.path;
    }
    return _localApplicationPath!;
  }

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
              '${await localApplicationPath}/carp/deployments/$studyDeploymentId')
          .create(recursive: true);
      _deploymentBasePath = directory.path;
    }

    return _deploymentBasePath;
  }

  /// Initialize settings. Must be called before using any settings.
  Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
    _packageInfo ??= await PackageInfo.fromPlatform();

    _appName = _packageInfo!.appName;
    _packageName = _packageInfo!.packageName;
    _version = _packageInfo!.version;
    _buildNumber = _packageInfo!.buildNumber;

    await localApplicationPath;

    debug('Shared Preferences:');
    _preferences!
        .getKeys()
        .forEach((key) => debug('[$key] : ${_preferences!.get(key)}'));
    info('$runtimeType initialized');
  }

  String? _studyDeploymentId;

  /// Returns the study deployment id for the currently running deployment.
  /// Returns the deployment id cached locally on the phone (if available).
  /// Returns `null` if no study is deployed (yet).
  String? get studyDeploymentId =>
      (_studyDeploymentId ??= preferences!.getString(STUDY_DEPLOYMENT_ID_KEY));

  /// Set the study deployment id for the currently running deployment.
  /// This study deployment id will be cached locally on the phone.
  set studyDeploymentId(String? id) {
    assert(
        id != null,
        'Cannot set the study deployment id to null in Settings. '
        "Use the 'eraseStudyDeployment()' method to erase study deployment information.");
    _studyDeploymentId = id;
    preferences!.setString(STUDY_DEPLOYMENT_ID_KEY, id!);
  }

  /// Erase all study deployment information cached locally on this phone.
  Future<void> eraseStudyDeployment() async {
    _studyDeploymentId = null;
    _studyDeploymentStartTime = null;
    await preferences!.remove(STUDY_DEPLOYMENT_ID_KEY);
    await preferences!.remove(_studyDeploymentStartTimesKey);
  }

  DateTime? _studyDeploymentStartTime;
  String get _studyDeploymentStartTimesKey =>
      '$studyDeploymentId.$STUDY_START_KEY'.toLowerCase();

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
        "Setting is not initialized. Call 'Setting().init()' first.");
    if (_userId == null) {
      _userId = preferences!.get(USER_ID_KEY) as String?;
      if (_userId == null) {
        _userId = Uuid().v4();
        await preferences!.setString(USER_ID_KEY, _userId!);
      }
    }
    return _userId!;
  }
}

/// Debugging levels.
enum DebugLevel { NONE, INFO, WARNING, DEBUG }
