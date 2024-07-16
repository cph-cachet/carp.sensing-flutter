/*
 * Copyright 2018-2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of '../../carp_context_package.dart';

/// Collects activity information from the underlying OS's activity recognition
/// API. It generates an [Activity] every time an activity is detected.
///
/// Since the AR on both Android and iOS generates a lot of 'useless' events, the
/// following AR event are ignored:
///  * UNKNOWN - when the activity cannot be recognized
///  * TILTING - when the phone is tilted (only on Android)
///  * Activities with a low confidence level (<50%)
class ActivityProbe extends StreamProbe {
  // static bool _requestingPermissions = false;
  Stream<Measurement>? _stream;

  // @override
  // Future<bool> onStart() async {
  // check permission to access the AR on Android

  // Ask for permission before starting probe.
  // Only relevant for Android - on iOS permission is automatically requested.
  // var status = Platform.isAndroid
  //     ? await Permission.activityRecognition.request()
  //     : PermissionStatus.granted;

  // return (status == PermissionStatus.granted)
  //     ? super.onStart()
  //     : Future.value(false);

  // final status = await Permission.activityRecognition.status;
  // debug('$runtimeType - status: $status');
  // if (!status.isGranted && !_requestingPermissions) {
  //   warning(
  //       '$runtimeType - permission not granted to use to activity recognition: $status - trying to request it');
  //   try {
  //     _requestingPermissions = true; // only request once
  //     await Permission.activityRecognition.request();
  //   } catch (error) {
  //     warning(
  //         '$runtimeType - error trying to request access to activity recognition, error: $error');
  //   }
  // }

  // return await super.onStart();
  // }

  @override
  Stream<Measurement> get stream => _stream ??= ar
      .FlutterActivityRecognition.instance.activityStream
      .where((event) => event.type != ar.ActivityType.UNKNOWN)
      .where((event) => event.confidence != ar.ActivityConfidence.LOW)
      .map((activity) => Measurement.fromData(Activity.fromActivity(activity)))
      .asBroadcastStream();
}
