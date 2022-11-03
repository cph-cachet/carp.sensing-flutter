/// Contains common CARP domain classes which are used across the libraries.
library carp_core_common;

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:uuid/uuid.dart';

export 'carp_core_common.dart';

part 'infrastructure/service_request.dart';
part 'application/users.dart';
part 'application/measure.dart';
part 'application/tasks.dart';
part 'application/devices.dart';
part 'application/triggers.dart';
part 'application/sampling.dart';
part 'application/data.dart';

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
  int version = 0;

  Snapshot() {
    id = const Uuid().v1();
    createdOn = DateTime.now().toUtc();
  }
}
