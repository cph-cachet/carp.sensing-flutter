/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A trigger that starts sampling immediately and never stops.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ImmediateTrigger extends Trigger {
  ImmediateTrigger() : super();

  Function get fromJsonFunction => _$ImmediateTriggerFromJson;
  factory ImmediateTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as ImmediateTrigger;
  Map<String, dynamic> toJson() => _$ImmediateTriggerToJson(this);
}

/// A trigger that waits to be started until the [resume] method is called.
/// Is paused by calling the [pause] method.
///
/// Note that sampling continues until it is explicitly paused.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PassiveTrigger extends Trigger {
  PassiveTrigger() : super();

  @JsonKey(ignore: true)
  late TriggerExecutor executor;

  /// Called when data sampling in this trigger is to be resumed.
  ///
  /// Starting a trigger implies that all tasks in this trigger is started,
  /// which again implies that all [Measure]s in these tasks are started.
  /// Therefore, all measures to be started should be 'bundled' into this trigger.
  void resume() => executor.resume();

  /// Called when data sampling in this trigger is to paused.
  ///
  /// Stopping a trigger implies that all tasks in this trigger is paused,
  /// which again implies that all [Measure]s in these tasks are paused.
  void pause() => executor.pause();

  Function get fromJsonFunction => _$PassiveTriggerFromJson;
  factory PassiveTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PassiveTrigger;
  Map<String, dynamic> toJson() => _$PassiveTriggerToJson(this);
}

/// A trigger that delays sampling for [delay] and then starts sampling.
/// Never stops sampling once started.
///
/// The delay is measured from the **start of sensing**, i.e. typically when
/// resume() is called on a [SmartphoneDeploymentController].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DelayedTrigger extends Trigger {
  /// Delay before this trigger is executed.
  Duration delay;

  DelayedTrigger({required this.delay}) : super();

  Function get fromJsonFunction => _$DelayedTriggerFromJson;
  factory DelayedTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DelayedTrigger;
  Map<String, dynamic> toJson() => _$DelayedTriggerToJson(this);
}

/// A trigger that delays sampling for [delay] and then starts sampling.
/// Never stops sampling once started.
///
/// In contrast to the [DelayedTrigger], the delay is measured from the **start
/// of deployment**, i.e. when a protocol is deployed on the phone for the first
/// time. And since deployment information is saved across app restart, this delay
/// is also consistent across app restart.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DeploymentDelayedTrigger extends Trigger {
  /// Delay before this trigger is executed.
  Duration delay;

  DeploymentDelayedTrigger({required this.delay}) : super();

  Function get fromJsonFunction => _$DeploymentDelayedTriggerFromJson;
  factory DeploymentDelayedTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DeploymentDelayedTrigger;
  Map<String, dynamic> toJson() => _$DeploymentDelayedTriggerToJson(this);
}

/// A trigger that resume/pause sampling every [period] for a specific [duration].
///
/// It is important to specify **both** the [period] and the [duration] in order
/// to specify the timing of resuming and pausing sampling.
///
/// Weekly and montly recurrent triggers can be specified using the [RecurrentScheduledTrigger].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class PeriodicTrigger extends Trigger {
  /// The period (reciprocal of frequency) of sampling.
  Duration period;

  /// The duration (until paused) of the the sampling.
  Duration duration;

  PeriodicTrigger({
    required this.period,
    this.duration = const Duration(seconds: 1),
  }) : super();

  Function get fromJsonFunction => _$PeriodicTriggerFromJson;
  factory PeriodicTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as PeriodicTrigger;
  Map<String, dynamic> toJson() => _$PeriodicTriggerToJson(this);
}

