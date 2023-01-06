import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_connectivity_package/connectivity.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // register this sampling package before using its measures
  SamplingPackageRegistry().register(ConnectivitySamplingPackage());

  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Context Sensing Example',
  );

  // define which devices are used for data collection
  // in this case, its only this smartphone
  Smartphone phone = Smartphone();
  protocol.addPrimaryDevice(phone);

  // Add an automatic task that immediately starts collecting connectivity,
  // nearby bluetooth devices, and wifi information.
  protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(measures: [
        Measure(type: ConnectivitySamplingPackage.CONNECTIVITY),
        Measure(type: ConnectivitySamplingPackage.BLUETOOTH),
        Measure(type: ConnectivitySamplingPackage.WIFI),
      ]),
      phone);
}
