/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A [NotificationController] based on the [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
/// Flutter plugin.
///
/// On iOS, remember to edit the AppDelegate.swift file.
/// See https://pub.dev/packages/flutter_local_notifications#general-setup
///
/// On Android, add an `app_icon.png` square png picture in the
/// `<<application_name>>/android/app/src/main/res/drawable/` folder.
class FlutterLocalNotificationController implements NotificationController {
  static final FlutterLocalNotificationController _instance =
      FlutterLocalNotificationController._();
  FlutterLocalNotificationController._() : super();

  /// The singleton [NotificationController].
  factory FlutterLocalNotificationController() => _instance;

  /// Initialize and set up the notification controller.
  @override
  Future<void> initialize() async {
    debug('$runtimeType initializing....');
    tz.initializeTimeZones();

    await notifications.FlutterLocalNotificationsPlugin().initialize(
      notifications.InitializationSettings(
        android: const notifications.AndroidInitializationSettings('app_icon'),
        iOS: const notifications.DarwinInitializationSettings(),
      ),
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveNotificationResponse,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
    info('$runtimeType initialized.');
    debug('PENDING NOTIFICATIONS:');
    for (var notification
        in (await notifications.FlutterLocalNotificationsPlugin()
            .pendingNotificationRequests())) {
      debug('${notification.title}');
    }
  }

  final notifications.NotificationDetails _platformChannelSpecifics =
      notifications.NotificationDetails(
    android: const notifications.AndroidNotificationDetails(
      NotificationController.CHANNEL_ID,
      NotificationController.CHANNEL_NAME,
      importance: notifications.Importance.max,
      priority: notifications.Priority.max,
      ongoing: true,
    ),
    iOS: const notifications.DarwinNotificationDetails(),
  );

  /// Send an immediate notification for a [task].
  @override
  Future<void> sendNotification(UserTask task) async {
    if (task.notification) {
      await notifications.FlutterLocalNotificationsPlugin().show(
        task.id.hashCode,
        task.title,
        task.description,
        _platformChannelSpecifics,
        payload: task.id,
      );
      info('Notification send for $task');
    }
  }

  /// Schedule a notification for a [task] at the [UserTask.triggerTime].
  @override
  Future<void> scheduleNotification(UserTask task) async {
    // early out if not to be scheduled
    if (!task.notification) return;

    if (task.triggerTime.isAfter(DateTime.now())) {
      final time = tz.TZDateTime.from(
          task.triggerTime, tz.getLocation(Settings().timezone));

      await notifications.FlutterLocalNotificationsPlugin().zonedSchedule(
        task.id.hashCode,
        task.title,
        task.description,
        time,
        _platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            notifications.UILocalNotificationDateInterpretation.absoluteTime,
        payload: task.id,
      );
      task.hasNotificationBeenCreated = true;
      debug('$runtimeType - Notification scheduled for $task at $time');
    } else {
      warning('$runtimeType - Can only schedule a notification in the future. '
          'task trigger time: ${task.triggerTime}.');
    }
  }

  /// The number of pending nofitifications.
  ///
  /// Note that on iOS there is a limit of 64 pending nofifications.
  /// See https://pub.dev/packages/flutter_local_notifications#ios-pending-notifications-limit
  @override
  Future<int> get pendingNotificationRequestsCount async =>
      (await notifications.FlutterLocalNotificationsPlugin()
              .pendingNotificationRequests())
          .length;

  /// Cancel (i.e., remove) the notification for the [task].
  @override
  void cancelNotification(UserTask task) {
    if (task.notification) {
      notifications.FlutterLocalNotificationsPlugin().cancel(task.id.hashCode);
      info('Notification cancled for $task');
    }
  }
}

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(
    notifications.NotificationResponse response) {
  String? payload = response.payload;

  debug(
      'FlutterLocalNotificationController - onDidReceiveNotificationResponse, payload: $payload');

  if (payload != null) {
    UserTask? task = AppTaskController().getUserTask(payload);
    info('User Task notification selected - $task');
    if (task != null) {
      task.onNotification();
    } else {
      warning('Error in callback from notification - no task found.');
    }
  } else {
    warning("Error in callback from notification - payload is '$payload'");
  }
}
