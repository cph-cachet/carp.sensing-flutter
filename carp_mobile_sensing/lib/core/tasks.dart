/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of core;

/// A [Task] holds information about each task to be executed as part of a [Study].
/// Each [Task] holds a list of [Measure]s to be done as part of this task.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Task extends Serializable {
  /// The name of this task. Unique for this [Study].
  String name;

  /// A list of [Measure]s to be done as part of this task.
  List<Measure> measures = new List<Measure>();

  Task(this.name) : super();

  static Function get fromJsonFunction => _$TaskFromJson;
  factory Task.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  /// Add a [Measure] to this task.
  void addMeasure(Measure measure) {
    this.measures.add(measure);
  }

  /// Remove a [Measure] from this task.
  void removeMeasure(Measure measure) {
    this.measures.remove(measure);
  }

  String toString() => name;
}

/// A [Task] which runs all [Measure]s in parallel.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ParallelTask extends Task {
  ParallelTask(String name) : super(name);

  static Function get fromJsonFunction => _$ParallelTaskFromJson;
  factory ParallelTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ParallelTaskToJson(this);
}

/// A [Task] which takes all its [Measure]s in sequence.
///
/// Note, however, that not all measures necessarily ends. A [ListeningProbeMeasure] will listens
/// for events until stopped manually. In a [SequentialTask], a measure is only started when the
/// previous measure has ended.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SequentialTask extends Task {
  SequentialTask(String name) : super(name);

  static Function get fromJsonFunction => _$SequentialTaskFromJson;
  factory SequentialTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$SequentialTaskToJson(this);
}
