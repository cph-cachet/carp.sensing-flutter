/*
 * Copyright 2024 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of 'carp_services.dart';

/// A [CarpNotificationService] that talks to the CARP Web Services.
class CarpNotificationService extends CarpBaseService
    implements NotificationController {
  static final CarpNotificationService _instance = CarpNotificationService._();

  CarpNotificationService._();

  /// Returns the singleton default instance of the [CarpNotificationService].
  /// Before this instance can be used, it must be configured using the [configure] method.
  factory CarpNotificationService() => _instance;

  final _firebaseMessaging = FirebaseMessaging.instance;

  @override
  String get rpcEndpointName => "notification-service";

  String get appUri => app!.uri.toString();

  String get endpoint => "$appUri/$rpcEndpointName";

  late String fcmToken;

  @override
  Future<void> initialize() async {
    if (_firebaseMessaging == null) {
      throw StateError('FirebaseMessaging is not initialized');
    }

    await _firebaseMessaging.requestPermission();

    final token = await _firebaseMessaging.getToken();

    if (token == null) {
      throw StateError('FirebaseMessaging token is null');
    }

    this.fcmToken = token;

    debug('$runtimeType - PushNotificationController - token: $token');
    info('$runtimeType initialized.');
  }

  Future<int> uploadNotification(
      {int? id,
      required String title,
      String? description,
      DateTime? when}) async {
    var data = {
      "title": title,
      "body": description,
      "id": id,
      "when": when?.toUtc().toIso8601String(),
      "token": fcmToken,
    };

    http.Response response = await httpr.post(Uri.encodeFull(endpoint),
        headers: headers, body: json.encode(data));
    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson =
        json.decode(response.body) as Map<String, dynamic>;

    if ((httpStatusCode == HttpStatus.ok) ||
        (httpStatusCode == HttpStatus.created)) {
      return responseJson["id"] as int;
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"].toString(),
      path: responseJson["path"].toString(),
    );
  }

  Future<void> deleteNotification(int id) async {
    var response =
        await httpr.delete(Uri.encodeFull('$endpoint/$id'), headers: headers);

    int httpStatusCode = response.statusCode;
    if (httpStatusCode == HttpStatus.ok) {
      return;
    } else {
      final Map<String, dynamic> responseJson =
          json.decode(response.body) as Map<String, dynamic>;
      throw CarpServiceException(
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
        message: responseJson["message"].toString(),
        path: responseJson["path"].toString(),
      );
    }
  }

  @override
  Future<int> scheduleNotification(
      {int? id,
      required String title,
      String? body,
      required DateTime schedule}) async {
    return await uploadNotification(
        id: id, title: title, description: body, when: schedule);
  }

  @override
  Future<int> createNotification(
      {int? id, required String title, String? body}) async {
    return await uploadNotification(id: id, title: title, description: body);
  }

  @override
  Future<void> createTaskNotification(UserTask task) async {
    await uploadNotification(
        id: task.id.hashCode, title: task.title, description: task.description);
  }

  @override
  Future<void> scheduleTaskNotification(UserTask task) async {
    await uploadNotification(
        id: task.id.hashCode,
        title: task.title,
        description: task.description,
        when: task.triggerTime);
  }

  @override
  Future<void> cancelNotification(int id) async {
    await deleteNotification(id);
  }

  @override
  Future<void> cancelTaskNotification(UserTask task) async {
    await deleteNotification(task.hashCode);
  }

  @override
  Future<int> get pendingNotificationRequestsCount async {
    // TODO: implement pendingNotificationRequestsCount
    return Future.value(0);
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
}
