import 'package:carp_backend/carp_backend.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void main() async {
  // final String username = "researcher";

  // -----------------------------------------------
  // EXAMPLE OF GETTING A STUDY FROM CARP
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

  CarpService().configure(app);

  // authenticate at CARP
  await CarpService()
      .authenticate(username: 'the_username', password: 'the_password');

  // get the invitations to studies from CARP for this user
  List<ActiveParticipationInvitation> invitations =
      await CarpService().invitations();

  // use the first (i.e. latest) invitation
  String studyDeploymentId = invitations[0].studyDeploymentId;

  // create a study manager, and initialize it
  CARPStudyProtocolManager manager = CARPStudyProtocolManager();
  await manager.initialize();

  // get the study from CARP
  StudyProtocol study = await manager.getStudyProtocol(studyDeploymentId);
  print('study: $study');

  // -----------------------------------------------
  // EXAMPLE OF UPLOADING DATA TO CARP
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

  // create a study and allocate this data point to it.
  CAMSStudyProtocol study_1 = CAMSStudyProtocol(
    studyId: '123',
    name: 'Test study #1234',
  );
  study_1.dataEndPoint = cdep;
}
