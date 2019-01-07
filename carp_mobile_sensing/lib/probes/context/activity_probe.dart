/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of activity;

/// Collects activity information from the underlying OS's activity recognition API.
/// Is a [ListeningProbe] that generates a [ActivityDatum] every time an activity is detected.
class ActivityProbe extends StreamProbe {
  ActivityProbe({String name}) : super(name: name);

  Stream<Datum> get stream =>
      ActivityRecognition.activityUpdates().map((activity) => ActivityDatum.fromActivity(activity));
}
