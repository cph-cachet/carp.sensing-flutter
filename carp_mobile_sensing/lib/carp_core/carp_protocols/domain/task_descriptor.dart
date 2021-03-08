/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core;

/// A [TaskDescriptor] holds information about each task to be triggered by
/// a [Trigger] as part of a [StudyProtocol].
/// Each [TaskDescriptor] holds a list of [Measure]s to be done as part of this task.
/// A [TaskDescriptor] is hence merely an aggregation of [Measure]s.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class TaskDescriptor extends Serializable {
  static int _counter = 0;

  /// The name of this task. Unique for this [StudyProtocol].
  String name;

  /// A list of [Measure]s to be done as part of this task.
  List<Measure> measures = [];

  /// Add a [Measure] to this task.
  void addMeasure(Measure measure) => measures.add(measure);

  /// Add a list of [Measure]s to this task.
  void addMeasures(Iterable<Measure> list) => measures.addAll(list);

  /// Remove a [Measure] from this task.
  void removeMeasure(Measure measure) => measures.remove(measure);

  TaskDescriptor({this.name, this.measures}) : super() {
    this.name = name ?? 'Task #${_counter++}';
    this.measures ??= [];
  }

  Function get fromJsonFunction => _$TaskDescriptorFromJson;
  factory TaskDescriptor.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TaskDescriptorToJson(this);
  String get jsonType => 'dk.cachet.carp.protocols.domain.tasks.TaskDescriptor';

  String toString() =>
      '$runtimeType - name: $name, measures size: ${measures.length}';
}

/// A [TaskDescriptor] which specifies that all containing measures and/or outputs
/// should start immediately once triggered and run indefinitely until all
/// containing measures have completed.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class ConcurrentTask extends TaskDescriptor {
  ConcurrentTask({String name, List<Measure> measures})
      : super(name: name, measures: measures);

  Function get fromJsonFunction => _$ConcurrentTaskFromJson;
  factory ConcurrentTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$ConcurrentTaskToJson(this);
  String get jsonType => 'dk.cachet.carp.protocols.domain.tasks.ConcurrentTask';
}

/// A [TaskDescriptor] which contains a definition on how to run tasks, measures,
/// and triggers which differs from the CARP domain model.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CustomProtocolTask extends TaskDescriptor {
  /// A definition on how to run a study on a master device, serialized as a string.
  String studyProtocol;

  // The measures list is empty, since measures are defined in [studyProtocol]
  // in a different format.
  CustomProtocolTask({String name, this.studyProtocol})
      : super(name: name, measures: []);

  Function get fromJsonFunction => _$CustomProtocolTaskFromJson;
  factory CustomProtocolTask.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory()
          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$CustomProtocolTaskToJson(this);
  String get jsonType =>
      'dk.cachet.carp.protocols.domain.tasks.CustomProtocolTask';

  String toString() => '${super.toString()}, studyProtocol: $studyProtocol';
}
