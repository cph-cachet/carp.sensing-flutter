/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Collects activity information from the underlying OS's activity recognition
/// API. It generates an [ActivityDatum] every time an activity is detected.
class ActivityProbe extends StreamProbe {
  Stream<Datum> _stream;
  // Since this probe runs alongside location, which runs a foreground service
  // this probe does not need to run one.
  Stream<Datum> get stream {
    if (_stream == null) {
      _stream = ActivityRecognition
          .activityStream(runForegroundService: false)
          .where((event) => event.type != ActivityType.UNKNOWN)
          .map((activity) => ActivityDatum.fromActivity(activity))
          .asBroadcastStream();
    }
    return _stream;
  }
}
