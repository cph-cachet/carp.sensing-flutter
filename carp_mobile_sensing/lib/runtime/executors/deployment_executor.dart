/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of '../runtime.dart';

/// A [SmartphoneDeploymentExecutor] is responsible for executing a [SmartphoneDeployment].
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

    _group.add(_manualMeasurementController.stream);

    for (var taskControl in configuration!.taskControls) {
      // get the trigger and task based on the trigger id and task name
      final trigger = configuration!.triggers['${taskControl.triggerId}']!;
      final task = configuration!.getTaskByName(taskControl.taskName)!;

      TaskControlExecutor executor;

      // a TriggeredAppTaskExecutor need BOTH a [Schedulable] trigger and an [AppTask]
      // to schedule
      if (trigger is Schedulable && task is AppTask) {
        executor = AppTaskControlExecutor(taskControl, trigger, task);
      } else {
        // all other cases we use the normal background triggering relying on the app
        // running in the background
        executor = TaskControlExecutor(taskControl, trigger, task);
      }

      executor.initialize(taskControl, deployment!);
      addExecutor(executor);

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
    }
    return true;
  }

  @override
  Future<void> onDispose() async {
    await super.onDispose();

    // remove the executors from the device managers
    for (var element in executors) {
      TaskControlExecutor executor = element as TaskControlExecutor;

      if (executor.taskControl.destinationDeviceRoleName != null) {
        DeviceConfiguration? targetDevice =
            configuration?.getDeviceFromRoleName(
                executor.taskControl.destinationDeviceRoleName!);
        if (targetDevice != null) {
          DeviceController()
              .getDevice(targetDevice.type)
              ?.executors
              .remove(executor);
        }
      }
    }

    // executors.clear();
  }

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
