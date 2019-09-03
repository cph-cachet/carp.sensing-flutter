/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A [Trigger] is a specification of any condition which starts and stops [Task]s at
/// certain points in time when the condition applies. The condition can either
/// be time-bound, based on data streams, initiated by a user of the platform,
/// or a combination of these.
///
/// Sub-classes of [Trigger] implements the specific behavior / timing of a trigger.
/// Note that you should **not** use/instantiate this [Trigger] base class, but only its subclasses.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Trigger extends Serializable {
  /// The list of [Task]s in this [Trigger].
  List<Task> tasks = new List<Task>();

  /// Add a [Task] to this [Trigger]
  void addTask(Task task) => tasks.add(task);

  Trigger() : super();

  static Function get fromJsonFunction => _$TriggerFromJson;
  factory Trigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TriggerToJson(this);
}

/// A trigger that starts sampling immediately and never stops.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImmediateTrigger extends Trigger {
  ImmediateTrigger() : super();

  static Function get fromJsonFunction => _$ImmediateTriggerFromJson;
  factory ImmediateTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ImmediateTriggerToJson(this);
}

/// A trigger that can be started manually by calling the [resume] method
/// and paused by calling the [pause] method.
///
/// Note that sampling continues until it is manually paused.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ManualTrigger extends Trigger {
  ManualTrigger() : super();

  @JsonKey(ignore: true)
  ManualTriggerExecutor executor;

  /// Called when data sampling in this [Trigger] is to be resumed.
  ///
  /// Starting a trigger implies that all [Task]s in this trigger is started,
  /// which again implies that all [Measure]s in these tasks are started.
  /// Therefore, all measures to be started should be 'bundled' into this trigger.
  void resume() => executor?.resume();

  /// Called when data sampling in this [Trigger] is to paused.
  ///
  /// Stopping a trigger implies that all [Task]s in this trigger is paused,
  /// which again implies that all [Measure]s in these tasks are paused.
  void pause() => executor?.pause();

  static Function get fromJsonFunction => _$ManualTriggerFromJson;
  factory ManualTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ManualTriggerToJson(this);
}

/// A trigger that delays sampling for [delay] milliseconds and then starts sampling.
/// Never stops sampling once started.
///
/// The delay is measured from the start of the overall [Study].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DelayedTrigger extends Trigger {
  /// Delay in milliseconds.
  int delay = 0;

  DelayedTrigger({this.delay = 0}) : super();

  static Function get fromJsonFunction => _$DelayedTriggerFromJson;
  factory DelayedTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DelayedTriggerToJson(this);
}

/// A trigger that resume/pause sampling every [period] milliseconds for a specific [duration].
///
/// It is important to specify **both** the [period] and the [duration] in order to specify
/// the timing of resuming and pausing sampling.
///
/// Weekly and montly recurrent triggers can be specified using the [RecurrentScheduledTrigger].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PeriodicTrigger extends Trigger {
  /// The period (reciprocal of frequency) of sampling in milliseconds.
  int period = 60 * 1000; // default is one minute

  /// The duration (until paused) of the the sampling in milliseconds.
  int duration = 1000; // default is one second

  PeriodicTrigger({this.period = 60 * 1000, this.duration = 1000}) : super();

  static Function get fromJsonFunction => _$PeriodicTriggerFromJson;
  factory PeriodicTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PeriodicTriggerToJson(this);
}

/// A trigger that starts sampling based on a [schedule] (date / time) and runs for a specific [duration].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ScheduledTrigger extends Trigger {
  /// The scheduled date and time for resuming sampling.
  DateTime schedule;

  /// The duration (until stopped) of the the sampling in milliseconds.
  /// If null, the sampling is never stopped (i.e., runs forever).
  int duration;

  ScheduledTrigger({this.schedule, this.duration}) : super();

  static Function get fromJsonFunction => _$ScheduledTriggerFromJson;
  factory ScheduledTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ScheduledTriggerToJson(this);
}

/// Type of recurrence for a [RecurrentScheduledTrigger].
enum RecurrentType {
  daily,
  weekly,
}

//enum RecurrentType {
//  daily,
//  weekly,
//  monthly,
//  yearly,
//}

