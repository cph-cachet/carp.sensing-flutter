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
  protocol.addPrimaryDevice(phone);

  // automatically collect the default (steps) data every hour
  protocol.addTaskControl(
      PeriodicTrigger(period: Duration(minutes: 60)),
      BackgroundTask(measures: [Measure(type: HealthSamplingPackage.HEALTH)]),
      phone);

  // automatically collect a set of health data every hour
  protocol.addTaskControl(
      PeriodicTrigger(period: Duration(minutes: 60)),
      BackgroundTask()
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration =
              HealthSamplingConfiguration(healthDataTypes: [
            HealthDataType.BLOOD_GLUCOSE,
            HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
            HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
            HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
            HealthDataType.HEART_RATE,
            HealthDataType.STEPS,
          ])),
      phone);

  // collect weight every day at 23:00
  protocol.addTaskControl(
      RecurrentScheduledTrigger(
          type: RecurrentType.daily, time: TimeOfDay(hour: 23, minute: 00)),
      BackgroundTask()
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration = HealthSamplingConfiguration(
              healthDataTypes: [HealthDataType.WEIGHT])),
      phone);

  // create an app task for the user to collect his own health data every day
  protocol.addTaskControl(
      PeriodicTrigger(period: Duration(hours: 24)),
      AppTask(
          type: 'health',
          title: "Press here to collect your physical health data",
          description:
              "This will collect your weight, exercise time, steps, and sleep time from Apple Health.",
          measures: [
            Measure(type: HealthSamplingPackage.HEALTH)
              ..overrideSamplingConfiguration =
                  HealthSamplingConfiguration(healthDataTypes: [
                HealthDataType.WEIGHT,
                HealthDataType.EXERCISE_TIME,
                HealthDataType.STEPS,
                HealthDataType.SLEEP_ASLEEP,
              ])
          ]),
      phone);
}
