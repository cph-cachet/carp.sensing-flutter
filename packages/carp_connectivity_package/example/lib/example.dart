import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_connectivity_package/connectivity.dart';

/// This is a very simple example of how this sampling package is used with
/// CARP Mobile Sensing (CAMS).
/// NOTE, however, that the code below will not run.
/// See the documentation on how to use CAMS: https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main() async {
  // Register this sampling package before using its measures
  SamplingPackageRegistry().register(ConnectivitySamplingPackage());

  // Create a study protocol
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Connectivity Sensing Example',
  );

  // Define which devices are used for data collection
  // In this case, its only this smartphone
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

  // If you want to scan for nearby bluetooth devices, you can use a
  // [BluetoothScanPeriodicSamplingConfiguration] to configure the scan.
  // This will scan for bluetooth devices every 10 minutes for 10 seconds.
  // You can also filter by remoteIds and services.
  protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(measures: [
        Measure(
            type: ConnectivitySamplingPackage.BLUETOOTH,
            samplingConfiguration: BluetoothScanPeriodicSamplingConfiguration(
              interval: const Duration(minutes: 10),
              duration: const Duration(seconds: 10),
              withRemoteIds: ['123', '456'],
              withServices: ['service1', 'service2'],
            ))
      ]),
      phone);

  // If you want to collect iBeacon measurements, you can use a
  // [BeaconRangingPeriodicSamplingConfiguration] to configure the scan.
  // This will scan for iBeacons in the specified regions which are closer than
  // 2 meters. The regions are specified by their identifier and UUID.
  //
  // See the dchs_flutter_beacon plugin for more information on how to set up
  // iBeacon regions.
  protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(measures: [
        Measure(
            type: ConnectivitySamplingPackage.BEACON,
            samplingConfiguration: BeaconRangingPeriodicSamplingConfiguration(
              beaconDistance: 2, // 2 meters
              beaconRegions: [
                BeaconRegion(
                  identifier: 'region1',
                  uuid: '12345678-1234-1234-1234-123456789012',
                ),
                BeaconRegion(
                  identifier: 'region2',
                  uuid: '12345678-1234-1234-1234-123456789012',
                ),
              ],
            ))
      ]),
      phone);
}
