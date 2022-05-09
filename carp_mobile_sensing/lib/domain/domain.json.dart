part of domain;

bool _fromJsonFunctionsRegistrered = false;

// Register all the fromJson functions for the domain classes.
void _registerFromJsonFunctions() {
  if (_fromJsonFunctionsRegistrered) return;

  // Protocol classes
  // FromJsonFactory().register(SmartphoneStudyProtocol(name: '', ownerId: ''));
  FromJsonFactory().register(StudyResponsible(
    id: '',
    title: '',
    address: '',
    affiliation: '',
    email: '',
    name: '',
  ));
  FromJsonFactory().register(DataEndPoint(type: ''));
  FromJsonFactory().register(FileDataEndPoint(dataFormat: ''));
  FromJsonFactory().register(StudyDescription(
    title: '',
    description: '',
    purpose: '',
  ));

  // Task classes
  FromJsonFactory().register(AutomaticTask());
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
  FromJsonFactory().register(ConditionalSamplingEventTrigger(
      measureType: 'ignored', resumeCondition: (DataPoint dataPoint) => true));
  FromJsonFactory().register(RandomRecurrentTrigger(
    startTime: TimeOfDay(hour: 1),
    endTime: TimeOfDay(hour: 2),
  ));

  // Measure classes
  // FromJsonFactory().register(CAMSMeasure(type: 'ignored'));
  // FromJsonFactory().register(
  //     PeriodicMeasure(type: 'ignored', frequency: Duration(seconds: 1)));
  // FromJsonFactory().register(MarkedMeasure(type: 'ignored'));

  // AppTaskController classes
  FromJsonFactory().register(UserTaskSnapshotList());
  FromJsonFactory().register(UserTaskSnapshot('', AppTask(type: 'ignored'),
      UserTaskState.canceled, DateTime.now(), DateTime.now(), '', ''));
  _fromJsonFunctionsRegistrered = true;
}

class DomainJsonFactory {
  DomainJsonFactory() {
    _registerFromJsonFunctions();
  }
}

var tmp = DomainJsonFactory();