/// A time on a day. Used in a [RecurrentScheduledTrigger].
///
/// Follows the conventions in the [DartTime] class, but only uses the Time part in a 24 hour time format.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Time extends Serializable {
  /// 24 hour format.
  int hour;
  int minute;
  int second;

  Time({this.hour = 0, this.minute = 0, this.second = 0});

  static Function get fromJsonFunction => _$TimeFromJson;
  factory Time.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TimeToJson(this);

  static String _twoDigits(int n) => (n >= 10) ? '$n' : '0$n';
  String toString() => '${_twoDigits(hour)}:${_twoDigits(minute)}:${_twoDigits(second)}';
}

/// A trigger that resume/pause sampling based on a recurrent scheduled date and time.
/// Stops / pause after the specified [duration].
///
/// Supports daily and weekly recurrences. Monthly and yearly recurrence is not supported, since
/// data sampling is not intended to run on such long time scales.
///
/// Here are a couple of examples:
///
/// ```
/// // collect every day at 13:30
/// RecurrentScheduledTrigger(type: RecurrentType.daily, time: Time(hour: 13, minute: 30));
///
/// // collect every other day at 13:30
/// RecurrentScheduledTrigger(type: RecurrentType.daily, time: Time(hour: 13, minute: 30), separationCount: 1);
///
/// // collect every wednesday at 12:23
/// RecurrentScheduledTrigger(type: RecurrentType.weekly, time: Time(hour: 12, minute: 23), dayOfWeek: DateTime.wednesday);
///
/// // collect every 2nd monday at 12:23
///  RecurrentScheduledTrigger(type: RecurrentType.weekly, time: Time(hour: 12, minute: 23), dayOfWeek: DateTime.monday, separationCount: 1);
/// ```
///
/// Thanks to Shantanu Kher for inspiration in his blog post on
/// [Again and Again! Managing Recurring Events In a Data Model](https://www.vertabelo.com/blog/technical-articles/again-and-again-managing-recurring-events-in-a-data-model).
/// We are, however, only using daily and weekly recurrence.
///
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RecurrentScheduledTrigger extends PeriodicTrigger {
  static const int daysPerWeek = 7;

  /// The type of recurrence - daily or weekly.
  RecurrentType type;

  /// The time of day of this trigger.
  Time time;

//  /// Start time and date.
//  ///
//  /// This date-time object specifies two thing;
//  ///
//  ///    * the date of when to start the first instance of the recurrent sampling
//  ///    * the time of the day for each sampling
//  ///
//  /// Hence, if [start] is `2019-08-28T06:12:12.815581Z` then the first sampling in e.g. a daily
//  /// trigger will be on the day of 2019-08-28 and then data will be sampled at 06:12:12 o'clock
//  /// every day.
//  ///
//  /// [duration] specify the duration of the sampling window.
//  DateTime start;

  /// End time and date. If [null], this trigger keeps resuming sampling forever.
  DateTime end;

  /// Separation between recurrences.
  ///
  /// This value signifies the interval (in days, weeks) before the next
  /// event instance is allowed. For example, if an event needs to be configured
  /// for every other week, then [separationCount] is `1`.
  /// The default value is `0`.
  int separationCount = 0;

  /// Maximum number of samplings.
  ///
  /// There are times when we do not know the exact end time and date for recurrent sampling.
  /// But we might know how many occurrences (samplings) are needed to complete it.
  int maxNumberOfSampling;

  /// If weekly recurrence, specify which day of week.
  ///
  /// Stores which day of the week this sampling will take place according to [DateTime] standards,
  /// i.e. having Monday as the first day of the week and Sunday as the last.
  int dayOfWeek;

//  /// If monthly recurrence, specify the week in the month.
//  ///
//  /// [weekOfMonth] is used for samplings that are scheduled for a certain week of the month – i.e.
//  /// the first, second, etc. Possible values are 1,2,3,4, counting from the beginning of the month.
//  int weekOfMonth;
//
//  /// If monthly recurrence, specify the day of the month.
//  ///
//  /// Used in cases when an event is scheduled on a particular day of the month, say the 25th.
//  /// Possible numbers are 1..31 counting from the start of a month.
//  int dayOfMonth;
//
//  /// If yearly recurrence, specify the month of the year.
//  ///
//  /// In combination with [dayOfWeek] and [weekOfMonth],  this value specify the month of year.
//  /// Follows the [DateTime] standards, i.e. possible values are 1..12 counting from the start of a year.
//  int monthOfYear;

  RecurrentScheduledTrigger(
      {this.type,
      this.time,
      this.end,
      this.separationCount = 0,
      this.maxNumberOfSampling,
      this.dayOfWeek,
      //this.weekOfMonth,
      //this.dayOfMonth,
      int duration = 1000})
      : assert(duration != null),
        super(duration: duration);

  DateTime get firstOccurrence {
    DateTime _firstOccurrence;
    DateTime _firstDay;
    DateTime now = DateTime.now();
    DateTime start = DateTime(now.year, now.month, now.day, time.hour, time.minute, time.second);

    switch (type) {
      case RecurrentType.daily:
        _firstDay = (start.isAfter(now)) ? now : DateTime.now().add(Duration(hours: 24));
        break;
      case RecurrentType.weekly:
        int days = dayOfWeek - now.weekday;
        days = (days < 0) ? days + daysPerWeek : days;
        _firstDay = DateTime.now().add(Duration(days: days));
        break;
    }

    _firstOccurrence = DateTime(_firstDay.year, _firstDay.month, _firstDay.day, time.hour, time.minute, time.second);
    return _firstOccurrence;
  }

  /// The period between the recurring samplings.
  int get period {
    switch (type) {
      case RecurrentType.daily:
        return (separationCount + 1) * Duration.millisecondsPerDay;
      case RecurrentType.weekly:
        return (separationCount + 1) * daysPerWeek * Duration.millisecondsPerDay;
      default:
        return -1;
    }
  }

  static Function get fromJsonFunction => _$RecurrentScheduledTriggerFromJson;
  factory RecurrentScheduledTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$RecurrentScheduledTriggerToJson(this);

  String toString() =>
      'RecurrentScheduledTrigger - type: $type, time: $time, separationCount: $separationCount, dayOfWeek: $dayOfWeek, firstOccurrence: $firstOccurrence, period; $period';
}

