import 'dart:io';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:carp_study_generator/carp_study_generator.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:research_package/model.dart';
import 'package:carp_apps_package/apps.dart';
import 'package:carp_communication_package/communication.dart';
import 'package:carp_context_package/context.dart';
import 'package:carp_audio_package/audio.dart';
import 'package:carp_esense_package/esense.dart';
import 'package:carp_survey_package/survey.dart';
import 'package:carp_health_package/health_package.dart';

void main() {
  setUp(() {
    // make sure that the json functions are loaded
    DomainJsonFactory();

    // create two dummy RPTask to register json deserialization functions for RP
    RPTask(identifier: 'ignored');

    // register the sampling packages
    // this is used to be able to deserialize the json protocol
    SamplingPackageRegistry().register(AppsSamplingPackage());
    SamplingPackageRegistry().register(CommunicationSamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());
    SamplingPackageRegistry().register(AudioSamplingPackage());
    SamplingPackageRegistry().register(ESenseSamplingPackage());
    SamplingPackageRegistry().register(SurveySamplingPackage());
    SamplingPackageRegistry().register(HealthSamplingPackage());
  });

  group("commands", () {
    test('help', () async => HelpCommand().execute());
    test('dryrun', () async => DryRunCommand().execute());
    test('description', () async => StudyDescriptionCommand().execute());
    test('consent', () async => ConsentCommand().execute());
    test('protocol', () async => CreateStudyProtocolCommand().execute());
  });

  group("parsing resources", () {
    test('consent', () async {
      String consentPath = 'carp/resources/consent.json';
      String consentJson = File(consentPath).readAsStringSync();
      RPOrderedTask.fromJson(json.decode(consentJson) as Map<String, dynamic>);
    });

    test('description', () async {
      String descriptionPath = 'carp/resources/description.json';
      String descriptionJson = File(descriptionPath).readAsStringSync();
      StudyDescription.fromJson(
          json.decode(descriptionJson) as Map<String, dynamic>);
    });

    test('protocol', () async {
      String protocolPath = 'carp/resources/protocol.json';
      String protocolJson = File(protocolPath).readAsStringSync();
      StudyProtocol.fromJson(json.decode(protocolJson) as Map<String, dynamic>);
    });
  });
}
