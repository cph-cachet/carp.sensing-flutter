/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// The [StudyExecutor] is responsible for executing the [Study].
/// For each task it starts a [TaskExecutor].
///
/// Note that the [StudyExecutor] in itself is a [Probe] and hence work as a 'super probe'.
/// This - amongst other things - imply that you can add [ProbeListener]s to a study manager.
class StudyExecutor extends AbstractProbe implements ProbeListener {
  static final Device deviceInfo = new Device();
  StreamGroup<Datum> _group = StreamGroup<Datum>.broadcast();

  Study study;
  DataManager _dataUploadManager;
  List<TaskExecutor> executors = new List();

  Stream<Datum> get events => _group.stream;

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
    events.listen(dataUploadManager.onData, onError: dataUploadManager.onError, onDone: dataUploadManager.onDone);
  }

  DataManager get dataUploadManager {
    if (_dataUploadManager == null) {
      // if the data manager hasn't been set, then try to look it up in the [DataManagerRegistry].
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
      //executor.addProbeListener(this);
      _group.add(executor.events);

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

/// The [TaskExecutor] is responsible for executing [Task]s in the [Study].
/// For each task it looks up appropriate probes to collect data.
///
///Note that the [TaskExecutor] in itself is a [Probe] and hence work as a 'super probe'.
///This - amongst other things - imply that you can add [ProbeListener]s to a task executor.
class TaskExecutor extends AbstractProbe implements ProbeListener {
  static final Device deviceInfo = new Device();
  StreamGroup<Datum> _group = StreamGroup<Datum>.broadcast();
  List<Probe> _probes = new List<Probe>();

  Study study;
  Task task;

  TaskExecutor(this.study, this.task)
      : assert(study != null),
        assert(task != null) {
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
        //probe.addProbeListener(this);
        print('>>> adding probe stream : ${probe.events}');
        _group.add(probe.events);
        probe.initialize();

        // start the probe
        await probe.start();
      }
    }
  }

  Stream<Datum> get events => _group.stream;

  void onData(Datum datum) {}
  @override
  Future notify(Datum datum) async {
    // notify all my listeners -- if any
    notifyAllListeners(datum);
  }
}
