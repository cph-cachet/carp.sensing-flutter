/*
 * Copyright 2020-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A task that notifies the app when it is triggered.
///
/// See [AppTaskExecutor] on how this work on runtime.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AppTask extends TaskDescriptor {
  /// Type of task. For example a `survey`.
  String type;

  /// A title for this task. Can be used in the app.
  String title;

  /// A short description (one line) of this task. Can be used in the app.
  String description;

  /// A longer instruction text explaining how a user should perform this task.
  String instructions;

  /// How many minutes will it take for the user to perform this task?
  /// Typically shown to the user before engaging into this task.
  /// If `null` the task has no completion time.
  int? minutesToComplete;

  /// The duration of this app task, i.e. when it expire and is removed
  /// from the [AppTaskController]'s queue.
  /// If `null` the task never expire.
  Duration? expire;

  /// Should a notification be send to the user on the phone?
  bool notification;

  /// The list of background [measures] as a [BackgroundTask].
  BackgroundTask get backgroundTask =>
      BackgroundTask(name: name, measures: measures);

  /// Create an app task that notifies the app when it is triggered.
  ///
  /// [name] is a unique name of the task.
  /// [measures] is the list of measures to be collected in the background when
  /// this app task is resumed.
  AppTask({
    super.name,
    super.measures,
    required this.type,
    this.title = '',
    this.description = '',
    this.instructions = '',
    this.minutesToComplete,
    this.expire,
    this.notification = false,
  });

  @override
  Function get fromJsonFunction => _$AppTaskFromJson;

  factory AppTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AppTask;

  @override
  Map<String, dynamic> toJson() => _$AppTaskToJson(this);
}

/// Signature of Dart function that have no arguments and return no data.
typedef VoidFunction = void Function();

/// A task that can run a custom Dart function.
///
/// Note that the [function] to be executed is specified as a Dart function,
/// which cannot be serialized to/from JSON.
/// Thus, even though this trigger can be de/serialized from/to JSON, its
/// [function] cannot.
/// This implies that this function cannot be retrieved as part of a [StudyProtocol]
/// from a [DeploymentService] since it relies on specifying a Dart-specific function.
/// Hence, this trigger is mostly useful when creating a [StudyProtocol] directly
/// in the app using Dart code.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class FunctionTask extends TaskDescriptor {
  /// The function to execute when this task is resumed.
  @JsonKey(includeFromJson: false, includeToJson: false)
  VoidFunction? function;

  /// Create a function task that executed [function] when resumed.
  FunctionTask({
    super.name,
    this.function,
  });

  @override
  Function get fromJsonFunction => _$FunctionTaskFromJson;

  factory FunctionTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as FunctionTask;

  @override
  Map<String, dynamic> toJson() => _$FunctionTaskToJson(this);
}
