import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_movisens_package/movisens.dart';
import 'package:test/test.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    SamplingPackageRegistry().register(MovisensSamplingPackage());

    study = Study(id: "1234", userId: "bardram", name: "bardram study")
      ..dataEndPoint = DataEndPoint(type: DataEndPointTypes.PRINT)
      ..addTriggerTask(
          ImmediateTrigger(),
          Task()
            ..measures = SamplingSchema
                .common(namespace: NameSpace.CARP)
                .measures
                .values
                .toList());
  });

  test('Movisens HR -> OMH HeartRate', () {
    MovisensHRDatum hr = MovisensHRDatum()..hr = '78';

    DataPoint dp_1 = DataPoint.fromDatum(study.id, study.userId, hr);
    expect(dp_1.header.dataFormat.namespace, NameSpace.CARP);
    print(_encode(dp_1));

    OMHHeartRateDatum omhSteps =
        TransformerSchemaRegistry().lookup(NameSpace.OMH).transform(hr);
    DataPoint dp_2 = DataPoint.fromDatum(study.id, study.userId, omhSteps);
    expect(dp_2.header.dataFormat.namespace, NameSpace.OMH);
    expect(omhSteps.hr.heartRate.value, double.tryParse(hr.hr));
    print(_encode(dp_2));
  });

  test('Movisens Step Count -> OMH StepCount', () {
    MovisensStepCountDatum steps = MovisensStepCountDatum()..stepCount = '56';
    steps..movisensTimestamp = DateTime.now().toUtc().toString();

    DataPoint dp_1 = DataPoint.fromDatum(study.id, study.userId, steps);
    expect(dp_1.header.dataFormat.namespace, NameSpace.CARP);
    print(_encode(dp_1));

    OMHStepCountDatum omhSteps =
        TransformerSchemaRegistry().lookup(NameSpace.OMH).transform(steps);
    DataPoint dp_2 = DataPoint.fromDatum(study.id, study.userId, omhSteps);
    expect(dp_2.header.dataFormat.namespace, NameSpace.OMH);
    expect(omhSteps.stepCount.stepCount, int.tryParse(steps.stepCount));
    print(_encode(dp_2));
  });
}
