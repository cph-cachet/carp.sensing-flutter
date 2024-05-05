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
  static bool requestingPermissions = false;
  Stream<Measurement>? _stream;

  @override
  Future<bool> onStart() async {
    // check permission to access the AR on Android
    final status = await Permission.activityRecognition.status;
    if (!status.isGranted && !requestingPermissions) {
      warning(
          '$runtimeType - permission not granted to use to activity recognition: $status - trying to request it');
      try {
        requestingPermissions = true; // only request once
        await Permission.activityRecognition.request();
      } catch (error) {
        warning(
            '$runtimeType - error trying to request access to activity recognition, error: $error');
      }
    }

    return await super.onStart();
  }

  // @override
  // Stream<Datum> get stream => _stream ??= ActivityRecognition()
  //     // since this probe runs alongside location, which runs a foreground service
  //     // this probe does not need to run as a foreground service
  //     .activityStream(runForegroundService: false)
  //     .where((event) => event.type != ActivityType.UNKNOWN)
  //     .where((event) => event.type != ActivityType.TILTING)
  //     .where((event) => event.confidence > 50)
  //     .map((activity) => ActivityDatum.fromActivityEvent(activity))
  //     .asBroadcastStream();

  @override
  Stream<Measurement> get stream => _stream ??= ar
      .FlutterActivityRecognition.instance.activityStream
      .where((event) => event.type != ar.ActivityType.UNKNOWN)
      .where((event) => event.confidence != ar.ActivityConfidence.LOW)
      .map((activity) => Measurement.fromData(Activity.fromActivity(activity)))
      .asBroadcastStream();
}
