/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A [Task] holds information about each task to be executed as part of a [Study].
/// Each [Task] has a set of [Measure]s to be done as part of this task.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Task extends Serializable {
  /// The name of this task. Unique for this [Study].
  String name;

  Task(this.name) : super() {
    //super.registerFromJson(_$TaskFromJson);
  }

  static Function get fromJsonFunction => _$TaskFromJson;
  factory Task.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json['\$'].toString(), json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);

  /// A list of [Measure]s to be done as part of this task.
  List<Measure> measures = new List<Measure>();

  @override
  String toString() {
    String s = "";
    s += "Task: $name [";
    measures.forEach((m) {
      s += m.toString() + " | ";
    });
    s += "]\n";
    return s;
  }

  void addMeasure(Measure measure) {
    this.measures.add(measure);
  }

  void removeMeasure(Measure measure) {
    this.measures.remove(measure);
  }
}

/// A [Task] which starts immediately and runs all [Measure]s in parallel.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class ParallelTask extends Task {
  ParallelTask(String name) : super(name) {
    //super.registerFromJson(_$ParallelTaskFromJson);
  }

  static Function get fromJsonFunction => _$ParallelTaskFromJson;
  factory ParallelTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json['\$'].toString(), json);
  Map<String, dynamic> toJson() => _$ParallelTaskToJson(this);
}

/// A [Task] which takes all its [Measure]s in sequence.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class SequentialTask extends Task {
  SequentialTask(String name) : super(name) {
    //super.registerFromJson(_$SequentialTaskFromJson);
  }

  static Function get fromJsonFunction => _$SequentialTaskFromJson;
  factory SequentialTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json['\$'].toString(), json);
  //factory SequentialTask.fromJson(Map<String, dynamic> json) => _$SequentialTaskFromJson(json);
  Map<String, dynamic> toJson() => _$SequentialTaskToJson(this);
}
