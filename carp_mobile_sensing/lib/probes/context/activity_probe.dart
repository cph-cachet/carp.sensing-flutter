/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of activity;

/// Collects location information from the underlying OS's location API.
/// Is a [ListeningProbe] that generates a [ActivityDatum] every time location is changed.
class ActivityProbe extends StreamSubscriptionListeningProbe {
  /// A [ActivityProbe] is a listening probe and takes a [ListeningProbeMeasure] as configuration.
  ActivityProbe(ListeningProbeMeasure measure) : super(measure);

  @override
  void initialize() {
    super.initialize();
  }

  @override
  Future start() async {
    super.start();

    // starting the subscription to the activity recognition service
    try {
      subscription =
          ActivityRecognition.activityUpdates().listen(onData, onError: onError, onDone: onDone, cancelOnError: true);
    } catch (error) {
      onError(error);
    }
  }

  void onData(dynamic event) async {
    assert(event is Activity);
    this.notifyAllListeners(ActivityDatum.fromActivity(event as Activity));
  }
}
