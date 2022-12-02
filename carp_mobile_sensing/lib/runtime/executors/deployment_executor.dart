/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of runtime;

/// The [SmartphoneDeploymentExecutor] is responsible for executing a [SmartphoneDeployment].
/// For each task control in this deployment, it starts a [TaskControlExecutor].
///
/// Note that the [SmartphoneDeploymentExecutor] in itself is an [Executor] and hence work
/// as a 'super executor'. This - amongst other things - imply that you can listen
/// to all collected measurements from the [measurements] stream.
class SmartphoneDeploymentExecutor
    extends AggregateExecutor<SmartphoneDeployment> {
  final StreamController<Measurement> _manualMeasurementController =
      StreamController.broadcast();

  @override
  bool onInitialize() {
    if (configuration == null) {
      warning(
          'Trying to initialize StudyDeploymentExecutor but the deployment configuration is null. Cannot initialize study deployment.');
      return false;
    }

    group.add(_manualMeasurementController.stream);

    for (var taskControl in configuration!.taskControls) {
      // get the trigger based on the trigger id
      TriggerConfiguration trigger =
          configuration!.triggers['${taskControl.triggerId}']!;
      // get the task based on the task name
      TaskConfiguration task =
          configuration!.getTaskByName(taskControl.taskName)!;

      TaskControlExecutor executor = ExecutorFactory().getTaskControlExecutor(
        taskControl,
        trigger,
        task,
      );

      executor.initialize(taskControl, deployment!);

      // let the device manger know about this executor
      if (taskControl.destinationDeviceRoleName != null) {
        DeviceConfiguration? targetDevice = configuration
            ?.getDeviceFromRoleName(taskControl.destinationDeviceRoleName!);
        if (targetDevice != null) {
          DeviceController()
              .getDevice(targetDevice.type)
              ?.executors
              .add(executor);
        }
      }

      group.add(executor.measurements);
      executors.add(executor);
    }
    return true;
  }

  // /// Get the aggregated stream of [DataPoint] data sampled by all executors
  // /// and probes in this study deployment.
  // ///
  // /// Ensures that the `userId` and `studyId` is correctly set in the
  // /// [DataPointHeader] based on the [deployment] configuration.
  // @override
  // Stream<Measurements> get measurements => group.stream;
  // .map((measurement) => measurement
  //   ..carpHeader.studyId = deployment?.studyDeploymentId
  //   ..carpHeader.userId = deployment?.userId);

  /// Add a [DataPoint] object to the stream of events.
  void addMeasurement(Measurement measurement) =>
      _manualMeasurementController.add(measurement);

  /// Add a error to the stream of events.
  void addError(Object error, [StackTrace? stacktrace]) =>
      _manualMeasurementController.addError(error, stacktrace);

  /// A list of the running probes in this study deployment executor.
  List<Probe> get probes {
    List<Probe> probes = [];

    for (var executor in executors) {
      if (executor is TaskControlExecutor) {
        probes.addAll(executor.probes);
      }
    }
    return probes;
  }

  /// Lookup all probes of type [type]. Returns an empty list if none are found.
  List<Probe> lookupProbe(String type) {
    List<Probe> retrainedProbes = probes;
    retrainedProbes.retainWhere((probe) => probe.type == type);
    return retrainedProbes;
  }
}
