/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// Any condition on a device ([DeviceDescriptor]) which starts or stops [TaskDescriptor]s
/// at certain points in time when the condition applies.
/// The condition can either be time-bound, based on data streams,
/// initiated by a user of the platform, or a combination of these.
///
/// The [Trigger] class is abstract. Use sub-classes of [CAMSTrigger] implements
/// the specific behavior / timing of a trigger.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class Trigger extends carp_core_domain.Serializable
    with carp_core_domain.Trigger {
  Trigger() : super();

  Function get fromJsonFunction => _$TriggerFromJson;
  factory Trigger.fromJson(Map<String, dynamic> json) => FromJsonFactory()
      .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$TriggerToJson(this);
}
