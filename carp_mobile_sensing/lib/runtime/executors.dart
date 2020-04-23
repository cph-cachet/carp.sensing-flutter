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
  StreamController<Datum> _manualDatumController = StreamController<Datum>.broadcast();
  Study get study => _study;
  Study _study;

  StudyExecutor(Study study)
      : assert(study != null, "Cannot initiate a StudyExecutor without a Study."),
        super() {
    _study = study;
    _group.add(_manualDatumController.stream);
    for (Trigger trigger in study.triggers) {
      TriggerExecutor executor = getTriggerExecutor(trigger);
      _group.add(executor.events);

      executors.add(executor);
    }
  }

  /// Add a [Datum] object to the stream of events.
  void addDatum(Datum datum) => _manualDatumController.add(datum);

  /// Add a error to the stream of events.
  void addError(Object error, [StackTrace stacktrace]) => _manualDatumController.addError(error, stacktrace);

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
}

// ---------------------------------------------------------------------------------------------------------
// TRIGGER EXECUTORS
// ---------------------------------------------------------------------------------------------------------

/// Returns the relevant [TriggerExecutor] based on the type of [trigger].
TriggerExecutor getTriggerExecutor(Trigger trigger) {
  switch (trigger.runtimeType) {
    case Trigger:
      // actually, a study it not supposed to use the base-class [Trigger]
      // but if so, we treat it as an [ImmediateTrigger]
      return ImmediateTriggerExecutor(trigger);
    case ImmediateTrigger:
      return ImmediateTriggerExecutor(trigger);
    case DelayedTrigger:
      return DelayedTriggerExecutor(trigger);
    case PeriodicTrigger:
      return PeriodicTriggerExecutor(trigger);
    case ScheduledTrigger:
      return ScheduledTriggerExecutor(trigger);
    case RecurrentScheduledTrigger:
      return RecurrentScheduledTriggerExecutor(trigger);
    case SamplingEventTrigger:
      return SamplingEventTriggerExecutor(trigger);
    case ConditionalSamplingEventTrigger:
      return ConditionalSamplingEventTriggerExecutor(trigger);
    case ManualTrigger:
      return ManualTriggerExecutor(trigger);
    default:
      return ImmediateTriggerExecutor(trigger);
  }
}

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

    for (Task task in trigger.tasks) {
      TaskExecutor executor = getTaskExecutor(task);

      _group.add(executor.events);
      executors.add(executor);
    }
  }

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
}

/// Executes a [DelayedTrigger], i.e. resumes sampling after the specified delay.
/// Once started, it can be paused / resumed as any other [Executor].
class DelayedTriggerExecutor extends TriggerExecutor {
  Duration delay;

  DelayedTriggerExecutor(DelayedTrigger trigger) : super(trigger) {
    delay = Duration(milliseconds: trigger.delay);
  }

  Future<void> onResume() async {
    Timer(delay, () {
      // after a delay, resume this trigger and its tasks
      super.onResume();
    });
  }
}

/// Executes a [PeriodicTrigger], i.e. resumes sampling on a regular basis for a given period of time.
///
/// It is required that both the [period] and the [duration] of the [PeriodicTrigger] is specified
/// to make sure that this executor is properly resumed and paused again.
class PeriodicTriggerExecutor extends TriggerExecutor {
  Duration period, duration;
  Timer timer;

  PeriodicTriggerExecutor(PeriodicTrigger trigger) : super(trigger) {
    assert(trigger.period != null, 'The period in a PeriodicTrigger must be specified.');
    assert(trigger.duration != null, 'The duration in a PeriodicTrigger must be specified.');
    period = Duration(milliseconds: trigger.period);
    duration = Duration(milliseconds: trigger.duration);
  }

  Future<void> onResume() async {
    // create a recurrent timer that resume sampling.
    timer = Timer.periodic(period, (t) {
      super.onResume();
      // create a timer that pause the sampling after the specified duration.
      Timer(duration, () {
        super.onPause();
      });
    });
  }

