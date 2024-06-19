part of '../../main.dart';

/// A view model for the [StudyDeploymentPage] view.
class StudyDeploymentViewModel {
  SmartphoneDeployment deployment;

  String get title => deployment.studyDescription?.title ?? '';
  String get description =>
      deployment.studyDescription?.description ?? 'No description available.';
  Image get image => Image.asset('assets/study.png');
  String get studyDeploymentId => deployment.studyDeploymentId;
  String get deviceRoleName => deployment.deviceConfiguration.roleName;
  String get userID => deployment.userId ?? '';
  String get dataEndpoint => deployment.dataEndPoint.toString();

  /// Events on the state of the study executor
  Stream<ExecutorState> get studyExecutorStateEvents =>
      bloc.sensing.controller!.executor.stateEvents;

  /// Current state of the study executor (e.g., started, stopped, ...)
  ExecutorState get studyState => bloc.sensing.controller!.executor.state;

  /// Get all sensing events (i.e. all [Measurement] objects being collected).
  Stream<Measurement> get measurements =>
      bloc.sensing.controller?.measurements ?? Stream.empty();

  /// The total sampling size so far since this study was started.
  int get samplingSize => bloc.sensing.controller?.samplingSize ?? 0;

  StudyDeploymentViewModel(this.deployment) : super();
}
