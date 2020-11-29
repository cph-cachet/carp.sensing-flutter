/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A [Task] that notifies the app when it is triggered.
///
/// See [AppTaskExecutor] on how this work on runtime.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AppTask extends Task {
  AppTask({
    String name,
    this.type,
    this.title,
    this.description,
    this.instructions,
    this.minutesToComplete,
    this.notification = false,
  }) : super(name: name);

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
  int minutesToComplete;

  // TODO - implement this ;-)
  /// Should a notification be send to the user on the phone?
  bool notification = false;

  static Function get fromJsonFunction => _$AppTaskFromJson;
  factory AppTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(
          json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$AppTaskToJson(this);
}