/// A trigger that starts sampling based on a [schedule] of a date and time,
/// and runs for a specific [duration].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class DateTimeTrigger extends Trigger {
  /// The scheduled date and time for resuming sampling.
  DateTime schedule;

  /// The duration (until stopped) of the the sampling.
  /// If `null`, the sampling is never stopped (i.e., runs forever).
  Duration? duration;

  DateTimeTrigger({
    required this.schedule,
    this.duration,
  }) : super();

  Function get fromJsonFunction => _$DateTimeTriggerFromJson;
  factory DateTimeTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as DateTimeTrigger;
  Map<String, dynamic> toJson() => _$DateTimeTriggerToJson(this);
}

/// Type of recurrence for a [RecurrentScheduledTrigger].
enum RecurrentType {
  daily,
  weekly,
  monthly,
  //yearly,
}

/// A time on a day.
///
/// Follows the conventions in the [DartTime] class, but only uses the Time
/// part in a 24 hour time format.
///
/// Used in a [RecurrentScheduledTrigger] and [RandomRecurrentTrigger].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Time extends Serializable {
  /// 24 hour format.
  int hour;
  int minute;
  int second;

  Time({this.hour = 0, this.minute = 0, this.second = 0}) : super();

  factory Time.now() {
    DateTime now = DateTime.now();
    return Time(hour: now.hour, minute: now.minute, second: now.second);
  }

  /// Returns true if [this] occurs before [other].
  ///
  /// The comparison is independent of whether the time is in UTC or in
  /// the local time zone.
  bool isBefore(Time other) => DateTime(2021, 1, 1, hour, minute, second)
      .isBefore(DateTime(2021, 1, 1, other.hour, other.minute, other.second));

  /// Returns true if [this] occurs after [other].
  ///
  /// The comparison is independent of whether the time is in UTC or in
  /// the local time zone.
  bool isAfter(Time other) => DateTime(2021, 1, 1, hour, minute, second)
      .isAfter(DateTime(2021, 1, 1, other.hour, other.minute, other.second));

  /// Returns a [Duration] with the difference when subtracting [other] from
  /// [this].
  ///
  ///  The returned [Duration] will be negative if [other] occurs after [this].
  Duration difference(Time other) => DateTime(2021, 1, 1, hour, minute, second)
      .difference(DateTime(2021, 1, 1, other.hour, other.minute, other.second));

  Function get fromJsonFunction => _$TimeFromJson;
  factory Time.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as Time;
  Map<String, dynamic> toJson() => _$TimeToJson(this);

  static String _twoDigits(int n) => (n >= 10) ? '$n' : '0$n';
  String toString() =>
      '${_twoDigits(hour)}:${_twoDigits(minute)}:${_twoDigits(second)}';
}

