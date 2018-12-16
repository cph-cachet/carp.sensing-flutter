import 'package:carp_backend/carp_backend.dart';
import 'package:carp_core/carp_core.dart';

void main() {
  final String username = "researcher";
  final String password = "password";
  final String uri = "http://staging.carp.cachet.dk:8080";
  final String clientID = "carp";
  final String clientSecret = "carp";
  final String testStudyId = "8";

  // first register the CARP data manager
  DataManagerRegistry.register(DataEndPointType.CARP, new CarpDataManager());

  // create a CARP data endpoint that upload using the DATA_POINT method
  CarpDataEndPoint cdep = CarpDataEndPoint(CarpUploadMethod.DATA_POINT,
      name: 'CARP Staging Server',
      uri: uri,
      clientId: clientID,
      clientSecret: clientSecret,
      email: username,
      password: password);

  // using the file method would also take information on file size whether to zip it
  CarpDataEndPoint cdep_2 = CarpDataEndPoint(CarpUploadMethod.FILE,
      name: 'CARP Staging Server',
      uri: uri,
      clientId: clientID,
      clientSecret: clientSecret,
      email: username,
      password: password,
      bufferSize: 500 * 1000,
      zip: true);

  // create a study and allocate this data point to it.
  Study study = new Study(testStudyId, username, name: "Test study #$testStudyId");
  study.dataEndPoint = cdep;
}
