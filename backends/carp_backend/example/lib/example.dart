import 'package:carp_backend/carp_backend.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:research_package/model.dart';

void main() async {
  // -----------------------------------------------
  // EXAMPLE OF CONFIGURING THE CARP APP
  // -----------------------------------------------

  final String uri = "https://cans.cachet.dk:443";

  // configure an app that points to the CARP web service
  CarpApp app = CarpApp(
    name: 'any_display_friendly_name_is_fine',
    uri: Uri.parse(uri),
    oauth: OAuthEndPoint(
      clientID: 'the_client_id',
      clientSecret: 'the_client_secret',
    ),
  );

  // configure the CARP service
  CarpService().configure(app);

  // authenticate at CARP
  await CarpService()
      .authenticate(username: 'the_username', password: 'the_password');

  // configure the other services needed
  CarpParticipationService().configureFrom(CarpService());
  CarpDeploymentService().configureFrom(CarpService());

  // get the invitations to studies from CARP for this user
  List<ActiveParticipationInvitation> invitations =
      await CarpParticipationService().getActiveParticipationInvitations();

  // use the first (i.e. latest) invitation
  String studyDeploymentId = invitations[0].studyDeploymentId;

  // -----------------------------------------------
  // EXAMPLE OF GETTING A STUDY PROTOCOL FROM CARP
  // -----------------------------------------------

  // create a CARP study manager and initialize it
  CarpStudyProtocolManager manager = CarpStudyProtocolManager();
  await manager.initialize();

  // get the study from CARP
  StudyProtocol study = await manager.getStudyProtocol('protocol_id');

  // -----------------------------------------------
  // DIFFERENT WAYS TO UPLOAD DATA TO CARP
  // -----------------------------------------------

  // first register the CARP data manager
  DataManagerRegistry().register(CarpDataManager());

  // create a CARP data endpoint that upload using the DATA_POINT method
  CarpDataEndPoint cdep = CarpDataEndPoint(
      uploadMethod: CarpUploadMethod.DATA_POINT,
      name: 'CARP Staging Server',
      uri: 'http://staging.carp.cachet.dk:8080',
      clientId: 'carp',
      clientSecret: 'a_secret',
      email: 'username@cachet.dk',
      password: 'password');

  // using the file method would also take information on file size whether to zip it
  CarpDataEndPoint cdep_2 = CarpDataEndPoint(
      uploadMethod: CarpUploadMethod.FILE,
      name: 'CARP Staging Server',
      uri: 'http://staging.carp.cachet.dk:8080',
      clientId: 'carp',
      clientSecret: 'a_secret',
      email: 'username@cachet.dk',
      password: 'password',
      bufferSize: 500 * 1000,
      zip: true);
  print('$cdep_2');

  // using the batch upload method could also take information on file size,
  // but the file must NOT be zipped
  CarpDataEndPoint cdep_3 = CarpDataEndPoint(
    uploadMethod: CarpUploadMethod.BATCH_DATA_POINT,
    name: 'CARP Staging Server',
    uri: 'http://staging.carp.cachet.dk:8080',
    clientId: 'carp',
    clientSecret: 'a_secret',
    email: 'username@cachet.dk',
    password: 'password',
    bufferSize: 500 * 1000,
    deleteWhenUploaded: true,
  );
  print('$cdep_3');

  StudyDeploymentStatus status =
      await CarpDeploymentService().getStudyDeploymentStatus(studyDeploymentId);

  // get the master device deployment
  MasterDeviceDeployment deployment =
      await CarpDeploymentService().getDeviceDeploymentFor(
    status.studyDeploymentId,
    status.masterDeviceStatus.device.roleName,
  );

  /// change a master device deployment to use another data endpoint before
  /// it is being executed
  deployment.dataEndPoint = cdep_2;

  // --------------------------------------------------
  // EXAMPLE OF GETTING AN INFORMED CONSENT FROM CARP
  // --------------------------------------------------

  // create and initialize the informed consent manager
  CarpResourceManager icManager = CarpResourceManager();
  icManager.initialize();

  // get the informed consent as a RP ordered task
  RPOrderedTask informedConsent = await icManager.getInformedConsent();

  print(informedConsent);

  // upload another informed consent to CARP
  RPOrderedTask anotherInformedConsent = RPOrderedTask('12', [
    RPInstructionStep(
      "1",
      title: "Welcome!",
    )..text = "Welcome to this study! ",
    RPCompletionStep("2")
      ..title = "Thank You!"
      ..text = "We saved your consent document.",
  ]);
  await icManager.setInformedConsent(anotherInformedConsent);
}
