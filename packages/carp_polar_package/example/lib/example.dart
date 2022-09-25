import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_polar_package/carp_polar_package.dart';
import 'package:polar/polar.dart';

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
  SamplingPackageRegistry().register(PolarSamplingPackage());

  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Polar Sensing Example',
  );

  // define which devices are used for data collection - both phone and eSense
  var phone = Smartphone();
  var polar = PolarDevice(
    roleName: 'hr-sensor',
    identifier: '1C709B20',
    name: 'H10',
    polarDeviceType: PolarDeviceType.H10,
  );

  protocol
    ..addMasterDevice(phone)
    ..addConnectedDevice(polar);

  // Add a background task that immediately starts collecting step counts,
  //ambient light, screen activity, and battery level from the phone.
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      BackgroundTask()
        ..addMeasure(Measure(type: SensorSamplingPackage.PEDOMETER))
        ..addMeasure(Measure(type: SensorSamplingPackage.LIGHT))
        ..addMeasure(Measure(type: DeviceSamplingPackage.SCREEN))
        ..addMeasure(Measure(type: DeviceSamplingPackage.BATTERY)),
      phone);

  // Add a background task that immediately starts collecting HR and ECG data
  // from the Polar device.
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      BackgroundTask()
        ..addMeasure(Measure(type: PolarSamplingPackage.POLAR_HR))
        ..addMeasure(Measure(type: PolarSamplingPackage.POLAR_ECG)),
      polar);
}
