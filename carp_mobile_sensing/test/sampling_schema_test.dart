import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    //SamplingPackageRegistry.register(AudioSamplingPackage());
    //SamplingPackageRegistry.register(CommunicationSamplingPackage());
    //SamplingPackageRegistry.register(ContextSamplingPackage());

    study = Study("1234", "bardram", name: "bardram study");
    study.dataEndPoint = DataEndPoint(DataEndPointTypes.PRINT);

    study.addTriggerTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..measures = SamplingSchema.common().getMeasureList(
          namespace: NameSpace.CARP,
          types: [
//            AppsSamplingPackage.APPS,
//            AppsSamplingPackage.APP_USAGE,
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.BATTERY,
            DeviceSamplingPackage.DEVICE,
            DeviceSamplingPackage.MEMORY,
          ],
        ),
    );

    study.addTriggerTask(
        ImmediateTrigger(),
        AutomaticTask(name: 'Sensor Task')
          ..addMeasure(PeriodicMeasure(
              MeasureType(NameSpace.CARP, SensorSamplingPackage.ACCELEROMETER),
              frequency: const Duration(seconds: 10),
              duration: const Duration(milliseconds: 100)))
          ..addMeasure(PeriodicMeasure(
              MeasureType(NameSpace.CARP, SensorSamplingPackage.GYROSCOPE),
              frequency: const Duration(seconds: 20),
              duration: const Duration(milliseconds: 100))));
  });

  String _stringSnapshot;
  void _snapshot() {
    _stringSnapshot = json.encode(study);
  }

  void _restore() {
    study = Study.fromJson(json.decode(_stringSnapshot));
  }

  test('json.encode study', () {
    print(JsonEncoder.withIndent('  ').convert(study));
  });

  /// Test if we can take a snapshot of a Study and restore it using JSON.
  test('Study snapshot / restore', () async {
    print(_encode(study));
    _snapshot();

    _restore();
    print(_encode(study));

    expect(study.id, "1234");
  });

  /// Test template.
  test('...', () {
    // test template
  });
}