  Future<void> onPause() async {
    timer.cancel();
    super.onPause();
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

  Future<void> onResume() async {
    Timer(delay, () {
      // after the waiting time (delay) is over, resume this trigger
      super.onResume();
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
///
/// TODO - implement the RecurrentScheduledTriggerExecutor
class RecurrentScheduledTriggerExecutor extends PeriodicTriggerExecutor {
  Duration delay; // the delay before starting the PeriodicTriggerExecutor

  RecurrentScheduledTriggerExecutor(RecurrentScheduledTrigger trigger) : super(trigger) {
    delay = trigger.firstOccurrence.difference(DateTime.now());
  }

  Future<void> onResume() async {
    DateTime _end = (trigger as RecurrentScheduledTrigger).end;
    if (_end == null || _end.isAfter(DateTime.now())) Timer(delay, () => super.onResume());
  }
}

/// Executes a [SamplingEventTrigger] based on the specified
/// [SamplingEventTrigger.measureType] and [SamplingEventTrigger.resumeCondition].
class SamplingEventTriggerExecutor extends TriggerExecutor {
  SamplingEventTriggerExecutor(SamplingEventTrigger trigger) : super(trigger);

  Future<void> onResume() async {
    SamplingEventTrigger eventTrigger = trigger as SamplingEventTrigger;
    // listen for event of the specified type
    ProbeRegistry.lookup(eventTrigger?.measureType?.name).events.listen((datum) {
      if ((eventTrigger?.resumeCondition == null) || (datum == eventTrigger?.resumeCondition)) {
        super.onResume();
      }
      if (datum == eventTrigger?.pauseCondition) {
        super.onPause();
      }
    });
  }
}

/// Executes a [ConditionalSamplingEventTrigger] based on the specified
/// [ConditionalSamplingEventTrigger.measureType] and their [ConditionalSamplingEventTrigger.resumeCondition]
/// and [ConditionalSamplingEventTrigger.pauseCondition].
class ConditionalSamplingEventTriggerExecutor extends TriggerExecutor {
  ConditionalSamplingEventTriggerExecutor(ConditionalSamplingEventTrigger trigger) : super(trigger);

  Future<void> onResume() async {
    ConditionalSamplingEventTrigger eventTrigger = trigger as ConditionalSamplingEventTrigger;
    // listen for event of the specified type
    ProbeRegistry.lookup(eventTrigger.measureType.name).events.listen((datum) {
      if (eventTrigger.resumeCondition(datum)) super.onResume();
      if (eventTrigger.pauseCondition(datum)) super.onPause();
    });
  }
}

// ---------------------------------------------------------------------------------------------------------
// TASK EXECUTORS
// ---------------------------------------------------------------------------------------------------------

/// Returns the relevant [TaskExecutor] based on the type of [task].
TaskExecutor getTaskExecutor(Task task) {
  switch (task.runtimeType) {
    case Task:
      return TaskExecutor(task);
    case AutomaticTask:
      return AutomaticTaskExecutor(task);
    case AppTask:
      return AppTaskExecutor(task);
    default:
      return TaskExecutor(task);
  }
}

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

  Future<void> onInitialize(Measure ignored) async {
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
}

class AutomaticTaskExecutor extends TaskExecutor {
  AutomaticTaskExecutor(AutomaticTask task)
      : assert(task is AutomaticTask, "SensingTaskExecutor should be ininialized with a SensingTask."),
        super(task);
}

class AppTaskExecutor extends TaskExecutor {
  AppTaskExecutor(AppTask task)
      : assert(task is AppTask, "UserTaskExecutor should be ininialized with a UserTask."),
        super(task) {
    _appTask = task as AppTask;
    _taskExecutor = TaskExecutor(task);
    _group.add(_taskExecutor.events);
  }

  AppTask _appTask;
  TaskExecutor _taskExecutor;

  Future<void> onInitialize(Measure measure) async {
    super.onInitialize(measure);
    _taskExecutor.initialize(measure);
    if (_appTask.onInitialize != null) _appTask.onInitialize(_taskExecutor);
  }

  Future<void> onPause() async {
    if (_appTask.onPause != null) _appTask.onPause(_taskExecutor);
  }

  Future<void> onResume() async {
    if (_appTask.onResume != null) _appTask.onResume(_taskExecutor);
  }

  Future<void> onStop() async {
    if (_appTask.onInitialize != null) _appTask.onStop(_taskExecutor);
    super.onStop();
  }
}
