part of '../runtime.dart';


class PushNotificationController extends NotificationController {
  static final PushNotificationController _instance =
      PushNotificationController._();
  PushNotificationController._() : super();

  /// The singleton [NotificationController].
  factory PushNotificationController() => _instance;

  final _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<void> initialize() async {
    if (_firebaseMessaging == null) {
      throw StateError('FirebaseMessaging is not initialized');
    }

    await _firebaseMessaging.requestPermission();

    final token = await _firebaseMessaging.getToken();
    debug('$runtimeType - PushNotificationController - token: $token');
    info('$runtimeType initialized.');
  }

  void registerPushNotificationHandler(Function onMessageReceived) {
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      debug(
          '$runtimeType - PushNotificationController - initial message: $message');
      if (message != null) {
        onMessageReceived(message);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debug('$runtimeType - PushNotificationController - onMessage: $message');
      onMessageReceived(message);
    });
  }

  @override
  Future<void> cancelNotification(int id) {
    // TODO: implement cancelNotification
    throw UnimplementedError();
  }

  @override
  Future<void> cancelTaskNotification(UserTask task) {
    // TODO: implement cancelTaskNotification
    throw UnimplementedError();
  }

  @override
  Future<int> createNotification(
      {int? id, required String title, String? body}) {
    // TODO: implement createNotification
    throw UnimplementedError();
  }

  @override
  Future<void> createTaskNotification(UserTask task) {
    // TODO: implement createTaskNotification
    throw UnimplementedError();
  }

  @override
  // TODO: implement pendingNotificationRequestsCount
  Future<int> get pendingNotificationRequestsCount =>
      throw UnimplementedError();

  @override
  Future<int> scheduleNotification(
      {int? id,
      required String title,
      String? body,
      required DateTime schedule}) {
    // TODO: implement scheduleNotification
    throw UnimplementedError();
  }

  @override
  Future<int> scheduleRecurrentNotifications(
      {int? id,
      required String title,
      String? body,
      required RecurrentScheduledTrigger schedule}) {
    // TODO: implement scheduleRecurrentNotifications
    throw UnimplementedError();
  }

  @override
  Future<void> scheduleTaskNotification(UserTask task) {
    // TODO: implement scheduleTaskNotification
    throw UnimplementedError();
  }
}
