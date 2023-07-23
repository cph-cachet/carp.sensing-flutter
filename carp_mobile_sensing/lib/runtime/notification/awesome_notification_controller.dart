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
  Future<void> initialize() async {
    AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelKey: NotificationController.CHANNEL_ID,
          channelName: NotificationController.CHANNEL_NAME,
          channelDescription: NotificationController.CHANNEL_DESCRIPTION,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: NotificationController.SCHEDULED_CHANNEL_ID,
          channelName: NotificationController.SCHEDULED_CHANNEL_NAME,
          channelDescription:
              NotificationController.SCHEDULED_CHANNEL_DESCRIPTION,
          locked: true,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
      ],
    );

    // listen to when the use clicks a notification
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
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

  @override
  Future<void> scheduleNotification(UserTask task) async {
    // early out if not to be scheduled
    if (!task.notification) return;

    // early out if has already been scheduled
    // this is relevant for AwesomeNotification since it makes notifications
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
              channelKey: NotificationController.SCHEDULED_CHANNEL_ID,
              title: task.title,
              body: task.description,
              payload: {'task_id': task.id},
              wakeUpScreen: true,
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

  @override
  Future<void> sendNotification(UserTask task) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: task.id.hashCode,
          channelKey: NotificationController.CHANNEL_ID,
          title: task.title,
          body: task.description,
          payload: {'task_id': task.id},
          wakeUpScreen: true,
          notificationLayout: NotificationLayout.Default),
    );
  }

  @override
  Future<void> cancelNotification(UserTask task) async {
    if (task.notification) {
      await AwesomeNotifications().cancel(task.id.hashCode);
      info('$runtimeType - Notification canceled for $task');
    }
  }

  /// Callback method when the user taps on a notification or action button.
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    String? payload = receivedAction.payload?['task_id'];

    debug(
        'NotificationController - callback on notification, payload: $payload');

    if (payload != null) {
      UserTask? task = AppTaskController().getUserTask(payload);
      info('NotificationController - User Task notification selected - $task');
      if (task != null) {
        task.state = UserTaskState.notified;
        task.onNotification();
      } else {
        warning(
            'NotificationController - Error in callback from notification - no task found.');
      }
    } else {
      warning(
          "NotificationController - Error in callback from notification - payload is '$payload'");
    }
  }
}
