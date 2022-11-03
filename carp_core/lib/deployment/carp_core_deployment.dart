/// Maps the information specified in a study protocol to runtime configurations
/// used by the 'clients' subystem to run the protocol on concrete devices
/// (e.g., a smartphone) and allow researchers to monitor their state.
/// To start collecting data, participants need to be invited, devices need to
/// be registered, and consent needs to be given to collect the requested data.
///
///
/// Contains the core deployment classes like [PrimaryDeviceDeployment], [StudyDeployment],
/// [ParticipantData], and [DeploymentService].
///
/// See the [`carp.deployments`](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-deployments.md)
/// definition in Kotlin.
library carp_core_deployment;

import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';
// import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'package:carp_serializable/carp_serializable.dart';

import '../protocols/carp_core_protocols.dart';
import '../common/carp_core_common.dart';

export 'carp_core_deployment.dart';

part 'application/deployment_service.dart';
part 'application/participation_service.dart';
part 'domain/device_deployment.dart';
part 'domain/study_deployment.dart';
part 'domain/participation.dart';
part 'domain/users.dart';
part 'domain/data_endpoint.dart';
part 'infrastructure/deployment_request.dart';
part 'infrastructure/participation_request.dart';

part 'carp_core_deployment.g.dart';
