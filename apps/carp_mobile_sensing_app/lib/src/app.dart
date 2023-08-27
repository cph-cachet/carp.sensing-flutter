part of mobile_sensing_app;

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: LoadingPage(),
    );
  }
}

class LoadingPage extends StatelessWidget {
  /// This methods is used to initialize the app and the sensing.
  ///
  /// If using CAWS, this method also initialize the CAWS backend,
  /// authenticate the user, and gets the study invitation from CAWS.
  ///
  /// Returns true when done.
  Future<bool> init(BuildContext context) async {
    // Initialize and use the CAWS backend if not in local deployment mode
    if (bloc.deploymentMode != DeploymentMode.local) {
      await CarpBackend().initialize();
      await CarpBackend().authenticate(context, username: 'jakob@bardram.net');

      // Check if there is a local deployment id.
      // If not, get a deployment id based on an invitation.
      if (bloc.studyDeploymentId == null) {
        await CarpBackend().getStudyInvitation(context);
      }

      // Make sure that CarpService knows the study and deployment ids
      CarpService().app?.studyId = bloc.studyId;
      CarpService().app?.studyDeploymentId = bloc.studyDeploymentId;
    }

    await bloc.sensing.initialize();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(context),
      builder: (context, snapshot) => (!snapshot.hasData)
          ? Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Center(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [CircularProgressIndicator()],
              )))
          : CarpMobileSensingApp(key: key),
    );
  }
}

class CarpMobileSensingApp extends StatefulWidget {
  CarpMobileSensingApp({Key? key}) : super(key: key);
  @override
  CarpMobileSensingAppState createState() => CarpMobileSensingAppState();
}

class CarpMobileSensingAppState extends State<CarpMobileSensingApp> {
  int _selectedIndex = 0;

  final _pages = [
    StudyDeploymentPage(),
    ProbesList(),
    // DataVisualization(),
    DevicesList(),
  ];

  @override
  void dispose() {
    bloc.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Study'),
          BottomNavigationBarItem(icon: Icon(Icons.adb), label: 'Probes'),
          // BottomNavigationBarItem(icon: Icon(Icons.show_chart), label: 'Data'),
          BottomNavigationBarItem(icon: Icon(Icons.watch), label: 'Devices'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: restart,
        tooltip: 'Restart study & probes',
        child: bloc.isRunning ? Icon(Icons.pause) : Icon(Icons.play_arrow),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void restart() {
    setState(() {
      if (bloc.isRunning) {
        bloc.stop();
      } else {
        bloc.start();
      }
    });
  }
}