/// A trigger that resume/pause sampling based on a recurrent scheduled date and time.
/// Stops / pause after the specified [duration].
///
/// Supports daily, weekly and monthly recurrences. Yearly recurrence is not
/// supported, since data sampling is not intended to run on such long time scales.
///
/// Here are a couple of examples:
///
/// ```
///  // collect every day at 13:30
///  RecurrentScheduledTrigger(type: RecurrentType.daily, time: Time(hour: 13, minute: 30));
///
///  // collect every other day at 13:30
///  RecurrentScheduledTrigger(type: RecurrentType.daily, separationCount: 1, time: Time(hour: 13, minute: 30));
///
///  // collect every wednesday at 12:23
///  RecurrentScheduledTrigger(type: RecurrentType.weekly, dayOfWeek: DateTime.wednesday, time: Time(hour: 12, minute: 23));
///
///  // collect every 2nd monday at 12:23
///  RecurrentScheduledTrigger(type: RecurrentType.weekly, dayOfWeek: DateTime.monday, separationCount: 1, time: Time(hour: 12, minute: 23));
///
///  // collect monthly in the second week on a monday at 14:30
///  RecurrentScheduledTrigger(type: RecurrentType.monthly, weekOfMonth: 2, dayOfWeek: DateTime.monday, time: Time(hour: 14, minute: 30));
///
///  // collect quarterly on the 11th day of the first month in each quarter at 21:30
///  RecurrentScheduledTrigger(type: RecurrentType.monthly, dayOfMonth: 11, separationCount: 2, time: Time(hour: 21, minute: 30));
/// ```
///
/// Recurrent scheduled triggers can be saved across app shutdown by setting [remember] to true.
/// For example;
///
/// ```
///       RecurrentScheduledTrigger(
///         triggerId: '1234wef',
///         type: RecurrentType.monthly,
///         dayOfMonth: 11,
///         separationCount: 2,
///         time: Time(hour: 21, minute: 30),
///         remember: true,
///       );
/// ```
///
/// would create the quarterly schedule above. But if the app shuts down before
/// this schedule, and restarted after, the trigger would still trigger (immediately).
/// Note that the [triggerId] must be specified when remembering triggers (it
/// is used as the key).
///
/// Thanks to Shantanu Kher for inspiration in his blog post on
/// [Again and Again! Managing Recurring Events In a Data Model](https://www.vertabelo.com/blog/technical-articles/again-and-again-managing-recurring-events-in-a-data-model).
/// We are, however, not using yearly recurrence.
/// Moreover, monthly recurrences make little sense in mobile sensing, even
/// though it is supported.
///
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class RecurrentScheduledTrigger extends PeriodicTrigger {
  static const int daysPerWeek = 7;
  static const int daysPerMonth = 30;

  /// The type of recurrence - daily, weekly or monthly.
  RecurrentType type;

  /// The time of day of this trigger.
  Time time;

  /// End time and date. If [null], this trigger keeps sampling forever.
  DateTime? end;

  /// Separation between recurrences.
  ///
  /// This value signifies the interval (in days, weeks or months) before the next
  /// event instance is allowed. For example, if an event needs to be configured
  /// for every other week, then [separationCount] is `1`.
  /// The default value is `0`.
  int separationCount = 0;

  /// Maximum number of samplings.
  ///
  /// There are times when we do not know the exact end time and date for
  /// recurrent sampling. But we might know how many occurrences (samplings)
  /// are needed to complete it.
  int? maxNumberOfSampling;

  /// If weekly recurrence, specify which day of week.
  ///
  /// Stores which day of the week this sampling will take place according to [
  /// DateTime] standards, i.e. having Monday as the first day of the week and
  /// Sunday as the last.
  int? dayOfWeek;

  /// If monthly recurrence, specify the week in the month.
  ///
  /// [weekOfMonth] is used for samplings that are scheduled for a certain
  /// week of the month – i.e., the first, second, etc.
  /// Possible values are 1,2,3,4. The first week is the week of the first
  /// Monday of a month. For example, the first week of September 2020 is the
  /// week starting on Monday 2020-09-07.
  int? weekOfMonth;

  /// If monthly recurrence, specify the day of the month.
  ///
  /// Used in cases when an event is scheduled on a particular day of the month,
  /// say the 25th. Possible numbers are 1..31 counting from the start of a month.
  int? dayOfMonth;

  /// Should this recurrent scheduled trigger be remembered across app restart?
  ///
  /// This is useful for long schedules (e.g. daily, weekly, or monthly).
  /// If, for example, a monthly trigger is specified, the app can be closed
  /// at the time of the triggering. If not remembered, then the next trigger
  /// would not happen until next month.
  ///
  /// It is important to specify a unique [triggerId] since this is used as key.
  ///
  /// See [Issue #80](https://github.com/cph-cachet/carp.sensing-flutter/issues/80).
  bool remember = false;

  /// The unique id of this trigger. Only used if [remember] is `true`.
  String? triggerId;

  /// Creates a [RecurrentScheduledTrigger].
  RecurrentScheduledTrigger({
    required this.type,
    required this.time,
    this.end,
    this.separationCount = 0,
    this.maxNumberOfSampling,
    this.dayOfWeek,
    this.weekOfMonth,
    this.dayOfMonth,
    this.remember = false,
    this.triggerId,
    Duration duration = const Duration(seconds: 10),
  }) : super(period: const Duration(seconds: 1), duration: duration) {
    assert(separationCount >= 0, 'Separation count must be zero or positive.');
    if (type == RecurrentType.weekly) {
      assert(dayOfWeek != null,
          'dayOfWeek must be specified in a weekly recurrence.');
    } else if (type == RecurrentType.monthly) {
      assert(weekOfMonth != null || dayOfMonth != null,
          'Specify monthly recurrence using either dayOfMonth or weekOfMonth');
      assert(dayOfMonth == null || (dayOfMonth! >= 1 && dayOfMonth! <= 31),
          'dayOfMonth must be in the range [1-31]');
      assert(weekOfMonth == null || (weekOfMonth! >= 1 && weekOfMonth! <= 4),
          'weekOfMonth must be in the range [1-4]');
    }
    if (remember) {
      assert(triggerId != null,
          'A unique trigger ID should be specified when remembering scheduled triggers.');
    }
  }

  /// The next day in a monthly occurrence from the given [fromDate].
  DateTime nextMonthlyDay(DateTime fromDate) => fromDate
      .subtract(Duration(days: fromDate.weekday - 1))
      .add(Duration(days: 7 * weekOfMonth! + dayOfWeek! - 1));

  /// The date and time of the first occurrence of this trigger.
  DateTime get firstOccurrence {
    late DateTime firstDay;
    DateTime now = DateTime.now();
    DateTime start = DateTime(
        now.year, now.month, now.day, time.hour, time.minute, time.second);

    switch (type) {
      case RecurrentType.daily:
        firstDay =
            (start.isAfter(now)) ? start : start.add(Duration(hours: 24));
        break;
      case RecurrentType.weekly:
        int days = dayOfWeek! - now.weekday;
        days = (days < 0) ? days + daysPerWeek : days;
        firstDay = start.add(Duration(days: days));
        // check if this is the same day, but a time slot earlier this day
        firstDay = (firstDay.isBefore(now))
            ? firstDay.add(Duration(days: daysPerWeek))
            : firstDay;
        break;
      case RecurrentType.monthly:
        if (dayOfMonth != null) {
          // we have a trigger of the following type: collect quarterly on the 11th day of the first month in each quarter at 21:30
          //   RecurrentScheduledTrigger(type: RecurrentType.monthly, dayOfMonth: 11, separationCount: 2, time: Time(hour: 21, minute: 30));
          int days = dayOfMonth! - now.day;
          int month = (days > 0)
              ? now.month + separationCount
              : now.month + separationCount + 1;
          int year = now.year;
          if (month > 12) {
            year = now.year + 1;
            month = month - DateTime.monthsPerYear;
          }
          firstDay = DateTime(year, month, dayOfMonth!);
        } else {
          // we have a trigger of the following type: collect monthly in the second week on a monday at 14:30
          //   RecurrentScheduledTrigger(type: RecurrentType.monthly, weekOfMonth: 2, dayOfWeek: DateTime.monday, time: Time(hour: 14, minute: 30));
          firstDay = nextMonthlyDay(DateTime(now.year, now.month, 1));
          // check if this day is in the past - if so, move one month forward
          if (firstDay.isBefore(now)) {
            firstDay = nextMonthlyDay(DateTime(now.year, now.month + 1, 1));
          }
        }
        break;
    }

    return DateTime(firstDay.year, firstDay.month, firstDay.day, time.hour,
        time.minute, time.second);
  }

  /// The period between the recurring samplings.
  Duration get period {
    switch (type) {
      case RecurrentType.daily:
        return Duration(days: separationCount + 1);
      case RecurrentType.weekly:
        return Duration(days: (separationCount + 1) * daysPerWeek);
      case RecurrentType.monthly:
        // @TODO - this is not a correct model...
        // the period in monthly recurring triggers is not fixed, but depends on the specific month(s)
        // but the current implementation of the [RecurrentScheduledTriggerExecutor] expects a fixed period
        return Duration(days: (separationCount + 1) * daysPerMonth);
    }
  }

  Function get fromJsonFunction => _$RecurrentScheduledTriggerFromJson;
  factory RecurrentScheduledTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as RecurrentScheduledTrigger;
  Map<String, dynamic> toJson() => _$RecurrentScheduledTriggerToJson(this);

  String toString() =>
      'RecurrentScheduledTrigger - type: $type, time: $time, separationCount: $separationCount, dayOfWeek: $dayOfWeek, firstOccurrence: $firstOccurrence, period; $period';
}

