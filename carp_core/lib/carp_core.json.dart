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
        'dk.cachet.carp.deployments.application.DeviceDeploymentStatus.Unregistered',
  );
  FromJsonFactory().register(
    DeviceDeploymentStatus(device: device),
    type:
        'dk.cachet.carp.deployments.application.DeviceDeploymentStatus.Registered',
  );
  FromJsonFactory().register(
    DeviceDeploymentStatus(device: device),
    type:
        'dk.cachet.carp.deployments.application.DeviceDeploymentStatus.Deployed',
  );
  FromJsonFactory().register(DeviceDeploymentStatus(device: device),
      type:
          'dk.cachet.carp.deployments.application.DeviceDeploymentStatus.NeedsRedeployment');

  // StudyDeploymentStatus
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''));
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''),
      type:
          'dk.cachet.carp.deployments.application.StudyDeploymentStatus.Invited');
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''),
      type:
          'dk.cachet.carp.deployments.application.StudyDeploymentStatus.DeployingDevices');
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''),
      type:
          'dk.cachet.carp.deployments.application.StudyDeploymentStatus.DeploymentReady');
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''),
      type:
          'dk.cachet.carp.deployments.application.StudyDeploymentStatus.Running');
  FromJsonFactory().register(StudyDeploymentStatus(studyDeploymentId: ''),
      type:
          'dk.cachet.carp.deployments.application.StudyDeploymentStatus.Stopped');

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
  FromJsonFactory().register(GetActiveParticipationInvitations(''));
  FromJsonFactory().register(GetParticipantData(''));
  FromJsonFactory().register(GetParticipantDataList(['']));
  FromJsonFactory().register(SetParticipantData(''));
  FromJsonFactory().register(GetStudyDeploymentStatus(''));
  FromJsonFactory().register(GetStudyDeploymentStatusList(['']));
  FromJsonFactory().register(RegisterDevice('', '', DeviceRegistration()));
  FromJsonFactory().register(UnregisterDevice('', ''));
  FromJsonFactory().register(GetDeviceDeploymentFor('', ''));
  FromJsonFactory().register(DeviceDeployed('', '', DateTime.now()));
  FromJsonFactory().register(Stop(''));
  FromJsonFactory().register(Add(null, null));
  FromJsonFactory().register(AddVersion(null, null));
  FromJsonFactory()
      .register(UpdateParticipantDataConfiguration('', null, null));
  FromJsonFactory().register(GetBy('', null));
  FromJsonFactory().register(GetAllForOwner(null));
  FromJsonFactory().register(GetVersionHistoryFor(''));
  FromJsonFactory().register(CreateCustomProtocol('', '', '', ''));
  FromJsonFactory().register(OpenDataStreams(DataStreamsConfiguration(
      studyDeploymentId: '', expectedDataStreams: {})));
  FromJsonFactory().register(AppendToDataStreams('', []));
  FromJsonFactory().register(GetDataStream(
      DataStreamId(studyDeploymentId: '', deviceRoleName: '', dataType: ''),
      0));
  FromJsonFactory().register(CloseDataStreams([]));
  FromJsonFactory().register(RemoveDataStreams([]));

  // DATA TYPES
  FromJsonFactory().register(Acceleration());
  FromJsonFactory().register(Geolocation());
  FromJsonFactory().register(SignalStrength());
  FromJsonFactory().register(StepCount());
  FromJsonFactory().register(HeartRate());
  FromJsonFactory().register(ECG());
  FromJsonFactory().register(EDA());
  FromJsonFactory().register(CompletedTask(taskName: ''));
  FromJsonFactory().register(TriggeredTask(
      triggerId: 0,
      taskName: '',
      destinationDeviceRoleName: '',
      control: TaskControl(triggerId: 0)));

  // INPUT DATA TYPES
  FromJsonFactory().register(CustomInput('ignored'),
      type: CustomInput.CUSTOM_INPUT_TYPE_NAME);
  FromJsonFactory().register(SexCustomInput(Sex.Female),
      type: SexCustomInput.SEX_INPUT_TYPE_NAME);

  _fromJsonFunctionsRegistrered = true;
}
