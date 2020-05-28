import 'dart:convert';
import 'dart:io';

import 'package:carp_health_package/health_package.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:health/health.dart';
import 'package:test/test.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    SamplingPackageRegistry.register(HealthSamplingPackage());

    study = Study("1234", "bardram", name: "bardram study")
      ..dataEndPoint = DataEndPoint(DataEndPointTypes.PRINT)
//      ..addTriggerTask(
//          ImmediateTrigger(), // a simple trigger that starts immediately
//          Task(name: 'Sampling Task')
//            ..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());
      ..addTriggerTask(
          ImmediateTrigger(),
          AutomaticTask(name: 'Task #1')
            //..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());
            ..measures = SamplingSchema.common().getMeasureList(namespace: NameSpace.CARP, types: [
              DeviceSamplingPackage.BATTERY,
              HealthSamplingPackage.HEALTH,
            ]));
  });

  group("Health Study", () {
    test(' - measure -> json', () async {
      HealthMeasure mh = HealthMeasure(
        MeasureType(NameSpace.CARP, HealthSamplingPackage.HEALTH),
        healthDataType: HealthDataType.STEPS,
      );
      print(mh.toJson());
      print(_encode(mh));
    });

    test(' - study -> json', () async {
      print(_encode(study));
      expect(study.id, "1234");
    });

    test(' - json -> study', () async {
      final studyJson = _encode(study);
      Study study_2 = Study.fromJson(json.decode(studyJson) as Map<String, dynamic>);
      expect(study_2.id, study.id);
      print(_encode(study_2));
    });

    test(' - json file -> study', () async {
      String plainStudyJson = File("test/study_1234.json").readAsStringSync();
      print(plainStudyJson);

      Study plainStudy = Study.fromJson(json.decode(plainStudyJson) as Map<String, dynamic>);
      expect(plainStudy.id, study.id);

      final studyJson = _encode(study);

      Study study_2 = Study.fromJson(json.decode(plainStudyJson) as Map<String, dynamic>);
      expect(_encode(study_2), equals(studyJson));
    });
  });

  group("DASES Data Types", () {
    test(' - CALORIES_INTAKE', () {
      HealthDatum hd = HealthDatum(
        500,
        enumToString(dasesDataTypeToUnit[DasesHealthDataType.CALORIES_INTAKE]),
        DateTime.now().millisecondsSinceEpoch - 10000,
        DateTime.now().millisecondsSinceEpoch,
        enumToString(DasesHealthDataType.CALORIES_INTAKE),
        enumToString(PlatformType.ANDROID),
      );

      DataPoint dp_1 = DataPoint.fromDatum(study.id, study.userId, hd);
      expect(dp_1.header.dataFormat.namepace, NameSpace.CARP);
      expect(dp_1.header.dataFormat.name, "health.calories_intake");
      print(_encode(dp_1));
    });

    test(' - ALCOHOL', () {
      HealthDatum hd = HealthDatum(
        6,
        enumToString(dasesDataTypeToUnit[DasesHealthDataType.ALCOHOL]),
        DateTime.now().millisecondsSinceEpoch - 10000,
        DateTime.now().millisecondsSinceEpoch,
        enumToString(DasesHealthDataType.ALCOHOL),
        enumToString(PlatformType.IOS),
      );

      DataPoint dp_1 = DataPoint.fromDatum(study.id, study.userId, hd);
      expect(dp_1.header.dataFormat.namepace, NameSpace.CARP);
      expect(dp_1.header.dataFormat.name, "health.alcohol");
      print(_encode(dp_1));
    });

    test(' - SLEEP', () {
      HealthDatum hd = HealthDatum(
        6,
        enumToString(dasesDataTypeToUnit[DasesHealthDataType.SLEEP]),
        DateTime.now().millisecondsSinceEpoch - 8 * 60 * 60 * 100,
        DateTime.now().millisecondsSinceEpoch,
        enumToString(DasesHealthDataType.SLEEP),
        enumToString(PlatformType.IOS),
      );

      DataPoint dp_1 = DataPoint.fromDatum(study.id, study.userId, hd);
      expect(dp_1.header.dataFormat.namepace, NameSpace.CARP);
      expect(dp_1.header.dataFormat.name, "health.sleep");
      print(_encode(dp_1));
    });
  });

  test(
    'iPDM-GO Study',
    () async {
      study = Study("1234", "user@dtu.dk", name: "iPDM-GO sample study")
        ..dataEndPoint = DataEndPoint(DataEndPointTypes.PRINT)
        ..addTriggerTask(
            // collect continuously
            ImmediateTrigger(),
            AutomaticTask()
              ..measures = SamplingSchema.common().getMeasureList(
                namespace: NameSpace.CARP,
                types: [
                  SensorSamplingPackage.PEDOMETER,
                  //ContextSamplingPackage.GEOLOCATION,
                  //ContextSamplingPackage.ACTIVITY,
                  //ContextSamplingPackage.WEATHER,
                ],
              ))
        ..addTriggerTask(
            // collect every hour
            PeriodicTrigger(period: Duration(minutes: 60)),
            AutomaticTask()
              ..measures.add(HealthMeasure(
                MeasureType(NameSpace.CARP, HealthSamplingPackage.HEALTH),
                healthDataType: HealthDataType.BLOOD_GLUCOSE,
              ))
              ..measures.add(HealthMeasure(
                MeasureType(NameSpace.CARP, HealthSamplingPackage.HEALTH),
                healthDataType: HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
              ))
              ..measures.add(HealthMeasure(
                MeasureType(NameSpace.CARP, HealthSamplingPackage.HEALTH),
                healthDataType: HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
              ))
              ..measures.add(HealthMeasure(
                MeasureType(NameSpace.CARP, HealthSamplingPackage.HEALTH),
                healthDataType: HealthDataType.HEART_RATE,
              ))
              ..measures.add(HealthMeasure(
                MeasureType(NameSpace.CARP, HealthSamplingPackage.HEALTH),
                name: 'Steps',
                healthDataType: HealthDataType.STEPS,
              ))
            //
            )
        ..addTriggerTask(
            // collect every day at 23:00
            RecurrentScheduledTrigger(type: RecurrentType.daily, time: Time(hour: 23, minute: 00)),
            AutomaticTask()
              ..measures.add(HealthMeasure(
                MeasureType(NameSpace.CARP, HealthSamplingPackage.HEALTH),
                healthDataType: HealthDataType.WEIGHT,
              ))
            //
            );

      // Create a Study Controller that can manage this study.
      StudyController controller = StudyController(study);

      // await initialization before starting/resuming
      await controller.initialize();
      controller.resume();

      // later, somewhere else in the app, input from the user can be captured
      // as a HealthDatum and added to the CAMS event stream

      // create an alcohol health datum object
      HealthDatum alcohol = HealthDatum(
        6,
        enumToString(dasesDataTypeToUnit[DasesHealthDataType.ALCOHOL]),
        DateTime.now().millisecondsSinceEpoch - 10000,
        DateTime.now().millisecondsSinceEpoch,
        enumToString(DasesHealthDataType.ALCOHOL),
        (Platform.isAndroid) ? enumToString(PlatformType.ANDROID) : enumToString(PlatformType.IOS),
      );

      // manually add the datum to the event stream
      controller.executor.addDatum(alcohol);

      // report smoking
      HealthDatum smoking = HealthDatum(
        12,
        enumToString(dasesDataTypeToUnit[DasesHealthDataType.SMOKED_CIGARETTES]),
        DateTime.now().millisecondsSinceEpoch - 10000,
        DateTime.now().millisecondsSinceEpoch,
        enumToString(DasesHealthDataType.SMOKED_CIGARETTES),
        (Platform.isAndroid) ? enumToString(PlatformType.ANDROID) : enumToString(PlatformType.IOS),
      );

      controller.executor.addDatum(smoking);
    },
    skip: true, // this cannot be executed since it creates a study controller
  );
}