/// A trigger that resume and pause sampling based on a cron job specification.
///
/// Bases on the [`cron`](https://pub.dev/packages/cron) package.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CronScheduledTrigger extends Trigger {
  /// The cron job expression.
  String cronExpression;

  /// The duration (until stopped) of the the sampling.
  /// If null, the sampling is never stopped (i.e., runs forever).
  late Duration duration;

  /// Create a cron scheduled trigger based on specifying:
  ///   * [minute] - The minute to trigger. `int` [0-59] or `null` (= match all).
  ///   * [hour] - The hour to trigger. `int` [0-23] or `null` (= match all).
  ///   * [day] - The day of the month to trigger. `int` [1-31] or `null` (= match all).
  ///   * [month] - The month to trigger. `int` [1-12] or `null` (= match all).
  ///   * [weekday] - The week day to trigger. `int` [0-6] or `null` (= match all).
  ///   * [duration] - The duration (until stopped) of the the sampling.
  factory CronScheduledTrigger({
    int? minute,
    int? hour,
    int? day,
    int? month,
    int? weekday,
    Duration duration = const Duration(seconds: 1),
  }) {
    assert(minute == null || (minute >= 0 && minute <= 59),
        'minute must be in the range of [0-59] or null (=match all).');
    assert(hour == null || (hour >= 0 && hour <= 23),
        'hour must be in the range of [0-23] or null (=match all).');
    assert(day == null || (day >= 1 && day <= 31),
        'day must be in the range of [1-31] or null (=match all).');
    assert(month == null || (month >= 1 && month <= 12),
        'month must be in the range of [1-12] or null (=match all).');
    assert(weekday == null || (weekday >= 0 && weekday <= 6),
        'weekday must be in the range of [0-6] or null (=match all).');
    return CronScheduledTrigger._(
        cronExpression: _cronToString(minute, hour, day, month, weekday),
        duration: duration);
  }

  /// Create a trigger based on a cron-formatted string expression.
  ///
  ///   * [cronExpression] - The cron expression as a `String`.
  ///   * [duration] - The duration (until stopped) of the the sampling.
  ///
  /// Cron format used is:
  ///
  ///    `<minutes> <hours> <days> <months> <weekdays>`
  ///
  /// For example `42 19 * * *` is "Everyday at 19:42".
  ///
  /// See e.g. [crontab guru](https://crontab.guru/) for help in formatting cron jobs.
  factory CronScheduledTrigger.parse({
    required String cronExpression,
    Duration duration = const Duration(seconds: 1),
  }) =>
      CronScheduledTrigger._(
          cronExpression: cronExpression, duration: duration);

  CronScheduledTrigger._({
    required this.cronExpression,
    this.duration = const Duration(seconds: 1),
  }) : super();

  static String _cronToString(
          int? minute, int? hour, int? day, int? month, int? weekday) =>
      '${_cf(minute)} ${_cf(hour)} ${_cf(day)} ${_cf(month)} ${_cf(weekday)}';
  static String _cf(int? exp) => (exp == null) ? '*' : exp.toString();

  Function get fromJsonFunction => _$CronScheduledTriggerFromJson;
  factory CronScheduledTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as CronScheduledTrigger;
  Map<String, dynamic> toJson() => _$CronScheduledTriggerToJson(this);

  String toString() => "$runtimeType - cron expression: '$cronExpression'";
}

