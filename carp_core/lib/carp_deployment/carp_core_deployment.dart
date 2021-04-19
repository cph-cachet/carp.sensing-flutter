/// The core deployment classes like [StudyProtocol], [TaskDescriptor], [Measure],
/// and [DataPoint].
library carp_core_deployment;

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

import 'package:carp_core/carp_common/carp_core_common.dart';
import 'package:carp_core/carp_protocols/carp_core_protocols.dart';
import 'package:carp_core/carp_deployment/carp_core_deployment.dart';
import 'package:carp_core/carp_data/carp_core_data.dart';

export 'carp_core_deployment.dart';

part 'domain/device_deployment.dart';
part 'domain/study_deployment.dart';
part 'domain/participation.dart';
part 'domain/users.dart';
part 'infrastructure/deployment_request.dart';
part 'infrastructure/participation_request.dart';
part 'application/deployment_service.dart';
part 'application/participation_service.dart';

part 'carp_core_deployment.g.dart';
