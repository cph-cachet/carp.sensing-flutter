import 'package:test/test.dart';
import 'package:carp_backend/carp_backend.dart';

void main() {
  group('AuthenticationManager Tests', () {
    CARPBackend carp;
    String oAuthResponse;
    OAuthToken oAuthToken;
    Map<String, String> oAuthResponseJson;
    User testUser;

    setUp(() async {
      /// Instantiate test user with no oAuthToken initially.
      //testUser = new User("thomas", "pass", null);
      testUser = new User("admin", "password", null);

      /// Instantiate an AuthenticationManager
      carp = new CARPBackend();

      /// Send oAuth token request to the CARP oAuth endpoint and receive a token in return
      oAuthToken = await carp.authenticate(testUser.username, testUser.password);

      /// Assign fetched token to user
      testUser.set(oAuthToken);
    });

    /// Test JSON deserialization to OAuthToken object
    test('JSON OAuth Test', () async {
      DateTime expiryDate = oAuthToken.accessTokenExpiryDate;
      DateTime now = new DateTime.now();

      /// Verify that the expiry date is later than now
      expect(expiryDate.isAfter(now), isTrue);
      print("Test - JSON OAuth: $expiryDate");
    });

    /// Test user information after assigning the oAuthToken
    test('JSON OAuth Test', () async {
      var userInfo = testUser.userInfo;

      /// Verify that the OAuthToken was assigned to the user
      print("Test - User Info: $userInfo");
      expect(testUser.oAuthToken == oAuthToken, isTrue);
    });
  });
}
