import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is the code for the very minimal example used in the README.md file.
void example() {
  // Instantiate a new study
  Study study = new Study("1234", "bardram", name: "Test study #1");

  // Setting the data endpoint to print to the console
  study.dataEndPoint = new DataEndPoint(DataEndPointType.PRINT);

  // Create a task to hold measures
  Task task = new Task("Simple Task");

  // Create a battery and location measures and add them to the task
  // Both are listening on events from changes from battery and location
  task.addMeasure(new BatteryMeasure(ProbeRegistry.BATTERY_MEASURE));
  task.addMeasure(new LocationMeasure(ProbeRegistry.LOCATION_MEASURE));

  // Create an executor that can execute this study, initialize it, and start it.
  StudyExecutor executor = new StudyExecutor(study);
  executor.initialize();
  executor.start();
}
