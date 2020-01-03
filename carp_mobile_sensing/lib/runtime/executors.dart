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

  Executor() : super();

  Future<void> onInitialize(Measure measure) async {
    executors.forEach((executor) => executor.initialize(measure));
  }

  Future<void> onStart() async {
    executors.forEach((executor) => executor.start());
  }

  Future<void> onPause() async {
    executors.forEach((executor) => executor.pause());
  }

  Future<void> onResume() async {
    executors.forEach((executor) => executor.resume());
  }

  Future<void> onRestart({Measure measure}) async {
    executors.forEach((executor) => executor.restart());
  }

  Future<void> onStop() async {
    executors.forEach((executor) => executor.stop());
    executors = new List<Probe>();
  }
}

// ---------------------------------------------------------------------------------------------------------
// STUDY EXECUTOR
// ---------------------------------------------------------------------------------------------------------

/// The [StudyExecutor] is responsible for executing the [Study].
/// For each trigger in this study, it starts a [TriggerExecutor].
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
  /// This is a combination of the running probes in all trigger executors.
  List<Probe> get probes {
    List<Probe> _probes = List<Probe>();
    executors.forEach((executor) {
      if (executor is TriggerExecutor) {
        executor.probes.forEach((probe) {
          _probes.add(probe);
        });
      }
    });
    return _probes;
  }

  Future<void> onStart() async {
    for (Trigger trigger in study.triggers) {
      TriggerExecutor executor;

      switch (trigger.runtimeType) {
        case Trigger:
          // actually, a study it not supposed to use the base-class [Trigger]
          // but if so, we treat it as an [ImmediateTrigger]
          executor = ImmediateTriggerExecutor(trigger);
          break;
        case ImmediateTrigger:
          executor = ImmediateTriggerExecutor(trigger);
          break;
        case DelayedTrigger:
          executor = DelayedTriggerExecutor(trigger);
          break;
        case PeriodicTrigger:
          executor = PeriodicTriggerExecutor(trigger);
          break;
        case ScheduledTrigger:
          executor = ScheduledTriggerExecutor(trigger);
          break;
        case RecurrentScheduledTrigger:
          executor = RecurrentScheduledTriggerExecutor(trigger);
          break;
        case SamplingEventTrigger:
          executor = SamplingEventTriggerExecutor(trigger);
          break;
        case ConditionalSamplingEventTrigger:
          executor = ConditionalSamplingEventTriggerExecutor(trigger);
          break;
      }

      _group.add(executor.events);

      executors.add(executor);
      await executor.initialize(Measure(MeasureType(NameSpace.CARP, DataType.EXECUTOR)));
      executor.start();
    }
  }
}

// ---------------------------------------------------------------------------------------------------------
// TRIGGER EXECUTORS
// ---------------------------------------------------------------------------------------------------------

/// Responsible for handling the timing of a [Trigger] in the [Study].
///
/// This is an abstract class. For each specific type of [Trigger],
/// a corresponding implementation of a [TriggerExecutor] exists.
abstract class TriggerExecutor extends Executor {
  Trigger _trigger;
  Trigger get trigger => _trigger;

  TriggerExecutor(Trigger trigger)
      : assert(trigger != null, "Cannot initiate a TriggerExecutor without a Trigger."),
        super() {
    _trigger = trigger;
    _createAllTaskExecutors();
  }

  /// Create [TaskExecutor]s for all tasks associated with this trigger.
  Future<void> _createAllTaskExecutors() async {
    for (Task task in trigger.tasks) {
      TaskExecutor executor = TaskExecutor(task);
      _group.add(executor.events);
      executors.add(executor);
      //executor.initialize(Measure(MeasureType(NameSpace.CARP, DataType.EXECUTOR)));
    }
  }

  // Start all tasks associated with this trigger.
  //void _startAllTasks() => executors.forEach((executor) => executor.start());

  /// Returns a list of the running probes in this trigger executor.
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
}

/// Executes a [ImmediateTrigger], i.e. starts sampling immediately.
class ImmediateTriggerExecutor extends TriggerExecutor {
  ImmediateTriggerExecutor(Trigger trigger) : super(trigger);
}

/// Executes a [ManualTrigger].
class ManualTriggerExecutor extends TriggerExecutor {
  ManualTriggerExecutor(ManualTrigger trigger) : super(trigger) {
    trigger.executor = this;
  }

  Future<void> onStart() async {
    // first start all tasks, but pause them
    super.onStart();
    this.pause();
  }
}

/// Executes a [DelayedTrigger], i.e. starts sampling after the specified delay.
/// Once started, it runs forever.
class DelayedTriggerExecutor extends TriggerExecutor {
  Duration delay;

  DelayedTriggerExecutor(DelayedTrigger trigger) : super(trigger) {
    delay = Duration(milliseconds: trigger.delay);
  }

  Future<void> onStart() async {
    Timer(delay, () {
      super.onStart();
    });
  }
}

/// Executes a [PeriodicTrigger], i.e. resumes sampling on a regular basis for a given period of time.
///
/// It is required that both the [period] and the [duration] of the [PeriodicTrigger] is specified
/// to make sure that this executor is properly resumed and paused again.
class PeriodicTriggerExecutor extends TriggerExecutor {
  Duration period, duration;

  PeriodicTriggerExecutor(PeriodicTrigger trigger) : super(trigger) {
    assert(trigger.period != null, 'The period in a PeriodicTrigger must be specified.');
    assert(trigger.duration != null, 'The duration in a PeriodicTrigger must be specified.');
    period = Duration(milliseconds: trigger.period);
    duration = Duration(milliseconds: trigger.duration);
  }

