part of health_package;

/// A probe collecting health data from Apple Health or Google Health Connect.
///
/// Configuration of this probe is based on a [HealthSamplingConfiguration] which
/// again is a [HistoricSamplingConfiguration].
/// This means that when started, it will try to collect data back to the last
/// time data was collected.
/// Hence, this probe is suited for configuration using a trigger that
/// collects data on a regular basis. This could be a [PeriodicTrigger] or it
/// could be configured as an [AppTask] asking the user to collect the data
/// on a regular basis.
///
/// Note that even though this probe is a [StreamProbe], the health measure is a
/// one-time measure, which needs to be triggered to collect the data. The stream
/// probe is used since this probe can return a lot of health data, which need to
/// be streamed back to the mobile sensing framework.
class HealthProbe extends StreamProbe {
  final StreamController<Measurement> _ctrl = StreamController.broadcast();

  @override
  Stream<Measurement> get stream => _ctrl.stream;

  @override
  HealthSamplingConfiguration get samplingConfiguration =>
      super.samplingConfiguration as HealthSamplingConfiguration;

  @override
  HealthServiceManager get deviceManager =>
      super.deviceManager as HealthServiceManager;

  /// Check if the sampling configuration contains a valid list of [HealthDataType]
  /// for the current platform (iOS or Android).
  ///
  /// Removes any health data type(s) which are not supported on this platform.
  void validateHealthDataTypes() {
    List<HealthDataType> toRemove = [];
    for (var type in samplingConfiguration.healthDataTypes) {
      // is this type supported on the current platform?
      bool supported = (Platform.isIOS)
          ? dataTypesIOS.contains(type)
          : dataTypesAndroid.contains(type);

      if (!supported) {
        warning(
            "$runtimeType - Health data type '$type' is not supported on this platform "
            "(${Platform.operatingSystem}). "
            "Type is ignored.");
        toRemove.add(type);
      }
    }
    // remove all types we don't support on this platform
    samplingConfiguration.healthDataTypes
        .removeWhere((element) => toRemove.contains(element));
  }

  @override
  bool onInitialize() {
    validateHealthDataTypes();
    deviceManager.types = samplingConfiguration.healthDataTypes;
    return true;
  }

  /// Request permission to access health data specified in the [samplingConfiguration].
  @override
  Future<bool> requestPermissions() async {
    bool permission = await deviceManager.hasPermissions();
    if (!permission) await deviceManager.requestPermissions();
    return (await deviceManager.hasPermissions());
  }

  @override
  Future<bool> onStart() async {
    super.onStart();

    DateTime start = samplingConfiguration.lastTime ??
        DateTime.now().subtract(samplingConfiguration.past);
    DateTime end = DateTime.now();
    List<HealthDataType> healthDataTypes =
        samplingConfiguration.healthDataTypes;

    if (healthDataTypes.isEmpty) {
      warning(
          "$runtimeType - Trying to collect health data but the list of health data type to collect is empty. "
          "Did you add any types to the protocol which are available on this platform (iOS or Android)?");
    } else {
      debug(
          '$runtimeType - Collecting health data, types: $healthDataTypes, start: ${start.toUtc()}, end: ${end.toUtc()}');
      try {
        List<HealthDataPoint>? data =
            await deviceManager.service?.getHealthDataFromTypes(
                  start,
                  end,
                  healthDataTypes,
                ) ??
                [];
        debug(
            '$runtimeType - Retrieved ${data.length} health data points of types: $healthDataTypes');

        // Convert HealthDataPoint to measurements and add them to the stream.
        for (var data in data) {
          _ctrl.add(Measurement(
              sensorStartTime: data.dateFrom.microsecondsSinceEpoch,
              sensorEndTime: data.dateTo.microsecondsSinceEpoch,
              data: HealthData.fromHealthDataPoint(data)));
        }
      } catch (exception) {
        warning("$runtimeType - Error collecting health data. $exception");
        _ctrl.addError(exception);
        return false;
      }
    }
    return true;
  }
}