/// A trigger that resume and pause sampling when some (other) sampling event
/// occurs.
///
/// For example, if [measureType] is `dk.cachet.carp.geofence` the [resumeCondition]
/// can be;
/// ```
///   ConditionalEvent({
///     'name': 'DTU',
///     'type': 'ENTER',
///   });
/// ```
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SamplingEventTrigger extends Trigger {
  /// The data type of the event to look for.
  ///
  /// If [resumeCondition] is null, sampling will be triggered for all events
  /// of this type.
  String measureType;

  /// The [ConditionalEvent] specifying a specific sampling value to compare
  /// with for resuming this trigger.
  ///
  /// When comparing, the [Datum.equivalentTo] method. is used. Hence, the
  /// sampled datum must be "equivalent" to this resumeCondition in order to
  /// start sampling based on an event.
  /// Note that the `equivalentTo` method must be overwritten in
  /// application-specific [Datum] classes to support this.
  ///
  /// If [resumeCondition] is null, sampling will be triggered / resumed on
  /// every sampling event that matches the specified [measureType].
  ConditionalEvent? resumeCondition;

  /// The [ConditionalEvent] specifying a specific sampling value to compare
  /// with for pausing this trigger.
  ///
  /// If [pauseCondition] is null, sampling is never paused and hence runs
  /// forever (unless paused manually).
  ConditionalEvent? pauseCondition;

  SamplingEventTrigger({
    required this.measureType,
    this.resumeCondition,
    this.pauseCondition,
  }) : super();

  Function get fromJsonFunction => _$SamplingEventTriggerFromJson;
  factory SamplingEventTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as SamplingEventTrigger;
  Map<String, dynamic> toJson() => _$SamplingEventTriggerToJson(this);
}

