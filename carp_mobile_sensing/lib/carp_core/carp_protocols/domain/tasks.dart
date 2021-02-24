/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_domain;

/// A [Task] holds information about each task to be triggered by a [Trigger] as part of a [StudyProtocol].
/// Each [Task] holds a list of [Measure]s to be done as part of this task.
/// A [Task] is hence merely an aggregation of [Measure]s.
///
/// The [Task] class is abstract. Use either [AutomaticTask] or [AppTask] for specific tasks.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Task extends Serializable {
  static int _counter = 0;

  /// The name of this task. Unique for this [StudyProtocol].
  String name;

  /// A list of [Measure]s to be done as part of this task.
  List<Measure> measures = [];

  Task({this.name}) : super() {
    name ??= 'Task #${_counter++}';
  }

  Function get fromJsonFunction => _$TaskFromJson;
  factory Task.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  /// Add a [Measure] to this task.
  void addMeasure(Measure measure) {
    measures.add(measure);
  }

  /// Add a list of [Measure]s to this task.
  void addMeasures(Iterable<Measure> list) {
    measures.addAll(list);
  }

  /// Remove a [Measure] from this task.
  void removeMeasure(Measure measure) {
    measures.remove(measure);
  }

  String toString() => '$runtimeType: name: $name';
}

/// A [Task] that automatically collects data from the specified measures.
/// Runs without any interaction with the user or UI of the app.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AutomaticTask extends Task {
  AutomaticTask({String name}) : super(name: name);

  Function get fromJsonFunction => _$AutomaticTaskFromJson;
  factory AutomaticTask.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$AutomaticTaskToJson(this);
}
