part of runtime;

/// A [NotificationController] based on the [awesome_notifications](https://pub.dev/packages/awesome_notifications)
/// Flutter plugin.

class AwesomeNotificationController implements NotificationController {
  static final AwesomeNotificationController _instance =
      AwesomeNotificationController._();
  AwesomeNotificationController._() : super();

  /// The singleton [NotificationController].
  factory AwesomeNotificationController() => _instance;

  @override
  void cancelNotification(UserTask task) async {
    await AwesomeNotifications().cancelAllSchedules();
  }

  @override
  Future<void> initialize() async {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic Notifications',
          channelDescription: "Basic Notifications",
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          channelDescription: "Scheduled Notifications",
          locked: true,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
    );

    // ask for permissions to use notifications
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    info('$runtimeType initialized.');
  }

  @override
  Future<int> get pendingNotificationRequestsCount async =>
      (await AwesomeNotifications().listScheduledNotifications()).length;

  /// Schedule a notification for a [task] at the [UserTask.triggerTime].
  @override
  Future<void> scheduleNotification(UserTask task) async {
    // early out if not to be scheduled
    if (!task.notification) return;

    // early out if has already been scheduled
    // this is relevant for AwecomeNotification since it makes notifications
    // persistent across app re-start
    if (task.hasNotificationBeenCreated) {
      debug('$runtimeType - task has already been scheduled - task: $task');
      return;
    }

    if (task.triggerTime.isAfter(DateTime.now())) {
      final time = tz.TZDateTime.from(
          task.triggerTime, tz.getLocation(Settings().timezone));

      await AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: task.id.hashCode,
              channelKey: 'scheduled_channel',
              title: task.title,
              body: task.description,
              notificationLayout: NotificationLayout.Default),
          schedule: NotificationCalendar.fromDate(
              date: task.triggerTime, allowWhileIdle: true));
      task.hasNotificationBeenCreated = true;
      debug('$runtimeType - Notification scheduled for $task at $time');
    } else {
      warning('$runtimeType - Can only schedule a notification in the future. '
          'task trigger time: ${task.triggerTime}.');
    }
  }

  /// Send an immediate notification for a [task].
  @override
  Future<void> sendNotification(UserTask task) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: task.id.hashCode,
          channelKey: 'basic_channel',
          title: task.title,
          body: task.description,
          notificationLayout: NotificationLayout.Default),
    );
  }
}
