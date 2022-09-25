part of domain;

bool _fromJsonFunctionsRegistrered = false;

// Register all the fromJson functions for the domain classes.
void _registerFromJsonFunctions() {
  if (_fromJsonFunctionsRegistrered) return;

  // Protocol classes
  FromJsonFactory().register(StudyResponsible(
    id: '',
    title: '',
    address: '',
    affiliation: '',
    email: '',
    name: '',
  ));
  FromJsonFactory().register(DataEndPoint(type: ''));
  FromJsonFactory().register(FileDataEndPoint());
  FromJsonFactory().register(SQLiteDataEndPoint());
  FromJsonFactory().register(StudyDescription(
    title: '',
    description: '',
    purpose: '',
  ));

  // Task classes
  FromJsonFactory().register(AppTask(type: 'ignored'));

  // Trigger classes
  FromJsonFactory().register(ImmediateTrigger());
  FromJsonFactory().register(OneTimeTrigger());
  FromJsonFactory().register(DelayedTrigger(delay: Duration()));
  FromJsonFactory().register(IntervalTrigger(period: Duration()));
  FromJsonFactory().register(PeriodicTrigger(
    period: Duration(),
    duration: Duration(),
  ));
  FromJsonFactory().register(DateTimeTrigger(schedule: DateTime.now()));
  FromJsonFactory().register(RecurrentScheduledTrigger(
    type: RecurrentType.daily,
    time: TimeOfDay(),
  ));
  FromJsonFactory().register(SamplingEventTrigger(measureType: 'ignored'));
  FromJsonFactory().register(ConditionalEvent({}));
  FromJsonFactory().register(ConditionalPeriodicTrigger(period: Duration()));
  FromJsonFactory().register(ConditionalSamplingEventTrigger(
      measureType: 'ignored', resumeCondition: (DataPoint dataPoint) => true));
  FromJsonFactory().register(CronScheduledTrigger());
  FromJsonFactory().register(RandomRecurrentTrigger(
    startTime: TimeOfDay(hour: 1),
    endTime: TimeOfDay(hour: 2),
  ));

  // Sampling Configuration classes
  FromJsonFactory().register(PersistentSamplingConfiguration());
  FromJsonFactory().register(HistoricSamplingConfiguration());
  FromJsonFactory()
      .register(IntervalSamplingConfiguration(interval: Duration.zero));
  FromJsonFactory().register(PeriodicSamplingConfiguration(
    interval: Duration.zero,
    duration: Duration.zero,
  ));
  FromJsonFactory().register(BatteryAwareSamplingConfiguration(
    normal: PersistentSamplingConfiguration(),
    low: PersistentSamplingConfiguration(),
    critical: PersistentSamplingConfiguration(),
  ));

  // AppTaskController classes
  FromJsonFactory().register(UserTaskSnapshotList());
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
