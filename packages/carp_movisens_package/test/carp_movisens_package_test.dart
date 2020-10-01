import 'dart:convert';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_movisens_package/movisens.dart';
import 'package:test/test.dart';

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    SamplingPackageRegistry.instance.register(MovisensSamplingPackage());

    study = Study("1234", "bardram", name: "bardram study")
      ..dataEndPoint = DataEndPoint(DataEndPointTypes.PRINT)
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

    OMHHeartRateDatum omh_steps =
        TransformerSchemaRegistry.instance.lookup(NameSpace.OMH).transform(hr);
    DataPoint dp_2 = DataPoint.fromDatum(study.id, study.userId, omh_steps);
    expect(dp_2.header.dataFormat.namespace, NameSpace.OMH);
    expect(omh_steps.hr.heartRate.value, double.tryParse(hr.hr));
    print(_encode(dp_2));
  });

  test('Movisens Step Count -> OMH StepCount', () {
    MovisensStepCountDatum steps = MovisensStepCountDatum()..stepCount = '56';
    steps..movisensTimestamp = DateTime.now().toUtc().toString();

    DataPoint dp_1 = DataPoint.fromDatum(study.id, study.userId, steps);
    expect(dp_1.header.dataFormat.namespace, NameSpace.CARP);
    print(_encode(dp_1));

    OMHStepCountDatum omh_steps = TransformerSchemaRegistry.instance
        .lookup(NameSpace.OMH)
        .transform(steps);
    DataPoint dp_2 = DataPoint.fromDatum(study.id, study.userId, omh_steps);
    expect(dp_2.header.dataFormat.namespace, NameSpace.OMH);
    expect(omh_steps.stepCount.stepCount, int.tryParse(steps.stepCount));
    print(_encode(dp_2));
  });
}
