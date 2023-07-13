part of carp_mobile_sensing;

bool _fromJsonFunctionsRegistrered = false;

/// Register all the fromJson functions for the domain classes.
void _registerFromJsonFunctions() {
  if (_fromJsonFunctionsRegistrered) return;

  // Protocol classes
  FromJsonFactory().registerAll([
    StudyResponsible(
      id: '',
      title: '',
      address: '',
      affiliation: '',
      email: '',
      name: '',
    ),
    DataEndPoint(type: ''),
    FileDataEndPoint(),
    SQLiteDataEndPoint(),
    StudyDescription(
      title: '',
      description: '',
      purpose: '',
    )
  ]);

  // Task classes
  FromJsonFactory().registerAll([AppTask(type: ''), FunctionTask()]);

  // Trigger classes
  FromJsonFactory().registerAll([
    NoOpTrigger(),
    ImmediateTrigger(),
    OneTimeTrigger(),
    DelayedTrigger(delay: Duration()),
    PeriodicTrigger(period: Duration()),
    DateTimeTrigger(schedule: DateTime.now()),
    RecurrentScheduledTrigger(
      type: RecurrentType.daily,
      time: TimeOfDay(),
    ),
    SamplingEventTrigger(measureType: ''),
    ConditionalPeriodicTrigger(period: Duration()),
    ConditionalSamplingEventTrigger(measureType: ''),
    CronScheduledTrigger(),
    RandomRecurrentTrigger(
      startTime: TimeOfDay(hour: 1),
      endTime: TimeOfDay(hour: 2),
    ),
    UserTaskTrigger(
      taskName: 'ignored',
      triggerCondition: UserTaskState.done,
    )
  ]);

  // Data classes
  FromJsonFactory().registerAll([
    Heartbeat(period: 1, deviceRoleName: '', deviceType: ''),
    DeviceInformation(),
    BatteryState(),
    FreeMemory(),
    ScreenEvent(),
    Timezone(''),
    AmbientLight()
  ]);

  // Sampling Configuration classes
  FromJsonFactory().registerAll([
    PersistentSamplingConfiguration(),
    HistoricSamplingConfiguration(),
    IntervalSamplingConfiguration(
      interval: Duration.zero,
    ),
    PeriodicSamplingConfiguration(
      interval: Duration.zero,
      duration: Duration.zero,
    ),
    BatteryAwareSamplingConfiguration(
      normal: PersistentSamplingConfiguration(),
      low: PersistentSamplingConfiguration(),
      critical: PersistentSamplingConfiguration(),
    )
  ]);

  // AppTaskController classes
  // FromJsonFactory().register(UserTaskSnapshotList());
  FromJsonFactory().register(UserTaskSnapshot(
    '',
    AppTask(type: 'ignored'),
    UserTaskState.canceled,
    DateTime.now(),
    DateTime.now(),
    true,
    '',
    '',
  ));

  _fromJsonFunctionsRegistrered = true;
}
