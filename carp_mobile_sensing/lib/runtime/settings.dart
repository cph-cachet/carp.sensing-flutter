part of runtime;

class SettingsBLoC {
  static const String USER_ID_KEY = "user_id";
  static const String INSTALL_DATE_KEY = "install_date";
  static const String COMPLETED_TASKS_KEY = "completed_tasks";

  SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get preferences async {
    if (_preferences == null) _preferences = await SharedPreferences.getInstance();
    return _preferences;
  }

  String _userId;

  /// A unique anonymous user id.
  ///
  /// This id is stored on the phone in-between session and should therefore be the same for the same phone.
  Future<String> get userId async {
    if (_userId == null) {
      _userId = (await preferences).get(USER_ID_KEY);
      if (_userId == null) {
        _userId = Uuid().v4();
        (await preferences).setString(USER_ID_KEY, _userId);
      }
    }
    return _userId;
  }
}

final settings = SettingsBLoC();
