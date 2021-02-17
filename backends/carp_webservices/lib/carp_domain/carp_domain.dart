/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
library carp_domain;

//import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:json_annotation/json_annotation.dart';

part 'carp_domain.g.dart';
part 'deployment_request.dart';
part 'deployment_domain.dart';

/// Register all the fromJson functions for the deployment domain classes.
void registerFromJsonFunctions() {
  info('Register all the fromJson function for the deployment domain classes.');
  FromJsonFactory().register(GetStudyDeploymentStatus('ignored'),
      type:
          'dk.cachet.carp.deployment.infrastructure.DeploymentServiceRequest.GetStudyDeploymentStatus');
  FromJsonFactory().register(StudyDeploymentStatus('ignored'),
      type: 'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Invited');
  FromJsonFactory().register(StudyDeploymentStatus('ignored'),
      type:
          'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeployingDevices');
  FromJsonFactory().register(StudyDeploymentStatus('ignored'),
      type:
          'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeploymentReady');
  FromJsonFactory().register(StudyDeploymentStatus('ignored'),
      type: 'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Stopped');

  FromJsonFactory().register(
    DeviceDeploymentStatus(),
    type:
        'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Unregistered',
  );
  FromJsonFactory().register(
    DeviceDeploymentStatus(),
    type: 'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Registered',
  );
  FromJsonFactory().register(
    DeviceDeploymentStatus(),
    type: 'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Deployed',
  );
  FromJsonFactory().register(DeviceDeploymentStatus(),
      type:
          'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.NeedsRedeployment');

  // different types of device descriptors
  FromJsonFactory().register(DeviceDescriptor(),
      type: 'dk.cachet.carp.protocols.domain.devices.Smartphone');
  FromJsonFactory().register(DeviceDescriptor(),
      type:
          'dk.cachet.carp.protocols.infrastructure.test.StubMasterDeviceDescriptor');
  FromJsonFactory().register(DeviceDescriptor(),
      type:
          'dk.cachet.carp.protocols.infrastructure.test.StubDeviceDescriptor');
  //  FromJsonFactory().register(MasterDeviceDeployment(),
  //      type: 'dk.cachet.carp.protocols.domain.MasterDeviceDeployment');
  FromJsonFactory().register(DeviceRegistration(),
      type: 'dk.cachet.carp.protocols.domain.devices.DeviceRegistration');
  FromJsonFactory().register(DeviceRegistration(),
      type:
          'dk.cachet.carp.protocols.domain.devices.DefaultDeviceRegistration');
  FromJsonFactory().register(TaskDescriptor(),
      type: 'dk.cachet.carp.protocols.domain.tasks.TaskDescriptor');
  FromJsonFactory().register(TaskDescriptor(),
      type: 'dk.cachet.carp.protocols.domain.tasks.ConcurrentTask');
  FromJsonFactory().register(CustomProtocolTask(),
      type: 'dk.cachet.carp.protocols.domain.tasks.CustomProtocolTask');

  FromJsonFactory().register(DataTypeMeasure(),
      type: 'dk.cachet.carp.protocols.domain.tasks.measures.DataTypeMeasure');
  FromJsonFactory().register(PhoneSensorMeasure(),
      type:
          'dk.cachet.carp.protocols.domain.tasks.measures.PhoneSensorMeasure');
  FromJsonFactory().register(TriggerDescriptor(),
      type: 'dk.cachet.carp.protocols.domain.triggers.TriggerDescriptor');
  // FromJsonFactory().register(TriggeredTask(),
  //     type: 'dk.cachet.carp.protocols.domain.triggers.TriggeredTask', );
  // FromJsonFactory().register(Measure(),
  //     type: 'dk.cachet.carp.protocols.domain.tasks.measures.Measure', );
  // FromJsonFactory().register(Measure(),
  //     type: 'dk.cachet.carp.protocols.domain.tasks.measures.PhoneSensorMeasure', );

  // FromJsonFactory().register(type: 'dk.cachet.carp.deployment.domain.users.ActiveParticipationInvitation',
  //     ActiveParticipationInvitation());
  // FromJsonFactory().register(DeviceInvitation(),
  //     type:
  //         'dk.cachet.carp.deployment.domain.users.ActiveParticipationInvitation.DeviceInvitation');
  // FromJsonFactory().register(Participation(),
  //     type: 'dk.cachet.carp.deployment.domain.users.Participation');
  // FromJsonFactory().register(StudyInvitation(),
  //     type: 'dk.cachet.carp.deployment.domain.users.StudyInvitation');
}
