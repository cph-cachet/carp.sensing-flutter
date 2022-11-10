part of carp_core;

bool _fromJsonFunctionsRegistrered = false;

// Register all the fromJson functions for the domain classes.
void _registerFromJsonFunctions() {
  if (_fromJsonFunctionsRegistrered) return;

  // DEPLOYMENT
  final DeviceConfiguration device = DeviceConfiguration(roleName: '');

  FromJsonFactory().register(DeviceRegistration());
  // FromJsonFactory().register(DefaultDeviceRegistration());
  FromJsonFactory().register(DeviceRegistration(),
      type:
          'dk.cachet.carp.common.application.devices.DefaultDeviceRegistration');
  FromJsonFactory().register(AltBeaconDeviceRegistration());

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
  FromJsonFactory().register(TriggerConfiguration());
  FromJsonFactory()
      .register(ElapsedTimeTrigger(elapsedTime: const IsoDuration()));
  FromJsonFactory().register(ManualTrigger());
  FromJsonFactory().register(ScheduledTrigger(
      recurrenceRule: RecurrenceRule(Frequency.DAILY),
      sourceDeviceRoleName: 'ignored',
      time: const TimeOfDay()));

  FromJsonFactory().register(TaskConfiguration());
  FromJsonFactory().register(BackgroundTask());
  FromJsonFactory().register(CustomProtocolTask(studyProtocol: 'ignored'));
  FromJsonFactory().register(Measure(type: 'ignored'));
  final config = SamplingConfiguration();
  FromJsonFactory().register(config);
  FromJsonFactory().register(NoOptionsSamplingConfiguration());
  FromJsonFactory().register(BatteryAwareSamplingConfiguration(
      critical: config, low: config, normal: config));
  FromJsonFactory()
      .register(GranularitySamplingConfiguration(Granularity.Balanced));

  FromJsonFactory().register(DeviceConfiguration(roleName: ''));
  // FromJsonFactory().register(DeviceConnection());
  FromJsonFactory().register(PrimaryDeviceConfiguration(roleName: ''));
  FromJsonFactory().register(CustomProtocolDevice());
  FromJsonFactory().register(Smartphone());
  FromJsonFactory().register(AltBeacon());
  FromJsonFactory().register(DeviceConfiguration(roleName: ''),
      type:
          'dk.cachet.carp.protocols.infrastructure.test.StubMasterDeviceDescriptor');
  FromJsonFactory().register(DeviceConfiguration(roleName: ''),
      type:
          'dk.cachet.carp.protocols.infrastructure.test.StubDeviceDescriptor');
  FromJsonFactory().register(ParticipantAttribute(inputDataType: 'ignored'));
  FromJsonFactory().register(AssignedTo());

  // REQUESTS
  FromJsonFactory().register(GetActiveParticipationInvitations('ignored'));
  FromJsonFactory().register(GetParticipantData('ignored'));
  FromJsonFactory().register(GetParticipantDataList(['ignored']));
  FromJsonFactory().register(SetParticipantData('ignored'));

  FromJsonFactory().register(CustomInput('ignored'),
      type: CustomInput.CUSTOM_INPUT_TYPE_NAME);
  FromJsonFactory().register(SexCustomInput(Sex.Female),
      type: SexCustomInput.SEX_INPUT_TYPE_NAME);

  _fromJsonFunctionsRegistrered = true;
}
