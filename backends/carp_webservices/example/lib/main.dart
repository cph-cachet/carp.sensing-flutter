import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:flutter/material.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:carp_core/carp_core.dart';
import 'package:oidc/oidc.dart';

void main() {
  CarpMobileSensing.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CARP Backend Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    bloc.init();
  }

  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StreamBuilder(
              stream: CarpAuthService().manager.userChanges(),
              builder: (BuildContext context, AsyncSnapshot<OidcUser?> event) {
                if (!event.hasData) {
                  return TextButton.icon(
                    onPressed: () async => bloc.currentUser =
                        await CarpAuthService().authenticate(),
                    icon: Icon(Icons.login),
                    label: Text(
                      'LOGIN',
                      style: TextStyle(fontSize: 35),
                    ),
                  );
                } else {
                  return TextButton.icon(
                    onPressed: () => CarpAuthService().logout(),
                    icon: Icon(Icons.logout),
                    label: Text(
                      'LOGOUT',
                      style: TextStyle(fontSize: 35),
                    ),
                  );
                }
              }),
          TextButton.icon(
            onPressed: () => bloc.getStudyInvitation(context),
            icon: Icon(Icons.mail),
            label: Text(
              'GET STUDY',
              style: TextStyle(fontSize: 35),
            ),
          ),
          StreamBuilder(
            stream: CarpAuthService().authStateChanges,
            builder: (BuildContext context, AsyncSnapshot<AuthEvent> event) =>
                Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
              child: Text(
                (CarpAuthService().authenticated)
                    ? 'Authenticated as ${CarpAuthService().currentUser.firstName} ${CarpAuthService().currentUser.lastName}'
                    : 'Not authenticated',
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      )),
    );
  }
}

class AppBLoC {
  ActiveParticipationInvitation? _invitation;
  String? get studyId => _invitation?.studyId;
  String? get studyDeploymentId => _invitation?.studyDeploymentId;

  CarpApp? _app;
  CarpApp? get app => _app;
  Uri uri = Uri(
    scheme: 'https',
    host: 'dev.carp.dk',
    pathSegments: [
      'auth',
      'realms',
      'Carp',
    ],
  );

  bool get authenticated => currentUser != null;

  CarpUser? currentUser;

  late CarpApp mockCarpApp = CarpApp(
    name: "CAWS @ DTU",
    uri: uri.replace(pathSegments: []),
  );

  late CarpAuthProperties authProperties = CarpAuthProperties(
    authURL: uri,
    clientId: 'studies-app',
    redirectURI: Uri.parse('carp-studies-auth://auth'),
    discoveryURL: uri.replace(pathSegments: [
      ...uri.pathSegments,
    ]),
  );

  Future<void> init() async {
    await CarpAuthService().configure(authProperties);
    CarpService().configure(mockCarpApp);
  }

  void dispose() async {}

  Future<ActiveParticipationInvitation?> getStudyInvitation(
      BuildContext context) async {
    // configure a participant service based on the carp service already configured
    CarpParticipationService().configureFrom(CarpService());
    _invitation = await CarpParticipationService().getStudyInvitation(context);
    print('CARP Study Invitation: $_invitation');
    // check that the app has been updated to reflect the study id and deployment id
    print(
        'Study ID: ${app?.studyId}, Deployment ID: ${app?.studyDeploymentId}');
    return _invitation;
  }
}

final bloc = AppBLoC();
