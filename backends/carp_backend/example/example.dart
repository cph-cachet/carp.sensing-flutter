import 'package:carp_backend/carp_backend.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

void main() {
  final String username = "researcher";

  // first register the CARP data manager
  DataManagerRegistry().register(CarpDataManager());

  // create a CARP data endpoint that upload using the DATA_POINT method
  CarpDataEndPoint cdep = CarpDataEndPoint(CarpUploadMethod.DATA_POINT,
      name: 'CARP Staging Server',
      uri: 'http://staging.carp.cachet.dk:8080',
      clientId: 'carp',
      clientSecret: 'a_secret',
      email: 'username@cachet.dk',
      password: 'password');

  // using the file method would also take information on file size whether to zip it
  CarpDataEndPoint cdep_2 = CarpDataEndPoint(CarpUploadMethod.FILE,
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
    CarpUploadMethod.BATCH_DATA_POINT,
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
  Study study = new Study(
    id: '1234',
    userId: 'username@cachet.dk',
    name: 'Test study #1234',
  );
  study.dataEndPoint = cdep;
}
