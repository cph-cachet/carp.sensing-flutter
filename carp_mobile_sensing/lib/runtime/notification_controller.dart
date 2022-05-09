/*
 * Copyright 2021-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A controller of user notifcation based on [UserTask]s.
/// Works closely with the [AppTaskController].
///
/// Based on the [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) Flutter plugin.
///
/// On iOS, remember to edit the AppDelegate.swift file.
/// See https://pub.dev/packages/flutter_local_notifications#general-setup
///
/// On Android, add an `app_icon.png` square png picture in the
/// `<<application_name>>/android/app/src/main/res/drawable/` folder.
class NotificationController {
  static final PENDING_NOTIFICATION_LIMIT = 64;
  static final NotificationController _instance = NotificationController._();
  NotificationController._() : super();

  /// The singleton [NotificationController].
  factory NotificationController() => _instance;

  /// Initialize and set up the notification controller.
  Future<void> initialize() async {
    debug('$runtimeType initializing....');
    tz.initializeTimeZones();

    await notifications.FlutterLocalNotificationsPlugin().initialize(
      notifications.InitializationSettings(
        android: const notifications.AndroidInitializationSettings('app_icon'),
        iOS: const notifications.IOSInitializationSettings(),
      ),
      onSelectNotification: (String? payload) async {
        debug('selectedUserTaskNotificationCallback - payload: $payload');

        if (payload != null) {
          UserTask? task = AppTaskController().getUserTask(payload);
          info('User Task notification selected - $task');
          if (task != null) {
            task.onNotification();
          } else {
            warning('Error in callback from notification - no task found.');
          }
        } else {
          warning(
              "Error in callback from notification - payload is '$payload'");
        }
      },
    );
    info('$runtimeType initialized.');
  }

  // the id and name are mandatory, but don't seems to used for anything?
  final notifications.NotificationDetails _platformChannelSpecifics =
      notifications.NotificationDetails(
    android: const notifications.AndroidNotificationDetails(
      'id',
      'name',
      importance: notifications.Importance.max,
    ),
    iOS: const notifications.IOSNotificationDetails(),
  );

  /// Send an immediate notification for a [task].
  void sendNotification(UserTask task) {
    if (task.notification) {
      notifications.FlutterLocalNotificationsPlugin().show(
        task.id.hashCode,
        task.title,
        task.description,
        _platformChannelSpecifics,
        payload: task.id,
      );
      info('Notification send for $task');
    }
  }

  /// Schedule a notification for a [task] at the [task.triggerTime].
  void scheduleNotification(UserTask task) {
    if (task.notification) {
      if (task.triggerTime.isAfter(DateTime.now())) {
        final time = tz.TZDateTime.from(
            task.triggerTime, tz.getLocation(Settings().timezone));

        notifications.FlutterLocalNotificationsPlugin().zonedSchedule(
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
        info('$runtimeType - Notification scheduled for $task at $time');
      }
    } else {
      warning('$runtimeType - Can only schedule a notification in the future. '
          'task trigger time: ${task.triggerTime}.');
    }
  }

  /// Schedule a daily notification..
  void scheduleWeeklyNotification(UserTask task) {
    if (task.notification) {
      if (task.triggerTime.isAfter(DateTime.now())) {
        final time = tz.TZDateTime.from(
            task.triggerTime, tz.getLocation(Settings().timezone));

        notifications.FlutterLocalNotificationsPlugin().zonedSchedule(
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
        info('$runtimeType - Notification scheduled for $task at $time');
      }
    } else {
      warning('$runtimeType - Can only schedule a notification in the future. '
          'task trigger time: ${task.triggerTime}.');
    }
  }

  /// The number of pending nofitifications.
  ///
  /// Note that on iOS there is a limit of 64 pending nofifications.
  /// See https://pub.dev/packages/flutter_local_notifications#ios-pending-notifications-limit
  Future<int> get pendingNotificationRequestsCount async =>
      (await notifications.FlutterLocalNotificationsPlugin()
              .pendingNotificationRequests())
          .length;

  /// Cancel (i.e., remove) the notification for the [task].
  void cancelNotification(UserTask task) {
    if (task.notification) {
      notifications.FlutterLocalNotificationsPlugin().cancel(task.id.hashCode);
      info('Notification cancled for $task');
    }
  }
}
