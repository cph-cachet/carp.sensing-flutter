import 'dart:convert';

import 'package:carp_audio_package/audio.dart';
import 'package:carp_communication_package/communication.dart';
import 'package:carp_context_package/context.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:test/test.dart';

import '../lib/cams_study_generator.dart' as cams_study_generator;

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() async {
    SamplingPackageRegistry().register(AudioSamplingPackage());
    SamplingPackageRegistry().register(CommunicationSamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());

    study = await cams_study_generator.settings.manager
        .getStudy(cams_study_generator.settings.studyId);

    // study = Study('1234', 'bardram', name: 'bardram study', deploymentId: '#1');
    // //study.dataEndPoint = DataEndPoint(DataEndPointType.PRINT);
    // study.dataEndPoint = FileDataEndPoint()
    //   ..bufferSize = 50 * 1000
    //   ..zip = true
    //   ..encrypt = false;
    //
    // // adding all measure from the common schema to one one trigger and one task
    // study.addTriggerTask(
    //     ImmediateTrigger(), // a simple trigger that starts immediately
    //     AutomaticTask(name: 'Sampling Task')..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList() // a task with all measures
    //     );
  });

  test('Study -> JSON', () async {
    print(_encode(study));

    expect(study.id, cams_study_generator.settings.studyId);
  });
}
