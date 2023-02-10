import 'package:carp_backend/carp_backend.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
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
  String studyDeploymentId = invitations[0].studyDeploymentId!;

  // // -----------------------------------------------
  // // EXAMPLE OF GETTING A STUDY PROTOCOL FROM CARP
  // // -----------------------------------------------

  // // create a CARP study manager and initialize it
  // CarpStudyProtocolManager manager = CarpStudyProtocolManager();
  // await manager.initialize();

  // // get the study from CARP
  // StudyProtocol protocol = await manager.getStudyProtocol('protocol_id');
  // print(protocol);

  // // -----------------------------------------------
  // // EXAMPLE OF GETTING A STUDY DEPLOYMENT FROM CARP
  // // -----------------------------------------------

  // // get the status of the deployment
  // StudyDeploymentStatus status = await CustomProtocolDeploymentService()
  //     .getStudyDeploymentStatus(studyDeploymentId);

  // // create and configure a client manager for this phone
  // SmartPhoneClientManager client = SmartPhoneClientManager();
  // await client.configure(
  //   deploymentService: CustomProtocolDeploymentService(),
  //   deviceController: DeviceController(),
  // );

  // // Define the study and add it to the client.
  // final study = Study(
  //   status.studyDeploymentId,
  //   status.masterDeviceStatus!.device.roleName,
  // );
  // await client.addStudy(study);

  // // Get the study controller and try to deploy the study.
  // //
  // // Note that if the study has already been deployed on this phone
  // // it has been cached locally in a file and the local cache will
  // // be used pr. default.
  // // If not deployed before (i.e., cached) the study deployment will be
  // // fetched from the deployment service.
  // SmartphoneDeploymentController? controller = client.getStudyRuntime(study);
  // await controller?.tryDeployment(useCached: true);

  // // configure the controller with the default privacy schema
  // await controller?.configure();

  // // listening on the data stream and print them as json to the debug console
  // controller?.data.listen((data) => print(toJsonString(data)));

  // -----------------------------------------------
  // DIFFERENT WAYS TO UPLOAD DATA TO CARP
  // -----------------------------------------------

  // first register the CARP data manager factory
  DataManagerRegistry().register(CarpDataManagerFactory());

  // using the (default) data stream batch upload method
  CarpDataEndPoint cdep_3 = CarpDataEndPoint(
    uploadMethod: CarpUploadMethod.DATA_STREAM,
    deleteWhenUploaded: true,
  );

  print('$cdep_3');

  // create a CARP data endpoint that upload each measurement using the
  // DATA_POINT method
  CarpDataEndPoint cdep = CarpDataEndPoint(
      uploadMethod: CarpUploadMethod.DATA_POINT,
      name: 'CARP Staging Server',
      uri: 'http://staging.carp.cachet.dk:8080',
      clientId: 'carp',
      clientSecret: 'a_secret',
      email: 'username@cachet.dk',
      password: 'password');

  // other types of data endpoints

  // using the file method would upload SQLite db files
  CarpDataEndPoint cdep_2 = CarpDataEndPoint(
    uploadMethod: CarpUploadMethod.FILE,
    name: 'CARP Staging Server',
    uri: 'http://staging.carp.cachet.dk:8080',
    clientId: 'carp',
    clientSecret: 'a_secret',
    email: 'username@cachet.dk',
    password: 'password',
  );

  print('$cdep_2');

  // create a study protocol with a specific data endpoint
  SmartphoneStudyProtocol carpProtocol = SmartphoneStudyProtocol(
    ownerId: 'AB',
    name: 'Track patient movement',
    dataEndPoint: cdep,
  );

  // --------------------------------------------------
  // EXAMPLE OF GETTING AN INFORMED CONSENT FROM CARP
  // --------------------------------------------------

  // create and initialize the informed consent manager
  CarpResourceManager icManager = CarpResourceManager();
  icManager.initialize();

  // get the informed consent as a RP ordered task
  RPOrderedTask? informedConsent = await icManager.getInformedConsent();

  print(informedConsent);

  // upload another informed consent to CARP
  RPOrderedTask anotherInformedConsent =
      RPOrderedTask(identifier: '12', steps: [
    RPInstructionStep(
      identifier: "1",
      title: "Welcome!",
    )..text = "Welcome to this study! ",
    RPCompletionStep(
        identifier: "2",
        title: "Thank You!",
        text: "We saved your consent document."),
  ]);
  await icManager.setInformedConsent(anotherInformedConsent);
}
