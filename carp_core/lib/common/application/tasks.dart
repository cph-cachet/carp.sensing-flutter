/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_common;

/// Describes requested measures and/or output to be presented on a device.
///
/// A [TaskConfiguration] holds information about each task to be triggered by
/// a [TriggerConfiguration] as part of a [StudyProtocol].
/// Each task holds a list of [Measure]s to be done as part of this task.
/// A [TaskConfiguration] is hence an aggregation of [Measure]s.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TaskConfiguration extends Serializable {
  static int _counter = 0;

  /// A name which uniquely identifies the task.
  late String name;

  /// A description of this task, emphasizing the reason why the data is collected.
  String? description;

  /// The data which needs to be collected/measured passively as part of this task.
  List<Measure>? measures = [];

  /// Add [measure] to this task.
  void addMeasure(Measure measure) => measures!.add(measure);

  /// Add a [list] of measures to this task.
  void addMeasures(Iterable<Measure> list) => measures!.addAll(list);

  /// Remove [measure] from this task.
  void removeMeasure(Measure measure) => measures!.remove(measure);

  /// Create a task. If [name] is not specified, a name is generated.
  @mustCallSuper
  TaskConfiguration({
    String? name,
    List<Measure>? measures,
  }) : super() {
    this.name = name ?? 'Task #${_counter++}';
    this.measures = measures ?? [];
  }

  @override
  Function get fromJsonFunction => _$TaskConfigurationFromJson;
  factory TaskConfiguration.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as TaskConfiguration;
  @override
  Map<String, dynamic> toJson() => _$TaskConfigurationToJson(this);
  @override
  String get jsonType => 'dk.cachet.carp.common.application.tasks.$runtimeType';

  @override
  String toString() =>
      '$runtimeType - name: $name, measures size: ${measures?.length}';
}

/// A task which specifies that all containing measures and/or
/// outputs should immediately start running in the background once triggered.
/// The task runs for the specified [duration], or until stopped, or until
/// all measures and/or outputs have completed.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class BackgroundTask extends TaskConfiguration {
  /// The optional duration over the course of which the [measures] need to
  /// be sampled. `null` implies infinite by default.
  Duration? duration;

  /// Create a new task which can run in the background.
  BackgroundTask({
    super.name,
    super.measures,
    this.duration,
  });

  @override
  Function get fromJsonFunction => _$BackgroundTaskFromJson;
  factory BackgroundTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as BackgroundTask;
  @override
  Map<String, dynamic> toJson() => _$BackgroundTaskToJson(this);
}

/// A task which contains a definition of a custom protocol which differs from
/// the CARP domain model.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CustomProtocolTask extends TaskConfiguration {
  /// A definition on how to run a study on a master device, serialized as a string.
  String studyProtocol;

  /// Create a task which is used in a custon protocol, specified as a
  /// string in [studyProtocol].
  CustomProtocolTask({
    super.name,
    required this.studyProtocol,
    // The measures list is empty, since measures are defined in [studyProtocol]
    // in a different format.
  }) : super(measures: []);

  @override
  Function get fromJsonFunction => _$CustomProtocolTaskFromJson;
  factory CustomProtocolTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as CustomProtocolTask;
  @override
  Map<String, dynamic> toJson() => _$CustomProtocolTaskToJson(this);

  @override
  String toString() => '${super.toString()}, studyProtocol: $studyProtocol';
}
