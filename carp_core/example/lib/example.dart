import 'package:carp_core/carp_core.dart';

// This example tries to mimic the example from the carp_core Kotlin
// example at https://github.com/cph-cachet/carp.core-kotlin/tree/master
//
// It is a very simple example. Much better examples are found at the
// documentation of CARP Mobile Sensing at
//
//  * https://github.com/cph-cachet/carp.sensing-flutter
//  * https://github.com/cph-cachet/carp.sensing-flutter/wiki
void main(List<String> args) async {
  // Create a new study protocol.
  ProtocolOwner owner = ProtocolOwner();
  StudyProtocol protocol =
      StudyProtocol(owner: owner, name: "Track patient movement");

  // Define which devices are used for data collection.
  Smartphone phone = Smartphone(
    name: 'SM-A320FL',
    roleName: 'phone',
  );
  protocol.addMasterDevice(phone);

  // Define what needs to be measured, on which device, when.
  List<Measure> measures = [
    Measure(type: 'dk.cachet.geolocation'),
    Measure(type: 'dk.cachet.stepcount'),
  ];

  TaskDescriptor startMeasures = ConcurrentTask(
    name: "Start measures",
    measures: measures,
  );
  protocol.addTriggeredTask(Trigger(), startMeasures, phone);

  // JSON output of the study protocol, compatible with the rest of the CARP infrastructure.
  String json = toJsonString(protocol.toJson());
  print(json);
}
