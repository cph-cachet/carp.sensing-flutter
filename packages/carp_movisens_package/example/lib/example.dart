import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_movisens_package/carp_movisens_package.dart';
import 'package:movisens_flutter/movisens_flutter.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(MovisensSamplingPackage());

  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Movisens Example',
  );

  // define which devices are used for data collection - both phone and Movisens
  Smartphone phone = Smartphone();
  MovisensDevice movisens = MovisensDevice(
    roleName: 'movisens-ecg',
    address: '88:6B:0F:CD:E7:F2',
    sensorLocation: SensorLocation.chest,
    gender: Gender.male,
    sensorName: 'Sensor 02655',
    height: 175,
    weight: 75,
    age: 25,
  );

  protocol
    ..addMasterDevice(phone)
    ..addConnectedDevice(movisens);

  // adding a movisens measure
  protocol.addTriggeredTask(
      ImmediateTrigger(),
      BackgroundTask(name: 'Movisens Task')
        ..addMeasure(Measure(type: MovisensSamplingPackage.MOVISENS)),
      movisens);
}
