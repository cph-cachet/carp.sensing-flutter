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
  static final DeviceInfo deviceInfo = DeviceInfo();
  final StreamGroup<Datum> _group = StreamGroup.broadcast();
  List<Probe> executors = [];
  Stream<Datum> get events => _group.stream;

  Executor() : super();

  void onInitialize(Measure measure) {
    executors.forEach((executor) => executor.initialize(measure));
  }

  Future onPause() async {
    executors.forEach((executor) => executor.pause());
  }

  Future onResume() async {
    executors.forEach((executor) => executor.resume());
  }

  Future onRestart({Measure measure}) async {
    executors.forEach((executor) => executor.restart());
  }

  Future onStop() async {
    executors.forEach((executor) => executor.stop());
    executors = [];
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
  final StreamController<Datum> _manualDatumController =
      StreamController.broadcast();
  Study get study => _study;
  Study _study;

  StudyExecutor(Study study) : super() {
    assert(study != null, 'Cannot initiate a StudyExecutor without a Study.');
    _study = study;
    _group.add(_manualDatumController.stream);
    for (Trigger trigger in study.triggers) {
      TriggerExecutor executor = getTriggerExecutor(trigger);
      _group.add(executor.events);
      executors.add(executor);
    }
  }

  Future onResume() async {
    // check the start time for this study on this phone
    // this will save it, the first time the study is executed
    DateTime studyStartTimestamp = await settings.studyStartTimestamp;
    info('Study was started on this phone on ${studyStartTimestamp.toUtc()}');

    await super.onResume();
  }

  /// Add a [Datum] object to the stream of events.
  void addDatum(Datum datum) => _manualDatumController.add(datum);

  /// Add a error to the stream of events.
  void addError(Object error, [StackTrace stacktrace]) =>
      _manualDatumController.addError(error, stacktrace);

  /// Returns a list of the running probes in this study executor.
  /// This is a combination of the running probes in all trigger executors.
  List<Probe> get probes {
    List<Probe> _probes = [];
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
    // actually, the base Trigger class is not supposed to be used
    // but if it is, treat it as an ImmediateTrigger
    case Trigger:
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
    case CronScheduledTrigger:
      return CronScheduledTriggerExecutor(trigger);
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

  TriggerExecutor(Trigger trigger) : super() {
    assert(trigger != null,
        'Cannot initiate a TriggerExecutor without a Trigger.');
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
    List<Probe> _probes = [];
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
    trigger.executor = ImmediateTriggerExecutor(trigger);
    _group.add(trigger.executor.events);
  }

  // Forward to the embedded trigger executor
  void onInitialize(Measure measure) =>
      (trigger as ManualTrigger).executor.initialize(measure);

  // A no-op methods since a ManualTrigger can only be resumed/paused
  // using the resume/pause methods on the ManualTrigger.
  Future onResume() async {}
  Future onPause() async {}

  // Forward to the embedded trigger executor
  Future onRestart({Measure measure}) async =>
      (trigger as ManualTrigger).executor.restart();
  Future onStop() async => (trigger as ManualTrigger).executor.stop();

  List<Probe> get probes => (trigger as ManualTrigger).executor.probes;
}

/// Executes a [DelayedTrigger], i.e. resumes sampling after the specified delay.
/// Once started, it can be paused / resumed as any other [Executor].
class DelayedTriggerExecutor extends TriggerExecutor {
  DelayedTriggerExecutor(DelayedTrigger trigger) : super(trigger);

  Future onResume() async {
    Timer((trigger as DelayedTrigger).delay, () {
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
    assert(trigger.period != null,
        'The period in a PeriodicTrigger must be specified.');
    assert(trigger.duration != null,
        'The duration in a PeriodicTrigger must be specified.');
    period = trigger.period;
    duration = trigger.duration;
  }

  Future onResume() async {
    // resume first time, and pause after the specified duration.
    await super.onResume();
    Timer(duration, () {
      super.onPause();
    });

    // then create a recurrent timer that resume periodically.
    timer = Timer.periodic(period, (t) {
      super.onResume();
      // create a timer that pause the sampling after the specified duration.
      Timer(duration, () {
        super.onPause();
      });
    });
  }

  Future onPause() async {
    timer.cancel();
    await super.onPause();
  }
}

/// Executes a [ScheduledTrigger] on the specified [ScheduledTrigger.schedule] date and time.
class ScheduledTriggerExecutor extends TriggerExecutor {
  Duration delay, duration;
  Timer timer;

  ScheduledTriggerExecutor(ScheduledTrigger trigger) : super(trigger) {
    assert(trigger.schedule != null,
        'The schedule of a ScheduledTrigger must be specified.');
    assert(trigger.schedule.isAfter(DateTime.now()),
        'The schedule of the ScheduledTrigger cannot be in the past.');
    delay = trigger.schedule.difference(DateTime.now());
    duration = trigger.duration;
  }

  Future onResume() async {
    timer = Timer(delay, () {
      // after the waiting time (delay) is over, resume this trigger
      super.onResume();
      if (duration != null) {
        // create a timer that stop the sampling after the specified duration.
        // if the duration is null, the sampling never stops, i.e. runs forever.
        Timer(duration, () {
          stop();
        });
      }
    });
  }

  Future onPause() async {
    timer.cancel();
    await super.onPause();
  }
}

/// Executes a [RecurrentScheduledTrigger].
class RecurrentScheduledTriggerExecutor extends PeriodicTriggerExecutor {
  RecurrentScheduledTrigger _myTrigger;

  RecurrentScheduledTriggerExecutor(RecurrentScheduledTrigger trigger)
      : super(trigger) {
    _myTrigger = trigger;
  }

  Future onResume() async {
    // check if there is a remembered trigger date
    if (_myTrigger.remember) {
      String _savedFirstOccurrence =
          settings.preferences.get(_myTrigger.triggerId);
      debug('savedFirstOccurrence : $_savedFirstOccurrence');

      if (_savedFirstOccurrence != null) {
        DateTime savedDate = DateTime.tryParse(_savedFirstOccurrence);
        if (savedDate.isBefore(DateTime.now())) {
          debug(
              'There is a saved timestamp in the past - resuming this trigger now: ${DateTime.now().toString()}.');
          executors.forEach((executor) => executor.resume());
          // create a timer that pause the sampling after the specified duration.
          Timer(duration, () {
            executors.forEach((executor) => executor.pause());
          });
        }
      }

      // save the day of the first occurrence for later use
      await settings.preferences.setString(
          _myTrigger.triggerId, _myTrigger.firstOccurrence.toUtc().toString());
      debug(
          'saving firstOccurrence : ${_myTrigger.firstOccurrence.toUtc().toString()}');
    }

    // below is 'normal' (i.e., non-remember) behavior
    Duration _delay = _myTrigger.firstOccurrence.difference(DateTime.now());
    debug('delay: $_delay');
    if (_myTrigger.end == null || _myTrigger.end.isAfter(DateTime.now())) {
      Timer(_delay, () {
        debug('delay finished, now resuming...');
        if (_myTrigger.remember) {
          // replace the entry of the first occurrence to the next occurrence date
          DateTime nextOccurrence = DateTime.now().add(period);
          settings.preferences.setString(
              _myTrigger.triggerId, nextOccurrence.toUtc().toString());
          debug('saving nextOccurrence: $nextOccurrence');
        }
        super.onResume();
      });
    }
  }
}

/// Executes a [CronScheduledTrigger] based on the specified cron job.
class CronScheduledTriggerExecutor extends TriggerExecutor {
  cron.Cron _cron;
  cron.Schedule _schedule;
  cron.ScheduledTask _scheduledTask;

  CronScheduledTriggerExecutor(CronScheduledTrigger trigger) : super(trigger) {
    _schedule = cron.Schedule.parse(trigger.cronExpression);
    _cron = cron.Cron();
  }

  Future onResume() async {
    debug(
        'creating cron job : ${(trigger as CronScheduledTrigger).toString()}');
    _scheduledTask = _cron.schedule(_schedule, () async {
      debug('resuming cron job : ${DateTime.now().toString()}');
      await super.onResume();
      Timer((trigger as CronScheduledTrigger).duration, () => super.onPause());
    });
  }

  Future onPause() async {
    await _scheduledTask.cancel();
    await super.onPause();
  }
}

/// Executes a [SamplingEventTrigger] based on the specified
/// [SamplingEventTrigger.measureType] and [SamplingEventTrigger.resumeCondition].
class SamplingEventTriggerExecutor extends TriggerExecutor {
  SamplingEventTriggerExecutor(SamplingEventTrigger trigger) : super(trigger);

  StreamSubscription<Datum> _subscription;

  Future onResume() async {
    SamplingEventTrigger eventTrigger = trigger as SamplingEventTrigger;
    // start listen for events of the specified type
    _subscription = ProbeRegistry()
        .eventsByType(eventTrigger?.measureType?.name)
        .listen((datum) {
      if ((eventTrigger?.resumeCondition == null) ||
          (datum == eventTrigger?.resumeCondition)) super.onResume();
      if (eventTrigger?.pauseCondition != null &&
          datum == eventTrigger?.pauseCondition) super.onPause();
    });
  }

  Future onPause() async {
    // stop the listening
    await _subscription.cancel();
    await super.onPause();
  }
}

/// Executes a [ConditionalSamplingEventTrigger] based on the specified
/// [ConditionalSamplingEventTrigger.measureType] and their
/// [ConditionalSamplingEventTrigger.resumeCondition] and
/// [ConditionalSamplingEventTrigger.pauseCondition].
class ConditionalSamplingEventTriggerExecutor extends TriggerExecutor {
  ConditionalSamplingEventTriggerExecutor(
      ConditionalSamplingEventTrigger trigger)
      : super(trigger);

  StreamSubscription<Datum> _subscription;

  Future onResume() async {
    ConditionalSamplingEventTrigger eventTrigger =
        trigger as ConditionalSamplingEventTrigger;

    // listen for event of the specified type
    _subscription = ProbeRegistry()
        .eventsByType(eventTrigger.measureType.name)
        .listen((datum) {
      if (eventTrigger?.resumeCondition != null &&
          eventTrigger?.resumeCondition(datum)) super.onResume();
      if (eventTrigger?.pauseCondition != null &&
          eventTrigger?.pauseCondition(datum)) super.onPause();
    });
  }

  Future onPause() async {
    await _subscription.cancel();
    await super.onPause();
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

  TaskExecutor(Task task) : super() {
    assert(task != null, 'Cannot initiate a TaskExecutor without a Task.');
    _task = task;
  }

  void onInitialize(Measure ignored) {
    for (Measure measure in task.measures) {
      // create a new probe for each measure - this ensures that we can have
      // multiple measures of the same type, each using its own probe instance
      Probe probe = ProbeRegistry().create(measure.type.name);
      if (probe != null) {
        executors.add(probe);
        _group.add(probe.events);
        probe.initialize(measure);
      } else {
        warning(
            'A probe for measure type ${measure.type.name} could not be created. '
            'Check that the sampling package containing this probe has been registered in the SamplingPackageRegistry.');
      }
    }
  }
}

/// Executes an [AutomaticTask].
class AutomaticTaskExecutor extends TaskExecutor {
  AutomaticTaskExecutor(AutomaticTask task) : super(task) {
    assert(task is AutomaticTask,
        'AutomaticTaskExecutor should be initialized with a AutomaticTask.');
  }
}
