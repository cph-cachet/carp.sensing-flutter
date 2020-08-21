part of runtime;

class SettingsBLoC {
  static const String USER_ID_KEY = "user.id";

  SharedPreferences _preferences;
  PackageInfo _packageInfo;
  String appName, packageName, version, buildNumber;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
    _packageInfo = await PackageInfo.fromPlatform();

    appName = _packageInfo.appName;
    packageName = _packageInfo.packageName;
    version = _packageInfo.version;
    buildNumber = _packageInfo.buildNumber;

    debug('Shared Preferences');
    _preferences.getKeys().forEach((key) => debug('[$key] = ${_preferences.get(key)}'));
  }

  SharedPreferences get preferences => _preferences;

  PackageInfo get packageInfo => _packageInfo;

  String get _userIdKey => '$appName.$USER_ID_KEY'.toLowerCase();

  String _userId;

  /// Get a user id that is;
  ///  * unique
  ///  * anonymous
  ///  * persistent
  ///
  /// This id is generated the first time this method is called and then stored on the phone
  /// in-between sessions, and will therefore be the same for the same app on the same phone.
  Future<String> get userId async {
    if (_userId == null) {
      _userId = preferences.get(_userIdKey);
      if (_userId == null) {
        _userId = Uuid().v4();
        preferences.setString(_userIdKey, _userId);
      }
    }
    return _userId;
  }
}

/// Misc. settings for CAMS.
final settings = SettingsBLoC();
