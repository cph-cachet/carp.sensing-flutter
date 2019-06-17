/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A [Trigger] is a specification of any condition which starts or stops [Task]s at
/// certain points in time when the condition applies. The condition can either
/// be time-bound, based on data streams, initiated by a user of the platform,
/// or a combination of these.
/// Sub-classes of [Trigger] implements the specific behavior / timing of a trigger.
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

/// A trigger that starts sampling immediately.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ImmediateTrigger extends Trigger {
  ImmediateTrigger() : super();

  static Function get fromJsonFunction => _$ImmediateTriggerFromJson;
  factory ImmediateTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ImmediateTriggerToJson(this);
}

/// A trigger that delays sampling for [delay] milliseconds and then starts sampling.
///
/// The delay is measured from the start of the overall [Study].
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class DelayedTrigger extends Trigger {
  /// Delay in milliseconds.
  int delay = 0;

  DelayedTrigger([this.delay]) : super();

  static Function get fromJsonFunction => _$DelayedTriggerFromJson;
  factory DelayedTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DelayedTriggerToJson(this);
}

/// A trigger that resume/pause sampling every [period] milliseconds.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PeriodicTrigger extends Trigger {
  /// The period (reciprocal of frequency) of sampling in milliseconds.
  int period = 0;

  PeriodicTrigger([this.period]) : super();

  static Function get fromJsonFunction => _$PeriodicTriggerFromJson;
  factory PeriodicTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PeriodicTriggerToJson(this);
}

/// A trigger that starts sampling based on a scheduled date and time.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ScheduledTrigger extends Trigger {
  /// Delay in milliseconds.
  DateTime schedule;

  ScheduledTrigger([this.schedule]) : super();

  static Function get fromJsonFunction => _$ScheduledTriggerFromJson;
  factory ScheduledTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ScheduledTriggerToJson(this);
}

enum RecurrentType { daily, weekly, monthly, yearly }

/// A trigger that resume/pause sampling based on a recurrent scheduled date and time.
///
/// Supports daily, weekly, monthly and yearly recurrences.
/// TODO - provide examples.
///
/// Thanks to Shantanu Kher for inspiration in his blog post on
/// [Again and Again! Managing Recurring Events In a Data Model](https://www.vertabelo.com/blog/technical-articles/again-and-again-managing-recurring-events-in-a-data-model).
///
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RecurrentScheduledTrigger extends Trigger {
  /// The type of recurrence - daily, weekly, monthly, yearly
  RecurrentType type;

  /// Start time and date. If [null], the trigger starts immediately.
  DateTime start;

  /// End time and date. If [null], this trigger runs forever.
  DateTime end;

  /// Separation between recurrences.
  ///
  /// This value signifies the interval (in days, weeks, or months) before the next
  /// event instance is allowed. For example, if an event needs to be configured
  /// for every other week, then [separationCount] is `1` to meet this requirement.
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
  /// i.e. having Monday as the first day of the week and Sunday is the last.
  int dayOfWeek;

  /// If monthly recurrence, specify the week in the month.
  ///
  /// [weekOfMonth] is used for samplings that are scheduled for a certain week of the month – i.e.
  /// the first, second, etc. Possible values are 1,2,3,4, counting from the beginning of the month.
  int weekOfMonth;

  /// If monthly recurrence, specify the day of the month.
  ///
  /// Used in cases when an event is scheduled on a particular day of the month, say the 25th.
  /// Possible numbers are 1..31 counting from the start of a month.
  int dayOfMonth;

  /// If yearly recurrence, specify the month of the year.
  ///
  /// In combination with [dayOfWeek] and [weekOfMonth],  this value specify the month of year.
  /// Follows the [DateTime] standards, i.e. possible values are 1..12 counting from the start of a year.
  int monthOfYear;

  RecurrentScheduledTrigger([this.type]) : super();

  static Function get fromJsonFunction => _$RecurrentScheduledTriggerFromJson;
  factory RecurrentScheduledTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$RecurrentScheduledTriggerToJson(this);
}

/// Takes a [Datum] from a sampling stream and evaluates if an event has occurred.
/// Returns [true] if the event has occurred, [false] otherwise.
//@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
typedef EventConditionEvaluator = bool Function(Datum datum);

/// A trigger that resume sampling when some sampling event occurs.
///
/// For example, if [measureType] is `carp.geofence` the [condition] can be `{'DTU','ENTER'}`
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SamplingEventTrigger extends Trigger {
  SamplingEventTrigger([this.measureType, this.condition]) : super();

  /// The [MeasureType] of the event to look for.
  MeasureType measureType;

  /// The [EventConditionEvaluator] function evaluating if the event condition is meet.
  //EventConditionEvaluator condition;

  /// The [EventConditionEvaluator] function evaluating if the event condition is meet.
  Datum condition;

  static Function get fromJsonFunction => _$SamplingEventTriggerFromJson;
  factory SamplingEventTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$SamplingEventTriggerToJson(this);
}