/// Specified the configuration of an event in a [SamplingEventTrigger].
///
/// The [condition] is a key-value map of values that can be checked in
/// the [Datum.equivalentTo] method.
/// This `equivalentTo` method must be implemented for each [Datum] used
/// in a [SamplingEventTrigger].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ConditionalEvent extends Serializable {
  Map<String, dynamic> condition;
  ConditionalEvent(this.condition) : super();

  dynamic operator [](String index) => condition[index];

  Function get fromJsonFunction => _$ConditionalEventFromJson;
  factory ConditionalEvent.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as ConditionalEvent;
  Map<String, dynamic> toJson() => _$ConditionalEventToJson(this);
}

/// Takes a [DataPoint] from a sampling stream and evaluates if an event has
/// occurred. Returns [true] if the event has occurred, [false] otherwise.
typedef ConditionalEventEvaluator = bool Function(DataPoint dataPoint);

/// A trigger that resume and pause sampling when some (other) sampling event
/// occurs and a application-specific condition is meet.
///
/// Note that the [resumeCondition] and [pauseCondition] are an
/// [ConditionalEventEvaluator] function which cannot be serialized to/from JSON.
/// In contrast to other [Trigger]s, this trigger cannot be de/serialized
/// from/to JSON.
/// This implies that it can not be retrieved as part of a [StudyProtocol] from a
/// [DeploymentService] since it relies on specifying a Dart-specific function as
/// the [ConditionalEventEvaluator] methods. Hence, this trigger is mostly
/// useful when creating a [StudyProtocol] directly in the app using Dart code.
///
/// If you need to de/serialize an event trigger, use the [SamplingEventTrigger]
/// instead.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ConditionalSamplingEventTrigger extends Trigger {
  /// The data type of the event to look for.
  String measureType;

  /// The [ConditionalEventEvaluator] function evaluating if the event
  /// condition is meet for resuming this trigger
  @JsonKey(ignore: true)
  ConditionalEventEvaluator? resumeCondition;

  /// The [ConditionalEventEvaluator] function evaluating if the event
  /// condition is meet for pausing this trigger.
  ///
  /// If [pauseCondition] is not specified (`null`), sampling is never paused
  /// and hence runs forever (unless paused manually).
  @JsonKey(ignore: true)
  ConditionalEventEvaluator? pauseCondition;

  /// Create a [ConditionalSamplingEventTrigger].
  ConditionalSamplingEventTrigger({
    required this.measureType,
    this.resumeCondition,
    this.pauseCondition,
  }) : super();

  Function get fromJsonFunction => _$ConditionalSamplingEventTriggerFromJson;
  factory ConditionalSamplingEventTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as ConditionalSamplingEventTrigger;
  Map<String, dynamic> toJson() =>
      _$ConditionalSamplingEventTriggerToJson(this);
}

