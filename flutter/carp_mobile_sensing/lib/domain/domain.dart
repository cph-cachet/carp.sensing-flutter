/// The core domain classes like [Study], [Task], and [Measure].
/// Also hold JSON serialization logic to serialize [Datum] objects
/// into a [CARPDataPoint] as well as deseralization of [Study] objects
/// obtained from a [StudyManager].
library domain;

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'serialization.dart';
part 'study.dart';
part 'tasks.dart';
part 'carp_datapoint.dart';
part 'datum.dart';
part 'measures.dart';
part 'domain.g.dart';
