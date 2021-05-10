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

  // Create a study protocol using a local file to store data
  CAMSStudyProtocol protocol = CAMSStudyProtocol()
    ..name = 'Track patient movement'
    ..owner = ProtocolOwner(
      id: 'AB',
      name: 'Alex Boyon',
      email: 'alex@uni.dk',
    );

  // define which devices are used for data collection - both phone and eSense
  Smartphone phone = Smartphone(roleName: 'The main phone');
  DeviceDescriptor eSense = ESenseDevice(roleName: 'The left eSense earplug');

  protocol
    ..addMasterDevice(phone)
    ..addConnectedDevice(eSense);

  // Add an automatic task that immediately starts collecting
  // step counts, ambient light, screen activity, and battery level
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..addMeasures(SensorSamplingPackage().common.getMeasureList(
          types: [
            SensorSamplingPackage.PEDOMETER,
            SensorSamplingPackage.LIGHT,
            DeviceSamplingPackage.SCREEN,
            DeviceSamplingPackage.BATTERY,
          ],
        )),
      phone);

  // Add an automatic task that immediately starts collecting eSense button and
  // sensor events from the eSense device.
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..addMeasures([
          ESenseMeasure(
              type: ESenseSamplingPackage.ESENSE_BUTTON,
              name: 'eSense - Button',
              description: "Collects button event from the eSense device",
              deviceName: 'eSense-0332'),
          ESenseMeasure(
              type: ESenseSamplingPackage.ESENSE_SENSOR,
              name: 'eSense - Sensor',
              description:
                  "Collects movement data from the eSense inertial measurement unit (IMU) sensor",
              deviceName: 'eSense-0332',
              samplingRate: 5),
        ]),
      eSense);
}
