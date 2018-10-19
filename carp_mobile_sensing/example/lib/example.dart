import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// This is the code for the very minimal example used in the README.md file.
void example() {
  // Instantiate a new study
  Study study = new Study("1234", "user@dtu.dk", name: "Test study #1");

  // Setting the data endpoint to print to the console
  study.dataEndPoint = new DataEndPoint(DataEndPointType.PRINT);

  // Create a parallel task to hold measures
  Task task = new ParallelTask("Simple Task");

  // Create a battery and location measures and add them to the task
  // Both are listening on events from changes from battery and location
  task.addMeasure(new BatteryMeasure(ProbeRegistry.BATTERY_MEASURE));
  task.addMeasure(new LocationMeasure(ProbeRegistry.LOCATION_MEASURE));

  // Create a Measure for collecting text messages
  // Add some specific configuration to it, which later can be used by the probe.
  Measure measure = new Measure(ProbeRegistry.TEXT_MESSAGE_MEASURE);
  measure.configuration["store_message_body"] = "false";
  task.addMeasure(measure);

  // Create an executor that can execute this study, initialize it, and start it.
  StudyExecutor executor = new StudyExecutor(study);
  executor.initialize();
  executor.start();
}
