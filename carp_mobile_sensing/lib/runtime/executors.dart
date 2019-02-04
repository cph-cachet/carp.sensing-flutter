/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// An abstract class used to implement executors.
/// See [StudyExecutor] and [TaskExecutor] for examples.
abstract class Executor extends AbstractProbe {
  static final Device deviceInfo = new Device();
  StreamGroup<Datum> _group = StreamGroup<Datum>.broadcast();
  List<Probe> executors = new List<Probe>();
  Stream<Datum> get events => _group.stream;

  //Executor() : super(Measure(MeasureType(NameSpace.CARP, DataType.EXECUTOR)));
  Executor() : super();

  void onPause() async {
    executors.forEach((executor) => executor.pause());
  }

  void onResume() async {
    executors.forEach((executor) => executor.resume());
  }

  void onRestart({Measure measure}) async {
    executors.forEach((executor) => executor.restart());
  }

  void onStop() async {
    executors.forEach((executor) => executor.stop());
    executors = new List<Probe>();
  }
}

/// The [StudyExecutor] is responsible for executing the [Study].
/// For each task it starts a [TaskExecutor].
///
/// Note that the [StudyExecutor] in itself is a [Probe] and hence work as a 'super probe'.
/// This - amongst other things - imply that you can listen to datum [events] from a study executor.
class StudyExecutor extends Executor {
  Study get study => _study;
  Study _study;

  StudyExecutor(Study study)
      : assert(study != null, "Cannot initiate a StudyExecutor without a Study."),
        super() {
    _study = study;
  }

  /// Returns a list of the running probes in this study executor.
  ///
  /// This is a combination of the running probes in all task executors.
  List<Probe> get probes {
    List<Probe> _probes = List<Probe>();
    executors.forEach((executor) {
      if (executor is TaskExecutor) {
        executor.probes.forEach((probe) {
          _probes.add(probe);
        });
      }
    });
    return _probes;
  }

  Future onStart() async {
    for (Task task in study.tasks) {
      TaskExecutor executor = TaskExecutor(task);
      _group.add(executor.events);

      executors.add(executor);
      executor.initialize(Measure(MeasureType(NameSpace.CARP, DataType.EXECUTOR)));
      executor.start();
    }
  }
}

/// The [TaskExecutor] is responsible for executing [Task]s in the [Study].
/// For each task it looks up appropriate [Probe]s to collect data.
///
///Note that the [TaskExecutor] in itself is a [Probe] and hence work as a 'super probe'.
///This - amongst other things - imply that you can listen to datum [events] from a task executor.
class TaskExecutor extends Executor {
  Task get task => _task;
  Task _task;

  /// Returns a list of the running probes in this task executor.
  List<Probe> get probes => executors;

  TaskExecutor(Task task)
      : assert(task != null, "Cannot initiate a TaskExecutor without a Task."),
        super() {
    _task = task;
  }

//  Future onStart() async {
//    for (Measure measure in task.measures) {
//      Probe probe = ProbeRegistry.create(measure);
//      if (probe != null) {
//        executors.add(probe);
//        _group.add(probe.events);
//        probe.initialize();
//
//        // start the probe
//        probe.start();
//      }
//    }
//  }

  Future onStart() async {
    for (Measure measure in task.measures) {
      Probe probe = ProbeRegistry.lookup(measure.type.name);
      if (probe != null) {
        executors.add(probe);
        _group.add(probe.events);
        probe.initialize(measure);

        // start the probe
        probe.start();
      }
    }
  }
}