  Future<void> onStart() async {
    // first start all tasks, but pause them after a duration
    super.onStart();
    Timer(duration, () {
      this.pause();
      // create a recurrent timer that resume sampling.
      Timer.periodic(period, (Timer t) {
        this.resume();
        // create a timer that pause the sampling after the specified duration.
        Timer(duration, () {
          this.pause();
        });
      });
    });
  }
}

/// Executes a [ScheduledTrigger] on the specified [ScheduledTrigger.schedule] date and time.
class ScheduledTriggerExecutor extends TriggerExecutor {
  Duration delay, duration;

  ScheduledTriggerExecutor(ScheduledTrigger trigger) : super(trigger) {
    assert(trigger.schedule != null, 'The schedule of a ScheduledTrigger must be specified.');
    assert(trigger.schedule.isAfter(DateTime.now()), 'The schedule of the ScheduledTrigger cannot be in the past.');
    delay = trigger.schedule.difference(DateTime.now());
    duration = (trigger.duration != null) ? Duration(milliseconds: trigger.duration) : null;
  }

  Future<void> onStart() async {
    Timer(delay, () {
      super.onStart();
      if (duration != null) {
        // create a timer that stop the sampling after the specified duration.
        Timer(duration, () {
          this.stop();
        });
      }
    });
  }
}

/// Executes a [RecurrentScheduledTrigger].
class RecurrentScheduledTriggerExecutor extends PeriodicTriggerExecutor {
  Duration delay; // the delay before starting the PeriodicTriggerExecutor

  RecurrentScheduledTriggerExecutor(RecurrentScheduledTrigger trigger) : super(trigger) {
    delay = trigger.firstOccurrence.difference(DateTime.now());
  }

  Future<void> onStart() async {
    DateTime _end = (trigger as RecurrentScheduledTrigger).end;
    if (_end == null || _end.isAfter(DateTime.now())) Timer(delay, () => super.onStart());
  }
}

/// Executes a [SamplingEventTrigger] based on the specified
/// [SamplingEventTrigger.measureType] and [SamplingEventTrigger.resumeCondition].
class SamplingEventTriggerExecutor extends TriggerExecutor {
  SamplingEventTriggerExecutor(SamplingEventTrigger trigger) : super(trigger);

  Future<void> onStart() async {
    // first start all tasks, but pause them
    super.onStart();
    this.pause();

    SamplingEventTrigger eventTrigger = trigger as SamplingEventTrigger;
    // listen for event of the specified type
    ProbeRegistry.lookup(eventTrigger.measureType.name).events.listen((datum) {
      if ((eventTrigger.resumeCondition == null) || (datum == eventTrigger?.resumeCondition)) {
        this.resume();
      }
      if (datum == eventTrigger?.pauseCondition) {
        this.pause();
      }
    });
  }
}

/// Executes a [ConditionalSamplingEventTrigger] based on the specified
/// [ConditionalSamplingEventTrigger.measureType] and their [ConditionalSamplingEventTrigger.resumeCondition]
/// and [ConditionalSamplingEventTrigger.pauseCondition].
class ConditionalSamplingEventTriggerExecutor extends TriggerExecutor {
  ConditionalSamplingEventTriggerExecutor(ConditionalSamplingEventTrigger trigger) : super(trigger);

  Future<void> onStart() async {
    // first start all tasks, but pause them
    super.onStart();
    this.pause();

    ConditionalSamplingEventTrigger eventTrigger = trigger as ConditionalSamplingEventTrigger;
    // listen for event of the specified type
    ProbeRegistry.lookup(eventTrigger.measureType.name).events.listen((datum) {
      if (eventTrigger.resumeCondition(datum)) this.resume();
      if (eventTrigger.pauseCondition(datum)) this.pause();
    });
  }
}

// ---------------------------------------------------------------------------------------------------------
// TASK EXECUTORS
// ---------------------------------------------------------------------------------------------------------

/// The [TaskExecutor] is responsible for executing a [Task] in the [Study].
/// For each task it looks up appropriate [Probe]s to collect data.
///
/// Note that a [TaskExecutor] in itself is a [Probe] and hence work as a 'super probe'.
/// This - amongst other things - imply that you can listen to datum [events] from a task executor.
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

  Future<void> onInitialize(Measure taskMeasure) async {
    for (Measure measure in task.measures) {
      // Probe probe = ProbeRegistry.lookup(measure.type.name);
      // create a new probe for each measure - this ensures that we can have
      // multiple measures of the same type, each using its own probe instance
      Probe probe = ProbeRegistry.create(measure.type.name);
      if (probe != null) {
        executors.add(probe);
        _group.add(probe.events);
        probe.initialize(measure);
      } else {
        warning('A probe for measure type ${measure.type.name} could not be created. '
            'Check that the sampling package containing this probe has been registered in the SamplingPackageRegistry.');
      }
    }
  }

//  Future<void> onStart() async {
//    for (Measure measure in task.measures) {
//      // Probe probe = ProbeRegistry.lookup(measure.type.name);
//      // create a new probe for each measure - this ensures that we can have
//      // multiple measures of the same type, each using its own probe instance
//      Probe probe = ProbeRegistry.create(measure.type.name);
//      if (probe != null) {
//        executors.add(probe);
//        _group.add(probe.events);
//        // TODO - init should return true/false and only start a probe if initialized
//        print('trying to initialize probe - $probe');
//        await probe.initialize(measure);
//
//        probe.start();
//      } else {
//        print('A probe for measure type ${measure.type.name} could not be created.');
//      }
//    }
//  }
}
