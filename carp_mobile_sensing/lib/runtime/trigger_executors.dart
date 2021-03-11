/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// An abstract class used to implement executors.
/// See [StudyDeploymentExecutor] and [TaskExecutor] for examples.
abstract class Executor extends AbstractProbe {
  static final DeviceInfo deviceInfo = DeviceInfo();
  final StreamGroup<DataPoint> _group = StreamGroup.broadcast();
  List<Probe> executors = [];
  Stream<DataPoint> get events => _group.stream;

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
// STUDY DEPLOYMENT EXECUTOR
// ---------------------------------------------------------------------------------------------------------

/// The [StudyDeploymentExecutor] is responsible for executing a [MasterDeviceDeployment].
/// For each triggered task in this deployment, it starts a [TriggeredTaskExecutor].
///
/// Note that the [StudyDeploymentExecutor] in itself is a [Probe] and hence work
/// as a 'super probe'.
/// This - amongst other things - imply that you can listen to data point
/// [events] from a study executor.
class StudyDeploymentExecutor extends Executor {
  final StreamController<DataPoint> _manualDataPointController =
      StreamController.broadcast();
  MasterDeviceDeployment get deployment => _deployment;
  MasterDeviceDeployment _deployment;

  StudyDeploymentExecutor(MasterDeviceDeployment deployment) : super() {
    assert(deployment != null,
        'Cannot initiate a StudyDeploymentExecutor without a MasterDeviceDeployment.');
    _deployment = deployment;
    _group.add(_manualDataPointController.stream);

    deployment.triggeredTasks.forEach((triggeredTask) {
      // get the trigger based on the trigger id
      Trigger trigger = _deployment.triggers[triggeredTask.triggerId];
      // get the task based on the task name
      TaskDescriptor task = _deployment.getTaskByName(triggeredTask.taskName);

      TriggeredTaskExecutor executor = getTriggeredTaskExecutor(trigger, task);
      executor.triggerId = triggeredTask.triggerId;
      executor.deviceRoleName = triggeredTask.destinationDeviceRoleName;

      _group.add(executor.events);
      executors.add(executor);
    });
  }

  Future onResume() async {
    // check the start time for this study on this phone
    // this will save it, the first time the study is executed
    DateTime studyStartTimestamp = await settings.studyStartTimestamp;
    info(
        'Study deployment was started on this phone on ${studyStartTimestamp.toUtc()}');

    await super.onResume();
  }

  /// Add a [DataPoint] object to the stream of events.
  void addDataPoint(DataPoint dataPoint) =>
      _manualDataPointController.add(dataPoint);

  /// Add a error to the stream of events.
  void addError(Object error, [StackTrace stacktrace]) =>
      _manualDataPointController.addError(error, stacktrace);

