/// Contains common CARP domain classes which are used across the libraries.
library carp_core_common;

import 'package:meta/meta.dart';
import 'package:iso_duration_parser/iso_duration_parser.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:uuid/uuid.dart';

export 'carp_core_common.dart';

part 'infrastructure/service_request.dart';
part 'application/users.dart';
part 'application/measure.dart';
part 'application/tasks.dart';
part 'application/task_control.dart';
part 'application/device_configuration.dart';
part 'application/device_registration.dart';
part 'application/triggers.dart';
part 'application/sampling.dart';
part 'application/data_type.dart';
part 'application/data_types.dart';
part 'application/data.dart';
part 'application/input_data.dart';

part 'carp_core_common.g.dart';

/// An immutable snapshot of a CARP Core domain object.
/// Used as the base class for serializable CARP domain objects.
abstract class Snapshot {
  /// Unique id for this object.
  late String id;

  /// The date when the object represented by this snapshot was created.
  late DateTime createdOn;

  /// The number of edits made to the object represented by this snapshot,
  /// indicating its version number.
  late int version;

  Snapshot([String? id]) {
    this.version = 0;
    this.id = id ?? const Uuid().v1();
    createdOn = DateTime.now().toUtc();
  }
}

/// Deserialization of [isoString] to [IsoDuration] according to the ISO 8061 standard.
IsoDuration? _$IsoDurationFromJson(String? isoString) =>
    (isoString != null) ? IsoDuration.tryParse(isoString) : null;

/// Serialization of [IsoDuration] to a ISO 8061 string.
String? _$IsoDurationToJson(IsoDuration? duration) => duration?.toIso();