/// Evaluates if a [ConditionalPeriodicTrigger] should resume or pause.
/// Returns [true] if resume or pause should happen, [false] otherwise.
typedef ConditionalEvaluator = bool Function();

/// A trigger that checks if application-specific resume and pause conditions
/// are meet.
///
/// Note that the [resumeCondition] and [pauseCondition] are
/// [ConditionalEvaluator] function which cannot be serialized to/from JSON.
/// In contrast to other [Trigger]s, this trigger cannot be de/serialized
/// from/to JSON.
/// This implies that it can not be retrieved as part of a [StudyProtocol] from a
/// [DeploymentService] since it relies on specifying a Dart-specific function as
/// the [ConditionalEvaluator] methods. Hence, this trigger is mostly
/// useful when creating a [StudyProtocol] directly in the app using Dart code.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ConditionalPeriodicTrigger extends Trigger {
  /// The period of when to check the [resumeCondition] and [pauseCondition].
  Duration period;

  /// The [ConditionalEventEvaluator] function evaluating if the event
  /// condition is meet for resuming this trigger
  @JsonKey(ignore: true)
  ConditionalEvaluator? resumeCondition;

  /// The [ConditionalEventEvaluator] function evaluating if the event
  /// condition is meet for pausing this trigger.
  ///
  /// If [pauseCondition] is not specified (`null`), sampling is never paused
  /// and hence runs forever (unless paused manually).
  @JsonKey(ignore: true)
  ConditionalEvaluator? pauseCondition;

  /// Create a [ConditionalSamplingEventTrigger].
  ConditionalPeriodicTrigger({
    required this.period,
    this.resumeCondition,
    this.pauseCondition,
  }) : super();

  Function get fromJsonFunction => _$ConditionalPeriodicTriggerFromJson;
  factory ConditionalPeriodicTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as ConditionalPeriodicTrigger;
  Map<String, dynamic> toJson() => _$ConditionalPeriodicTriggerToJson(this);
}

/// A trigger that triggers a random number of times within a defined
/// period of time in a day.
///
/// The random value is between the [minNumberOfTriggers] and [maxNumberOfTriggers]
/// numbers specified.
/// The time period is defined by a [startTime] and an [endTime].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class RandomRecurrentTrigger extends Trigger {
  /// Start time of the day where the trigger can happen.
  Time startTime;

  /// End time of the day where the trigger can happen.
  Time endTime;

  /// Minimum number of trigger per day.
  int minNumberOfTriggers;

  /// Maximum number of trigger per day.
  int maxNumberOfTriggers;

  /// The duration (until paused) of the the sampling.
  Duration duration;

  /// Create a [RandomRecurrentTrigger].
  ///
  /// [minNumberOfTriggers] and [maxNumberOfTriggers] specified the range of
  /// the random samples (e.g., between 3 and 8 times pr. day).
  /// [startTime] and [endTime] specified the period within a day the sampling
  /// should take place (e.g., between 08:00 and 20:00).
  RandomRecurrentTrigger({
    this.minNumberOfTriggers = 0,
    this.maxNumberOfTriggers = 1,
    required this.startTime,
    required this.endTime,
    this.duration = const Duration(seconds: 2),
  }) : super() {
    assert(startTime.isBefore(endTime),
        'startTime must be before endTime with a 24 hour period.');
  }

  Function get fromJsonFunction => _$RandomRecurrentTriggerFromJson;
  factory RandomRecurrentTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as RandomRecurrentTrigger;
  Map<String, dynamic> toJson() => _$RandomRecurrentTriggerToJson(this);
}
