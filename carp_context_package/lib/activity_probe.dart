/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of context;

/// Collects activity information from the underlying OS's activity recognition API.
/// It generates an [ActivityDatum] every time an activity is detected.
class ActivityProbe extends StreamProbe {
  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    if (!Platform.isAndroid) throw SensingException('TextMessageProbe only available on Android.');
  }

  Stream<Datum> get stream =>
      ActivityRecognition.activityUpdates().map((activity) => ActivityDatum.fromActivity(activity));
}
