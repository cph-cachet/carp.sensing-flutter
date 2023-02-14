import 'dart:convert';
import 'dart:io';
// import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_connectivity_package/connectivity.dart';
import 'package:carp_esense_package/esense.dart';
import 'package:carp_polar_package/carp_polar_package.dart';
import 'package:carp_context_package/carp_context_package.dart';
import 'package:carp_audio_package/media.dart';
// import 'package:carp_communication_package/communication.dart';
import 'package:carp_apps_package/apps.dart';
import 'package:carp_backend/carp_backend.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';

import '../lib/main.dart';
import 'credentials.dart';

void main() {
  CarpMobileSensing.ensureInitialized();

  setUp(() async {
    // register the different sampling package since we're using measures from them
    SamplingPackageRegistry().register(ConnectivitySamplingPackage());
    SamplingPackageRegistry().register(ContextSamplingPackage());
    SamplingPackageRegistry().register(MediaSamplingPackage());
    // SamplingPackageRegistry().register(CommunicationSamplingPackage());
    SamplingPackageRegistry().register(AppsSamplingPackage());
    SamplingPackageRegistry().register(ESenseSamplingPackage());
    // SamplingPackageRegistry().register(PolarSamplingPackage());

    // Initialization of serialization
    // CarpMobileSensing();

    // create a data manager in order to register the json functions
    CarpDataManager();
  });

  CarpApp app;
  late CarpUser user;

  group("CARP Study Protocol Manager", () {
    setUp(() async {
      app = CarpApp(
        name: "Test",
        uri: Uri.parse(uri),
        oauth: OAuthEndPoint(clientID: clientID, clientSecret: clientSecret),
      );

      CarpService().configure(app);

      user = await CarpService().authenticate(
        username: username,
        password: password,
      );

      CarpParticipationService().configureFrom(CarpService());
      CarpDeploymentService().configureFrom(CarpService());

      // make sure that the json functions are loaded
      CarpMobileSensing();
    });

    test('- authentication', () async {
      print('CarpService : ${CarpService().app}');
      print(" - signed in as: $user");
    });

    test('- get study deployment', () async {
      final study =
          await CarpDeploymentService().deployment(testDeploymentId).get();
      print('study: $study');
      print(toJsonString(study));
    });

    test(
      '- get invitations',
      () async {
        List<ActiveParticipationInvitation> invitations =
            await CarpParticipationService()
                .getActiveParticipationInvitations();

        for (var invitation in invitations) {
          print(invitation);
        }
      },
    );
  });
}
