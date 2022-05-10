import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_health_package/health_package.dart';
import 'package:health/health.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(HealthSamplingPackage());

  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Health Sensing Example',
  );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();
  protocol.addMasterDevice(phone);

  protocol.addTriggeredTask(
      // collect every hour
      IntervalTrigger(period: Duration(minutes: 60)),
      BackgroundTask()
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration = HealthSamplingConfiguration(
              healthDataType: HealthDataType.BLOOD_GLUCOSE))
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration = HealthSamplingConfiguration(
              healthDataType: HealthDataType.BLOOD_PRESSURE_DIASTOLIC))
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration = HealthSamplingConfiguration(
              healthDataType: HealthDataType.BLOOD_PRESSURE_SYSTOLIC))
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration = HealthSamplingConfiguration(
              healthDataType: HealthDataType.BLOOD_PRESSURE_DIASTOLIC))
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration = HealthSamplingConfiguration(
              healthDataType: HealthDataType.HEART_RATE))
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration = HealthSamplingConfiguration(
              healthDataType: HealthDataType.STEPS)),
      phone);

  protocol.addTriggeredTask(
      // collect every day at 23:00
      RecurrentScheduledTrigger(
          type: RecurrentType.daily, time: TimeOfDay(hour: 23, minute: 00)),
      BackgroundTask()
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration = HealthSamplingConfiguration(
              healthDataType: HealthDataType.WEIGHT)),
      phone);
}