/// A trigger that resume and pause sampling when some (other) sampling event occurs.
///
/// For example, if [measureType] is `carp.geofence` the [resumeCondition] can be `{'DTU','ENTER'}`
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SamplingEventTrigger extends Trigger {
  SamplingEventTrigger({this.measureType, this.resumeCondition, this.pauseCondition}) : super();

  /// The [MeasureType] of the event to look for.
  ///
  /// If [resumeCondition] is null, sampling will be triggered for all events of this type.
  MeasureType measureType;

  /// The [Datum] specifying a specific sampling value to compare with for resuming this trigger.
  ///
  /// When comparing, the `==` operator is used. Hence, the sampled datum and
  /// this datum must be equal (`==`) in order to start sampling based on an event.
  /// Note that the `==` operator can be overwritten in application-specific [Datum]s
  /// to support this.
  ///
  /// If [resumeCondition] is null, sampling will be triggered / resumed on every sampling
  /// event that matches the specified [measureType].
  Datum resumeCondition;

  /// The [Datum] specifying a specific sampling value to compare with for pausing this trigger
  Datum pauseCondition;

  static Function get fromJsonFunction => _$SamplingEventTriggerFromJson;
  factory SamplingEventTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$SamplingEventTriggerToJson(this);
}

/// Takes a [Datum] from a sampling stream and evaluates if an event has occurred.
/// Returns [true] if the event has occurred, [false] otherwise.
typedef EventConditionEvaluator = bool Function(Datum datum);

/// A trigger that resume sampling when some (other) sampling event occurs and
/// a application-specific [condition] is meet.
///
/// In contrast to other [Trigger]s, this trigger cannot be de/serialized from/to JSON.
/// This implies that if can not be retrieved as part of a [Study] from a [StudyManager]
/// since it relies on specifying a Dart-specific function as the [EventConditionEvaluator]
/// method. Hence, this trigger is mostly useful when creating a [Study] directly in the app
/// using Dart code.
///
/// If you need to de/serialize an event trigger, use the [SamplingEventTrigger] instead.
class ConditionalSamplingEventTrigger extends Trigger {
  ConditionalSamplingEventTrigger({this.measureType, this.resumeCondition, this.pauseCondition}) : super();

  /// The [MeasureType] of the event to look for.
  MeasureType measureType;

  /// The [EventConditionEvaluator] function evaluating if the event condition is meet
  /// for resuming this trigger
  EventConditionEvaluator resumeCondition;

  /// The [EventConditionEvaluator] function evaluating if the event condition is meet
  /// for pausing this trigger
  EventConditionEvaluator pauseCondition;
}
