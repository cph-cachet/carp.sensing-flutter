import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_esense_package/esense.dart';

/// This is a very simple example of how this sampling package is used as part
/// of defining a study protocol in CARP Mobile Sensing (CAMS).
///
/// NOTE, however, that the code below will not run on it own. A study protocol
/// needs to be deployed and executed in the CAMS framework.
///
/// See the documentation on how to use CAMS:
/// https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(ESenseSamplingPackage());

  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'eSense Sensing Example',
  );

  // define which devices are used for data collection - both phone and eSense
  var phone = Smartphone();
  var eSense = ESenseDevice(
    deviceName: 'eSense-0223',
    samplingRate: 10,
  );

  protocol
    ..addMasterDevice(phone)
    ..addConnectedDevice(eSense);

  // Add a background task that immediately starts collecting step counts,
  //ambient light, screen activity, and battery level from the phone.
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      BackgroundTask()
        ..addMeasures([
          Measure(type: SensorSamplingPackage.PEDOMETER),
          Measure(type: SensorSamplingPackage.LIGHT),
          Measure(type: DeviceSamplingPackage.SCREEN),
          Measure(type: DeviceSamplingPackage.BATTERY),
        ]),
      phone);

  // Add a background task that immediately starts collecting eSense button and
  // sensor events from the eSense device.
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      BackgroundTask()
        ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_BUTTON))
        ..addMeasure(Measure(type: ESenseSamplingPackage.ESENSE_SENSOR)),
      eSense);
}
