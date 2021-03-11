/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core;

/// Any condition on a device ([DeviceDescriptor]) which starts or stops
/// [TaskDescriptor]s at certain points in time when the condition applies.
/// The condition can either be time-bound, based on data streams,
/// initiated by a user of the platform, or a combination of these.
///
/// The [Trigger] class is abstract. Use sub-classes of [CAMSTrigger] implements
/// the specific behavior / timing of a trigger.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class Trigger extends Serializable {
  String _triggerNamespace = 'dk.cachet.carp.protocols.domain.triggers';

  /// The device role name from which the trigger originates.
  String sourceDeviceRoleName;

  /// Determines whether the trigger needs to be evaluated on a master
  /// device ([MasterDeviceDescriptor]).
  /// For example, this is the case when the trigger is time bound and needs
  /// to be evaluated by a task scheduler running on a master device.
  bool requiresMasterDevice;

  Trigger() : super();

  Function get fromJsonFunction => _$TriggerFromJson;
  factory Trigger.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TriggerToJson(this);
  String get jsonType => '$_triggerNamespace.$runtimeType';
}

/// A trigger which starts a task after a specified amount of time has elapsed
/// since the start of a study deployment.
/// The start of a study deployment is determined by the first successful
/// deployment of all participating devices.
/// This trigger needs to be evaluated on a master device since it is time
/// bound and therefore requires a task scheduler.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ElapsedTimeTrigger extends Trigger {
  Duration elapsedTime;

  ElapsedTimeTrigger({this.elapsedTime}) : super();

  Function get fromJsonFunction => _$ElapsedTimeTriggerFromJson;
  factory ElapsedTimeTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ElapsedTimeTriggerToJson(this);
}

/// A trigger initiated by a user, i.e., the user decides when to start a task.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ManualTrigger extends Trigger {
  /// A short label to describe the action performed once the user chooses
  /// to initiate this trigger.
  String label;

  /// An optional description elaborating on what happens when initiating
  /// this trigger.
  String description;

  ManualTrigger({this.label, this.description}) : super();

  Function get fromJsonFunction => _$ManualTriggerFromJson;
  factory ManualTrigger.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ManualTriggerToJson(this);
}

/// A trigger which starts a task according to a recurring schedule starting on
/// the date that the study starts.
///
/// The iCalendar RFC 5545 standard is used to specify the recurrence
/// rule: https://tools.ietf.org/html/rfc5545#section-3.3.10
///
/// This trigger needs to be evaluated on a master device since it is time bound
/// and therefore requires a task scheduler.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ScheduledTrigger extends Trigger {
  TimeOfDay time;
  RecurrenceRule recurrenceRule;

  ScheduledTrigger({this.time, this.recurrenceRule}) : super();

  Function get fromJsonFunction => _$ScheduledTriggerFromJson;
  factory ScheduledTrigger.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ScheduledTriggerToJson(this);
}

/// A time on a day. Used in a [ScheduledTrigger].
///
/// Follows the conventions in the [DartTime] class, but only uses the Time
/// part in a 24 hour time format.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TimeOfDay {
  /// 24 hour format.
  int hour;
  int minute;
  int second;

  TimeOfDay({this.hour = 0, this.minute = 0, this.second = 0}) : super();

  static String _twoDigits(int n) => (n >= 10) ? '$n' : '0$n';

  factory TimeOfDay.fromJson(Map<String, dynamic> json) =>
      _$TimeOfDayFromJson(json);
  Map<String, dynamic> toJson() => _$TimeOfDayToJson(this);

  /// Output as ISO 8601 extended time format with seconds accuracy, omitting
  /// the 24th hour and 60th leap second. E.g., "09:30:00".
  String toString() =>
      '${_twoDigits(hour)}:${_twoDigits(minute)}:${_twoDigits(second)}';
}

/// Represents the iCalendar RFC 5545 standard recurrence rule to specify
/// repeating events: https://tools.ietf.org/html/rfc5545#section-3.3.10
///
/// However, since date times are relative to the start time of a study,
/// they are replaced with time spans representing elapsed time since the start of the study.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class RecurrenceRule {
  /// Specifies the type of interval at which to repeat events, or multiples thereof.
  Frequency frequency;

  /// The interval at which [frequency] repeats.
  /// The default is 1. For example, with [Frequency.DAILY], a value
  /// of "8" means every eight days.
  int interval = 1;

  /// Specifies when, if ever, to stop repeating events.
  /// Default recurrence is forever.
  End end = End.never();

  RecurrenceRule(this.frequency, {this.interval = 1, this.end}) : super();

  /// Initialize a [RecurrenceRule] based on a [rrule] string.
  factory RecurrenceRule.fromString(String rrule) {
    // TODO: implement RecurrenceRule.fromString
    throw UnimplementedError();
  }

  /// A valid RFC 5545 string representation of this recurrence rule, except
  /// when [end] is specified as [End.Until].
  /// When [End.Until] is specified, 'UNTIL' holds the total number of microseconds
  /// which need to be added to a desired start date.
  /// 'UNTIL' should be reassigned to a calculated end date time, formatted using
  /// the RFC 5545 specifications: https://tools.ietf.org/html/rfc5545#section-3.3.5
  String toString() {
    String rule = "RRULE:FREQ=$frequency";
    rule += (interval != 1) ? ";INTERVAL=$interval" : "";
    rule += (end.type != EndType.NEVER) ? rule += ";$end" : "";

    return rule;
  }

  factory RecurrenceRule.fromJson(Map<String, dynamic> json) =>
      _$RecurrenceRuleFromJson(json);
  Map<String, dynamic> toJson() => _$RecurrenceRuleToJson(this);
}

/// Specify repeating events based on an interval of a chosen type or multiples thereof.
enum Frequency { SECONDLY, MINUTELY, HOURLY, DAILY, WEEKLY, MONTHLY, YEARLY }

enum EndType { UNTIL, COUNT, NEVER }

@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class End {
  final EndType type;
  final Duration elapsedTime;
  final int count;

  End(this.type, {this.elapsedTime, this.count}) : super();

  /// Bounds the recurrence rule in an inclusive manner to the associated
  /// start date of this rule plus [elapsedTime].
  factory End.until(Duration elapsedTime) =>
      End(EndType.UNTIL, elapsedTime: elapsedTime);

  /// Specify a number of occurrences at which to range-bound the recurrence.
  /// The start date time always counts as the first occurrence.
  factory End.count(int count) => End(EndType.COUNT, count: count);

  /// The recurrence repeats forever.
  factory End.never() => End(EndType.NEVER);

  factory End.fromJson(Map<String, dynamic> json) => _$EndFromJson(json);
  Map<String, dynamic> toJson() => _$EndToJson(this);
}
