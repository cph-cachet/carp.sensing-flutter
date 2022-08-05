/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of esense;

/// This is the base class for this eSense sampling package.
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(ESenseSamplingPackage());
/// ```
class ESenseSamplingPackage implements SamplingPackage {
  static const String ESENSE_NAMESPACE = "${NameSpace.CARP}.esense";

  /// Measure type for continous collection of eSense button events (pressed/released).
  ///  * Event-based measure.
  ///  * Uses the [ESenseDevice] connected device for data collection.
  ///  * No sampling configuration needed.
  ///
  /// An example of a study protocol configuration might be:
  ///
  /// ```dart
  ///   // Add a background task that immediately starts collecting eSense button and sensor events from the eSense device.
  ///   protocol.addTriggeredTask(
  ///       ImmediateTrigger(),
  ///       BackgroundTask()
  ///         ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_BUTTON))
  ///         ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_SENSOR)),
  ///       eSense);
  /// ```
  static const String ESENSE_BUTTON = "$ESENSE_NAMESPACE.button";

  /// Measure type for continous collection of eSense sensor events
  /// (accelorometer & gyroscope).
  ///  * Event-based measure.
  ///  * Uses the [ESenseDevice] connected device for data collection.
  ///  * No sampling configuration needed.
  ///
  /// An example of a study protocol configuration might be:
  ///
  /// ```dart
  ///   // Add a background task that immediately starts collecting eSense button and sensor events from the eSense device.
  ///   protocol.addTriggeredTask(
  ///       ImmediateTrigger(),
  ///       BackgroundTask()
  ///         ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_BUTTON))
  ///         ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_SENSOR)),
  ///       eSense);
  /// ```
  static const String ESENSE_SENSOR = "$ESENSE_NAMESPACE.sensor";

  final DeviceManager _deviceManager = ESenseDeviceManager();

  @override
  List<String> get dataTypes => [ESENSE_BUTTON, ESENSE_SENSOR];

  @override
  Probe? create(String type) {
    switch (type) {
      case ESENSE_BUTTON:
        return ESenseButtonProbe();
      case ESENSE_SENSOR:
        return ESenseSensorProbe();
      default:
        return null;
    }
  }

  @override
  void onRegister() {
    FromJsonFactory().register(ESenseDevice());
  }

  @override
  List<Permission> get permissions => [
        Permission.location,
        Permission.microphone,
      ];

  @override
  String get deviceType => ESenseDevice.DEVICE_TYPE;

  @override
  DeviceManager get deviceManager => _deviceManager;

  @override
  SamplingSchema get samplingSchema => SamplingSchema();
}
