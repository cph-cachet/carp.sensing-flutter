/*
 * Copyright 2020-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// Executes an [AppTask].
///
/// An [AppTaskExecutor] simply wraps a [TaskExecutor], which is executed
/// when the app (user) wants to do this.
///
/// This executor works closely with the singleton [AppTaskController].
/// Whenever an [AppTaskExecutor] is resumed (e.g. in a [PeriodicTrigger]),
/// this executor is wrapped in a [UserTask] and put on a queue in
/// the [AppTaskController].
///
/// Later, the app (user) can start, pause, or finalize a [UserTask]
/// by calling the `onStart()`, `onHold()`, and `onDone()` methods,
/// respectively.
///
/// Special-purpose [UserTask]s can be created by an [UserTaskFactory]
/// and such factories can be registered in the [AppTaskController]
/// using the `registerUserTaskFactory` method.
class AppTaskExecutor<TConfig extends AppTask> extends TaskExecutor<TConfig> {
  /// The task executor which can be used to execute this user task once
  /// activated.
  BackgroundTaskExecutor backgroundTaskExecutor = BackgroundTaskExecutor();

  AppTaskExecutor() : super() {
    // add the events from the embedded executor to the overall stream of events
    group.add(backgroundTaskExecutor.data);
  }

  @override
  void onInitialize() {
    // backgroundTaskExecutor.initialize(configuration!, deployment);
  }

  @override
  Future<void> onResume() async {
    // when an app task is resumed simply put it on the queue
    await AppTaskController().enqueue(this);
  }

  @override
  Future<void> onPause() async {
    // TODO - don't know what to do on pause. Remove from queue?
  }

  @override
  Future<void> onStop() async {
    backgroundTaskExecutor.stop();
    await super.onStop();
  }
}
