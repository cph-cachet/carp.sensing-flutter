/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
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
  static final NotificationController _instance = NotificationController._();
  NotificationController._() : super();

  /// The singleton [NotificationController].
  factory NotificationController() => _instance;

  /// Initialize and set up the notification controller.
  Future<void> initialize() async {
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
  }

  // the id, name, and description are mandatory, but don't seems to used for anything?
  final notifications.NotificationDetails _platformChannelSpecifics =
      notifications.NotificationDetails(
    android: const notifications.AndroidNotificationDetails(
      'id',
      'name',
      importance: notifications.Importance.max,
    ),
    iOS: const notifications.IOSNotificationDetails(),
  );

  /// Send a notification for the [task].
  void sendNotification(UserTask task) {
    if (task.notification) {
      notifications.FlutterLocalNotificationsPlugin().show(
        task.hashCode,
        task.title,
        task.description,
        _platformChannelSpecifics,
        payload: task.id,
      );
      info('Notification send for $task');
    }
  }

  /// Cancel (i.e., remove) the notification for the [task].
  void cancelNotification(UserTask task) {
    if (task.notification) {
      notifications.FlutterLocalNotificationsPlugin().cancel(task.hashCode);
      info('Notification cancled for $task');
    }
  }
}
