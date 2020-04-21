/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A [Task] holds information about each task to be triggered by a [Trigger] as part of a [Study].
/// Each [Task] holds a list of [Measure]s to be done as part of this task.
/// A [Task] is hence merely an aggregation of [Measure]s.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Task extends Serializable {
  static int _counter = 0;

  /// The name of this task. Unique for this [Study].
  String name;

  /// A list of [Measure]s to be done as part of this task.
  List<Measure> measures = new List<Measure>();

  Task({this.name}) : super() {
    name ??= 'Task #${_counter++}';
  }

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

  String toString() => '${this.runtimeType}: name: $name';
}

/// A [Task] that automatically collects data from the specified measures.
/// Runs without any interaction with the user or UI of the app.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AutomaticTask extends Task {
  AutomaticTask({String name}) : super(name: name);

  static Function get fromJsonFunction => _$SensingTaskFromJson;
  factory AutomaticTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$SensingTaskToJson(this);
}

/// A [Task] that notifies the app when it is triggered.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AppTask extends Task {
  AppTask({
    String name,
    this.description,
    this.instructions,
    this.minutesToComplete,
    this.notification = false,
    this.onInitialize,
    this.onResume,
    this.onPause,
    this.onStop,
  }) : super(name: name);

  /// A short description (one line) of this task. Can be used in the app.
  String description;

  /// A longer instruction text explaining how a user should perform this task.
  String instructions;

  /// How many minutes will it take for the user to perform this task?
  int minutesToComplete;

  /// Should a notification be send to the user on the phone?
  bool notification = false;

  /// The callback function providing the [TaskExecutor] object to be used in the app.
  /// This function is called when this task is initialized.
  ///
  /// This callback function needs to be provided by the app on runtime. I.e. this part of the task
  /// cannot be specified in the JSON format of the measure as e.g. downloaded from a study manager.
  @JsonKey(ignore: true)
  void Function(TaskExecutor) onInitialize;

  /// The callback function providing a [TaskExecutor] object to be used in the app.
  /// This function is called when this task is resumed.
  ///
  /// This callback function needs to be provided by the app on runtime. I.e. this part of the task
  /// cannot be specified in the JSON format of the measure as e.g. downloaded from a study manager.
  @JsonKey(ignore: true)
  void Function(TaskExecutor) onResume;

  /// The callback function providing a [TaskExecutor] object to be used in the app.
  /// This function is called when this task is paused.
  ///
  /// This callback function needs to be provided by the app on runtime. I.e. this part of the task
  /// cannot be specified in the JSON format of the measure as e.g. downloaded from a study manager.
  @JsonKey(ignore: true)
  void Function(TaskExecutor) onPause;

  /// The callback function providing a [TaskExecutor] object to be used in the app.
  /// This function is called when this task is stopped.
  ///
  /// This callback function needs to be provided by the app on runtime. I.e. this part of the task
  /// cannot be specified in the JSON format of the measure as e.g. downloaded from a study manager.
  @JsonKey(ignore: true)
  void Function(TaskExecutor) onStop;

  static Function get fromJsonFunction => _$UserTaskFromJson;
  factory AppTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$UserTaskToJson(this);
}
