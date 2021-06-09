/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A [TaskDescriptor] that automatically collects data from the specified measures.
/// Runs without any interaction with the user or UI of the app.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class AutomaticTask extends TaskDescriptor {
  AutomaticTask({String? name}) : super(name: name);

  Function get fromJsonFunction => _$AutomaticTaskFromJson;
  factory AutomaticTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as AutomaticTask;
  Map<String, dynamic> toJson() => _$AutomaticTaskToJson(this);
}