  /// Returns a list of the running probes in this study executor.
  /// This is a combination of the running probes in all trigger executors.
  List<Probe> get probes {
    List<Probe> _probes = [];
    executors.forEach((executor) {
      if (executor is TriggeredTaskExecutor) {
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

/// Returns the relevant [TriggeredTaskExecutor] based on the type of [trigger].
TriggeredTaskExecutor getTriggeredTaskExecutor(
    Trigger trigger, TaskDescriptor task) {
  switch (trigger.runtimeType) {
    // actually, the base Trigger and CAMSTrigger classes is not supposed to be used
    // but if it is, treat it as an ImmediateTrigger
    case Trigger:
    case CAMSTrigger:
    case ImmediateTrigger:
      return ImmediateTriggerExecutor(trigger, task);
    case DelayedTrigger:
      return DelayedTriggerExecutor(trigger, task);
    case PeriodicTrigger:
      return PeriodicTriggerExecutor(trigger, task);
    case DateTimeTrigger:
      return DateTimeTriggerExecutor(trigger, task);
    case RecurrentScheduledTrigger:
      return RecurrentScheduledTriggerExecutor(trigger, task);
    case CronScheduledTrigger:
      return CronScheduledTriggerExecutor(trigger, task);
    case SamplingEventTrigger:
      return SamplingEventTriggerExecutor(trigger, task);
    case ConditionalSamplingEventTrigger:
      return ConditionalSamplingEventTriggerExecutor(trigger, task);
    case ManualTrigger:
      return PassiveTriggerExecutor(trigger, task);
    default:
      return ImmediateTriggerExecutor(trigger, task);
  }
}

/// Responsible for handling the execution of a [TriggeredTask].
///
/// This is an abstract class. For each specific type of [Trigger],
/// a corresponding implementation of a [TriggeredTaskExecutor] exists.
abstract class TriggeredTaskExecutor extends Executor {
  CAMSTrigger _trigger;
  TaskDescriptor _task;

  CAMSTrigger get trigger => _trigger;
  TaskDescriptor get task => _task;

  TriggeredTaskExecutor(CAMSTrigger trigger, TaskDescriptor task) : super() {
    assert(trigger != null,
        'Cannot initiate a TriggeredTaskExecutor without a Trigger.');
    _trigger = trigger;
    assert(task != null,
        'Cannot initiate a TriggeredTaskExecutor without a Task.');
    _task = task;

    TaskExecutor executor = getTaskExecutor(task);
    _group.add(executor.events);
    executors.add(executor);

    // for (TaskDescriptor task in trigger.tasks) {
    //   TaskExecutor executor = getTaskExecutor(task);
    //   _group.add(executor.events);
    //   executors.add(executor);
    // }
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
class ImmediateTriggerExecutor extends TriggeredTaskExecutor {
  ImmediateTriggerExecutor(CAMSTrigger trigger, TaskDescriptor task)
      : super(trigger, task);
}

/// Executes a [PassiveTrigger].
class PassiveTriggerExecutor extends TriggeredTaskExecutor {
  PassiveTriggerExecutor(PassiveTrigger trigger, TaskDescriptor task)
      : super(trigger, task) {
    trigger.executor = ImmediateTriggerExecutor(trigger, task);
    _group.add(trigger.executor.events);
  }

  // Forward to the embedded trigger executor
  void onInitialize(Measure measure) =>
      (trigger as PassiveTrigger).executor.initialize(measure);

  // A no-op methods since a ManualTrigger can only be resumed/paused
  // using the resume/pause methods on the ManualTrigger.
  Future onResume() async {}
  Future onPause() async {}

  // Forward to the embedded trigger executor
  Future onRestart({Measure measure}) async =>
      (trigger as PassiveTrigger).executor.restart();
  Future onStop() async => (trigger as PassiveTrigger).executor.stop();

  List<Probe> get probes => (trigger as PassiveTrigger).executor.probes;
}

/// Executes a [DelayedTrigger], i.e. resumes sampling after the specified delay.
/// Once started, it can be paused / resumed as any other [Executor].
class DelayedTriggerExecutor extends TriggeredTaskExecutor {
  DelayedTriggerExecutor(DelayedTrigger trigger, TaskDescriptor task)
      : super(trigger, task);

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
class PeriodicTriggerExecutor extends TriggeredTaskExecutor {
  Duration period, duration;
  Timer timer;

  PeriodicTriggerExecutor(PeriodicTrigger trigger, TaskDescriptor task)
      : super(trigger, task) {
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

/// Executes a [DateTimeTrigger] on the specified [DateTimeTrigger.schedule]
/// date and time.
class DateTimeTriggerExecutor extends TriggeredTaskExecutor {
  Duration delay, duration;
  Timer timer;

  DateTimeTriggerExecutor(DateTimeTrigger trigger, TaskDescriptor task)
      : super(trigger, task) {
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

  RecurrentScheduledTriggerExecutor(
      RecurrentScheduledTrigger trigger, TaskDescriptor task)
      : super(trigger, task) {
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
class CronScheduledTriggerExecutor extends TriggeredTaskExecutor {
  cron.Cron _cron;
  cron.Schedule _schedule;
  cron.ScheduledTask _scheduledTask;

  CronScheduledTriggerExecutor(
      CronScheduledTrigger trigger, TaskDescriptor task)
      : super(trigger, task) {
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
class SamplingEventTriggerExecutor extends TriggeredTaskExecutor {
  SamplingEventTriggerExecutor(
      SamplingEventTrigger trigger, TaskDescriptor task)
      : super(trigger, task);

  StreamSubscription<DataPoint> _subscription;

  Future onResume() async {
    SamplingEventTrigger eventTrigger = trigger as SamplingEventTrigger;
    // start listen for events of the specified type
    _subscription = ProbeRegistry()
        .eventsByType(eventTrigger?.measureType?.toString())
        .listen((dataPoint) {
      if ((eventTrigger?.resumeCondition == null) ||
          (dataPoint.carpBody == eventTrigger?.resumeCondition))
        super.onResume();
      if (eventTrigger?.pauseCondition != null &&
          dataPoint.carpBody == eventTrigger?.pauseCondition) super.onPause();
    });
  }

  Future onPause() async {
    await _subscription.cancel();
    await super.onPause();
  }
}

/// Executes a [ConditionalSamplingEventTrigger] based on the specified
/// [ConditionalSamplingEventTrigger.measureType] and their
/// [ConditionalSamplingEventTrigger.resumeCondition] and
/// [ConditionalSamplingEventTrigger.pauseCondition].
class ConditionalSamplingEventTriggerExecutor extends TriggeredTaskExecutor {
  ConditionalSamplingEventTriggerExecutor(
      ConditionalSamplingEventTrigger trigger, TaskDescriptor task)
      : super(trigger, task);

  StreamSubscription<DataPoint> _subscription;

  Future onResume() async {
    ConditionalSamplingEventTrigger eventTrigger =
        trigger as ConditionalSamplingEventTrigger;

    // listen for event of the specified type
    _subscription = ProbeRegistry()
        .eventsByType(eventTrigger?.measureType.toString())
        .listen((dataPoint) {
      if (eventTrigger?.resumeCondition != null &&
          eventTrigger?.resumeCondition(dataPoint)) super.onResume();
      if (eventTrigger?.pauseCondition != null &&
          eventTrigger?.pauseCondition(dataPoint)) super.onPause();
    });
  }

  Future onPause() async {
    await _subscription.cancel();
    await super.onPause();
  }
}
