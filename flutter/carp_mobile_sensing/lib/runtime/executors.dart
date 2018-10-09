/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import "dart:async";
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/**
 * The [StudyExecutor] is responsible for executing the [Study].
 * For each task it starts a [TaskExecutor].
 *
 * Note that the [StudyExecutor] in itself is a [Probe] and hence work as a 'super probe'.
 * This - amongst other things - imply that you can add [ProbeListener]s to a study manager.
 */
class StudyExecutor extends AbstractProbe implements ProbeListener {
  static final Device deviceInfo = new Device();

  Study study;
  DataManager _dataUploadManager;
  List<TaskExecutor> executors = new List();

  @override
  ProbeType get probeType => ProbeType.manager;

  StudyExecutor(this.study) {
    this.name = study.name;
  }

  void initialize() async {
    await Device.getDeviceInfo();
    print('Initializing Study Executor for study: ' + study.name);
    print(' platform     : ' + Device.platform.toString());
    print(' device ID    : ' + Device.deviceID.toString());
    print(' data manager : ' + dataUploadManager.toString());

    await dataUploadManager.initialize(study);
  }

  DataManager get dataUploadManager {
    if (_dataUploadManager == null) {
      _dataUploadManager = DataManagerRegistry.lookup(study.dataEndPoint.type);
    }
    return _dataUploadManager;
  }

  Future start() async {
    super.start();
    this._start();
  }

  void stop() async {
    for (TaskExecutor executor in executors) {
      executor.stop();
    }
    if (dataUploadManager != null) dataUploadManager.close();
    super.stop();
  }

  Future _start() async {
    for (Task task in study.tasks) {
      TaskExecutor executor = new TaskExecutor(study, task);
      executor.addProbeListener(this);

      executors.add(executor);

      // start the executor
      await executor.start();
    }
  }

  @override
  Future notify(Datum datum) async {
    // notify the data manager
    if (dataUploadManager != null) dataUploadManager.uploadData(datum);

    // notify all my listeners -- if any
    notifyAllListeners(datum);
  }
}

/**
 * The [TaskExecutor] is responsible for executing [Task]s in the [Study].
 * For each task it looks up appropriate probes to collect data.
 *
 * Note that the [TaskExecutor] in itself is a [Probe] and hence work as a 'super probe'.
 * This - amongst other things - imply that you can add [ProbeListener]s to a task executor.
 */
class TaskExecutor extends AbstractProbe implements ProbeListener {
  static final Device deviceInfo = new Device();

  Study study;
  Task task;
  List<Probe> _probes = new List<Probe>();

  @override
  ProbeType get probeType => ProbeType.executor;

  TaskExecutor(this.study, this.task) {
    name = task.name;
  }

  Future initialize() async {
    print('Initializing Task Executor for task: $name ...');
  }

  Future start() async {
    super.start();
    this._run();
  }

  void stop() async {
    for (Probe probe in _probes) {
      probe.stop();
    }
    super.stop();
  }

  Future _run() async {
    for (Measure measure in task.measures) {
      Probe probe = ProbeRegistry.create(measure);

      if ((probe != null) && (measure.enabled)) {
        _probes.add(probe);
        probe.addProbeListener(this);
        probe.initialize();

        // start the probe
        await probe.start();
      }
    }
  }

  @override
  Future notify(Datum datum) async {
    // notify all my listeners -- if any
    notifyAllListeners(datum);
  }
}
