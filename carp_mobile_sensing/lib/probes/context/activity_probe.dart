/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of activity;

/// Collects activity information from the underlying OS's activity recognition API.
/// Is a [ListeningProbe] that generates a [ActivityDatum] every time an activity is detected.
class ActivityProbe extends StreamSubscriptionListeningProbe {
  ActivityProbe(Measure measure) : super(measure);

  Stream<Datum> get stream => null;

  @override
  void initialize() {
    super.initialize();
  }

  @override
  Future start() async {
    super.start();

    try {
      subscription =
          ActivityRecognition.activityUpdates().listen(onData, onError: onError, onDone: onDone, cancelOnError: true);
    } catch (error) {
      onError(error);
    }
  }

  void onData(dynamic event) async {
    assert(event is Activity);
    this.notifyAllListeners(ActivityDatum.fromActivity(measure: measure, activity: event as Activity));
  }
}
