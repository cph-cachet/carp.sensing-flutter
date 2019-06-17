/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A [Trigger] is a specification of any condition which starts or stops tasks at
/// certain points in time when the condition applies. The condition can either
/// be time-bound, based on data streams, initiated by a user of the platform,
/// or a combination of these.
/// Sub-classes of [Trigger] implements the specific behavior / timing of a trigger.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Trigger extends Serializable {
  /// The list of [Task]s in this [Trigger].
  List<Task> tasks = new List<Task>();

  Trigger() : super();

  static Function get fromJsonFunction => _$TriggerFromJson;
  factory Trigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TriggerToJson(this);

  /// Add a [Task] to this [Trigger]
  void addTask(Task task) => tasks.add(task);
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
  DelayedTrigger([this.delay]) : super();

  /// Delay in milliseconds.
  int delay = 0;

  static Function get fromJsonFunction => _$DelayedTriggerFromJson;
  factory DelayedTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$DelayedTriggerToJson(this);
}

/// A trigger that resume/pause sampling every [period] milliseconds.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class PeriodicTrigger extends Trigger {
  PeriodicTrigger([this.period]) : super();

  /// The period (reciprocal of frequency) of sampling in milliseconds.
  int period = 0;

  static Function get fromJsonFunction => _$PeriodicTriggerFromJson;
  factory PeriodicTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$PeriodicTriggerToJson(this);
}

/// A trigger that starts sampling based on a scheduled date and time.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ScheduledTrigger extends Trigger {
  ScheduledTrigger([this.schedule]) : super();

  /// Delay in milliseconds.
  DateTime schedule;

  static Function get fromJsonFunction => _$ScheduledTriggerFromJson;
  factory ScheduledTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ScheduledTriggerToJson(this);
}

enum RecurrentType { daily, weekly, monthly, yearly }

/// A trigger that resume/pause sampling based on a recurrent scheduled date and time.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RecurrentScheduledTrigger extends Trigger {
  RecurrentScheduledTrigger([this.type]) : super();

  RecurrentType type;
  DateTime start;
  DateTime end;
  int separationCount = 0;
  int maxNumberOfOccurrences;
  int dayOfWeek;
  int weekOfMonth;
  int dayOfMonth;
  int monthOfYear;

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
