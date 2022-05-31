# CARP Mobile Sensing App

The CARP Mobile Sensing App provides an example on how to use the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package.
The app sets up a `Study` that starts a set of `Probe`s and visualizes the data. The UI of the app is shown below, showing
(from left to right) the Study Visualization page, the Probe List page, and the Data Visualization page (the latter is not implemented yet).

![Study Visualization page](documentation/study_viz.jpeg) 
![Probe List page](documentation/probe_list.jpeg) 
![Data Visualization page](documentation/data_viz.jpeg) 


The architecture of the app is illustrated below. It follows the [BLoC architecture](https://medium.com/flutterpub/architecting-your-flutter-project-bd04e144a8f1),
which is recommended by the [Flutter Team](https://www.youtube.com/watch?v=PLHln7wHgPE).


![Bloc Architecture](documentation/architecture.png)

The basic architecture holds a singleton `Sensing` class responsible for handling sensing via the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package. 
All data is handled by a singleton `BloC` which is the only way the UI models can access and modify
data or initiate life cycle events (like pausing and resuming sensing).
All data to be shown in the UI are handled by (UI) models, and finally each screen (`Widget`)
is implemented as a [`StatefulWidget`](https://docs.flutter.io/flutter/widgets/StatefulWidget-class.html)
in Flutter. Each UI widget only knows its corresponding model
and the model knows the BloC. **NO** data or control flows between the UI and the Bloc or Sensing layer.

## Sensing BLoC

Since the BLoC is the controller of the entire app, let's start with this class.

````dart
class SensingBLoC {
  static const String STUDY_DEPLOYMENT_ID_KEY = 'study_deployment_id';

  String? _studyDeploymentId;

  /// Returns the study deployment id for the currently running deployment.
  /// Returns the deployment id cached locally on the phone (if available).
  /// Returns `null` if no study is deployed (yet).
  String? get studyDeploymentId => (_studyDeploymentId ??=
      Settings().preferences?.getString(STUDY_DEPLOYMENT_ID_KEY));

  /// Set the study deployment id for the currently running deployment.
  /// This study deployment id will be cached locally on the phone.
  set studyDeploymentId(String? id) {
    assert(
        id != null,
        'Cannot set the study deployment id to null in Settings. '
        "Use the 'eraseStudyDeployment()' method to erase study deployment information.");
    _studyDeploymentId = id;
    Settings().preferences?.setString(STUDY_DEPLOYMENT_ID_KEY, id!);
  }

  /// Erase all study deployment information cached locally on this phone.
  Future<void> eraseStudyDeployment() async {
    _studyDeploymentId = null;
    await Settings().preferences!.remove(STUDY_DEPLOYMENT_ID_KEY);
  }

  SmartphoneDeployment? get deployment => Sensing().controller?.deployment;
  StudyDeploymentModel? _model;

  /// What kind of deployment are we running - local or CARP?
  DeploymentMode deploymentMode = DeploymentMode.LOCAL;

  /// The preferred format of the data to be uploaded according to
  /// [NameSpace]. Default using the [NameSpace.CARP].
  String dataFormat = NameSpace.CARP;

  /// Is sensing running, i.e. has the study executor been resumed?
  bool get isRunning =>
      (Sensing().controller != null) &&
      Sensing().controller!.executor!.state == ExecutorState.resumed;

  /// Get the study for this app.
  StudyDeploymentModel get studyDeploymentModel =>
      _model ??= StudyDeploymentModel(deployment!);

  /// Get a list of running probes
  Iterable<ProbeModel> get runningProbes =>
      Sensing().runningProbes.map((probe) => ProbeModel(probe));

  /// Get a list of running devices
  Iterable<DeviceModel> get runningDevices =>
      Sensing().runningDevices!.map((device) => DeviceModel(device));

  void connectToDevice(DeviceModel device) {
    Sensing().client?.deviceController.devices[device.type!]!.connect();
  }

  Future initialize({
    DeploymentMode deploymentMode = DeploymentMode.LOCAL,
    String dataFormat = NameSpace.CARP,
  }) async {
    await Settings().init();
    Settings().debugLevel = DebugLevel.DEBUG;
    this.deploymentMode = deploymentMode;
    this.dataFormat = dataFormat;

    info('$runtimeType initialized');
  }

  void resume() async => Sensing().controller?.executor?.resume();
  void pause() => Sensing().controller?.executor?.pause();
  void stop() async => Sensing().controller?.stop();
  void dispose() async => Sensing().controller?.stop();
}

final bloc = SensingBLoC();
````

The BLoC basically plays two roles; it accesses data by returning model objects (such as `ProbeModel`)
and it exposes business logic like the sensing life cycle events (`initialize`, `resume`, `pause`, etc.).
Note that the singleton `bloc` variable is instantiated, which makes the BLoC accessible in the entire app.

Set up and configuration of sensing is done in the [`Sensing`](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/apps/carp_mobile_sensing_app/lib/src/sensing/sensing.dart) class. 
Depending on the "deploymenet mode" (local or using CARP), sensing is initialized using the [`LocalStudyProtocolManager`](https://github.com/cph-cachet/carp.sensing-flutter/blob/master/apps/carp_mobile_sensing_app/lib/src/sensing/local_study_protocol_mananger.dart) or the [`CustomProtocolDeploymentService`](https://pub.dev/documentation/carp_backend/latest/carp_backend/CustomProtocolDeploymentService-class.html), respectivly. 



implements a [`Study`](https://pub.dartlang.org/documentation/carp_mobile_sensing/latest/core/Study-class.html) and sets up the sensing according to the
[documentation](https://github.com/cph-cachet/carp.sensing-flutter/wiki) of the [`carp_mobile_sensing`](https://pub.dartlang.org/packages/carp_mobile_sensing) package.

 ## UI Models
 
 In this CARP Mobile Sensing App we use one UI Model for each UI Widget.
 For example, the UI Model `StudyModel` serves the UI Widget `StudyVisualization`.
 The main reposibility of the UI Model is to provide access to data (both getter and setters), 
 which is done via the BLoC.

The `StudyModel` class looks like this:

`````dart
class StudyModel {
  Study study;

  String get name => study.name;
  String get description => study.description ?? 'No description available.';
  Image get image => Image.asset('images/study.png');
  String get userID => study.userId;
  String get samplingStrategy => study.samplingStrategy.toString();
  String get dataEndpoint => study.dataEndPoint.toString();

  /// Events on the state of the study executor
  Stream<ProbeState> get studyExecutorStateEvents => bloc.sensing.controller.executor.stateEvents;

  /// Current state of the study executor (e.g., resumed, paused, ...)
  ProbeState get studyState => bloc.sensing.controller.executor.state;

  /// Get all sampling events (i.e. all [Datum] objects being collected).
  Stream<Datum> get samplingEvents => bloc.sensing.controller.events;

  /// The total sampling size so far since this study was started.
  int get samplingSize => bloc.sensing.controller.samplingSize;

  StudyModel(this.study)
      : assert(study != null, 'A StudyModel must be initialized with a real Study.'),
        super();
}
`````

In this model there are only data **getters**, since in the current version of the app, you
cannot change a study once it is running. However, if modification of a study was to be 
supported, then **setter** methods would be implemented in the model as well.
For example, the following method would enable modifying the study name.

````dart
void set name(String name) {
  ...
}
````

## UI Widgets

The final layer is the UI widgets. 
Each UI widget takes in its constructor its corresponding UI model. 
For example, the `StudyVisualization` widget's `State` takes a `StudyModel` in its constructor:

`````dart
class StudyVisualization extends StatefulWidget {
  const StudyVisualization({Key key}) : super(key: key);

  _StudyVizState createState() => _StudyVizState(bloc.study);
}

class _StudyVizState extends State<StudyVisualization> {
  final StudyModel study;

  _StudyVizState(this.study) : super();

  @override
  Widget build(BuildContext context) {
    ... 
  }
}
`````

In this way, the `study` is available in the entire UI Widget. 
This allow us to access data and show it in the UI. For example, to show the study name and image
this code is used:

````dart
 FlexibleSpaceBar(
    title: Text(study.name),
    background: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        study.image,
      ],
    ),
 ),

````

More sophisticated (reactive) UI implementation can also be done. For example, to show the
counter showing sampling size the following `StreamBuilder` is used.

`````dart
 StreamBuilder<Datum>(
    stream: study.samplingEvents,
    builder: (context, AsyncSnapshot<Datum> snapshot) {
      return Text('Sample Size: ${study.samplingSize}');
    })
`````

