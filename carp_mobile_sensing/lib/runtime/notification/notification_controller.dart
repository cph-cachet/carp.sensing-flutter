/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of runtime;

/// A controller of user notifications based on [UserTask]s.
/// Works closely with the [AppTaskController].
abstract class NotificationController {
  /// The upper limit of scheduled notification on iOS.
  static const PENDING_NOTIFICATION_LIMIT = 64;

  /// The id of the notification channel.
  static const CHANNEL_ID = 'carp_mobile_sensing_notifications';

  /// The name of the notification channel as shown in the Settings
  /// on Android phones.
  static const CHANNEL_NAME = 'CARP Basic Notifications';

  /// The description of the notification channel as shown in the Settings
  /// on Android phones.
  static const CHANNEL_DESCRIPTION =
      'Notifications about tasks that the user has to do.';

  /// The id of the notification channel.
  static const SCHEDULED_CHANNEL_ID =
      'carp_mobile_sensing_scheduled_notifications';

  /// The name of the notification channel as shown in the Settings
  /// on Android phones.
  static const SCHEDULED_CHANNEL_NAME = 'CARP Scheduled Notifications';

  /// The description of the notification channel as shown in the Settings
  /// on Android phones.
  static const SCHEDULED_CHANNEL_DESCRIPTION =
      'Notifications about scheduled tasks that the user has to do.';

  /// Initialize and set up the notification controller.
  /// Also tries to get permissions to send notifications.
  Future<void> initialize();

  /// Send an immediate notification for a [task].
  Future<void> sendNotification(UserTask task);

  /// Schedule a notification for a [task] at the [task.triggerTime].
  Future<void> scheduleNotification(UserTask task);

  /// The number of pending notifications.
  Future<int> get pendingNotificationRequestsCount;

  /// Cancel (i.e., remove) the notification for the [task].
  Future<void> cancelNotification(UserTask task);
}

/// A no-operation notification controller that does nothing.
class NoOpNotificationController implements NotificationController {
  @override
  Future<void> cancelNotification(UserTask task) async {}

  @override
  Future<void> initialize() async {}

  @override
  Future<int> get pendingNotificationRequestsCount async => 0;

  @override
  Future<void> scheduleNotification(UserTask task) async {}

  @override
  Future<void> sendNotification(UserTask task) async {}
}
