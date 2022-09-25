import 'dart:io';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:research_package/model.dart';
import 'package:carp_apps_package/apps.dart';
// import 'package:carp_communication_package/communication.dart';
import 'package:carp_context_package/carp_context_package.dart';
import 'package:carp_audio_package/media.dart';
import 'package:carp_esense_package/esense.dart';
import 'package:carp_survey_package/survey.dart';
import 'package:carp_health_package/health_package.dart';

void main() {
  setUp(() {
    // Initialization of serialization
    CarpMobileSensing();

    // create two dummy RPTask to register json deserialization functions for RP
    RPTask(identifier: 'ignored');

    // register the sampling packages
    // this is used to be able to deserialize the json protocol
    SamplingPackageRegistry().register(AppsSamplingPackage());
    // SamplingPackageRegistry().register(CommunicationSamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());
    SamplingPackageRegistry().register(MediaSamplingPackage());
    SamplingPackageRegistry().register(ESenseSamplingPackage());
    SamplingPackageRegistry().register(SurveySamplingPackage());
    SamplingPackageRegistry().register(HealthSamplingPackage());
  });

  group("parsing resources", () {
    test('consent', () async {
      String consentPath = 'carp/resources/consent.json';
      String consentJson = File(consentPath).readAsStringSync();
      RPOrderedTask.fromJson(json.decode(consentJson) as Map<String, dynamic>);
    });

    test('protocol', () async {
      String protocolPath = 'carp/resources/protocol.json';
      String protocolJson = File(protocolPath).readAsStringSync();
      StudyProtocol.fromJson(json.decode(protocolJson) as Map<String, dynamic>);
    });
  });
}
