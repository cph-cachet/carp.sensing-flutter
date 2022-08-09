part of carp_core;

bool _fromJsonFunctionsRegistrered = false;

// Register all the fromJson functions for the domain classes.
void _registerFromJsonFunctions() {
  if (_fromJsonFunctionsRegistrered) return;

  // DEPLOYMENT
  final DeviceDescriptor device = DeviceDescriptor(roleName: '');

  FromJsonFactory().register(DeviceRegistration());
  FromJsonFactory().register(DeviceRegistration(),
      type:
          'dk.cachet.carp.protocols.domain.devices.DefaultDeviceRegistration');

  FromJsonFactory().register(DeviceDeploymentStatus(device: device));
  FromJsonFactory().register(
    DeviceDeploymentStatus(device: device),
    type:
        'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Unregistered',
  );
  FromJsonFactory().register(
    DeviceDeploymentStatus(device: device),
    type: 'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Registered',
  );
  FromJsonFactory().register(
    DeviceDeploymentStatus(device: device),
    type: 'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Deployed',
  );
  FromJsonFactory().register(DeviceDeploymentStatus(device: device),
      type:
          'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.NeedsRedeployment');

  // StudyDeploymentStatus
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''));
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''),
      type: 'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Invited');
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''),
      type:
          'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeployingDevices');
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''),
      type:
          'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeploymentReady');
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''),
      type: 'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Stopped');

  // PROTOCOL
  // register(StudyProtocol());
  FromJsonFactory().register(Trigger());
  FromJsonFactory().register(ElapsedTimeTrigger(elapsedTime: const Duration()));
  FromJsonFactory().register(ManualTrigger());
  FromJsonFactory().register(ScheduledTrigger(
      recurrenceRule: RecurrenceRule(Frequency.DAILY),
      sourceDeviceRoleName: 'ignored',
      time: const TimeOfDay()));

  FromJsonFactory().register(TaskDescriptor());
  FromJsonFactory().register(BackgroundTask());
  FromJsonFactory().register(CustomProtocolTask(studyProtocol: 'ignored'));
  FromJsonFactory().register(Measure(type: 'ignored'));
  final config = SamplingConfiguration();
  FromJsonFactory().register(config);
  FromJsonFactory().register(BatteryAwareSamplingConfiguration(
      critical: config, low: config, normal: config));
  FromJsonFactory()
      .register(GranularitySamplingConfiguration(Granularity.Balanced));

  FromJsonFactory().register(DeviceDescriptor(roleName: ''));
  FromJsonFactory().register(DeviceConnection());
  FromJsonFactory().register(MasterDeviceDescriptor(roleName: ''));
  FromJsonFactory().register(CustomProtocolDevice());
  FromJsonFactory().register(Smartphone());
  FromJsonFactory().register(AltBeacon());
  FromJsonFactory().register(DeviceDescriptor(roleName: ''),
      type:
          'dk.cachet.carp.protocols.infrastructure.test.StubMasterDeviceDescriptor');
  FromJsonFactory().register(DeviceDescriptor(roleName: ''),
      type:
          'dk.cachet.carp.protocols.infrastructure.test.StubDeviceDescriptor');

  _fromJsonFunctionsRegistrered = true;
}
