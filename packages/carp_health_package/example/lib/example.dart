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

  // Define which devices are used for data collection.

  // First add this smartphone.
  final phone = Smartphone();
  protocol.addPrimaryDevice(phone);

  // Define which health types to collect.
  var healthDataTypes = [
    HealthDataType.WEIGHT,
    HealthDataType.EXERCISE_TIME,
    HealthDataType.STEPS,
    HealthDataType.SLEEP_ASLEEP,
  ];

  // Create and add a health service (device)
  final healthService = HealthService(types: healthDataTypes);
  protocol.addConnectedDevice(healthService, phone);

  // Automatically collect the set of health data every hour.
  //
  // Note that the [HealthSamplingConfiguration] is a [HistoricSamplingConfiguration]
  // which samples data back in time until last time, data was sampled.
  protocol.addTaskControl(
      PeriodicTrigger(period: Duration(minutes: 60)),
      BackgroundTask()
        ..addMeasure(Measure(type: HealthSamplingPackage.HEALTH)
          ..overrideSamplingConfiguration =
              HealthSamplingConfiguration(healthDataTypes: healthDataTypes)),
      healthService);

  // Automatically collect another set of health data every hour
  //
  // Note, however, that the service defined above DOES NOT have this list of
  // health data specified, and has therefore not asked for permission to access
  // this new set of health data.
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
      healthService);

  // Create an app task for the user to collect his own health data once pr. day
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
                  HealthSamplingConfiguration(healthDataTypes: healthDataTypes)
          ]),
      healthService);
}
