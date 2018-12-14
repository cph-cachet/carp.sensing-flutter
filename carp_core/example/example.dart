import 'package:carp_core/carp_core.dart';
import 'dart:convert';

void main() {
  print("Creating a simple study");
  print(study);

  print("JSON serialization");
  print(_encode(study));
}

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

Study _study;
Study get study {
  if (_study == null) {
    _study = new Study("1234", "bardram", name: "bardram study");
    _study.dataEndPoint = new FileDataEndPoint();

    Task task = new Task("Generic task");
    final Measure m = new Measure(Measure.GENERIC_MEASURE, name: 'Generic measure');
    m.setConfiguration("generic_1", "8000");
    m.setConfiguration("generic_2", "abc");
    task.addMeasure(m);
    _study.addTask(task);

    Task _sensorTask = new ParallelTask("Sensor task");
    final ProbeMeasure am = new ProbeMeasure(Measure.PROBE_MEASURE);
    am.name = 'Accelerometer';
    am.setConfiguration("frequency", "8000");
    am.setConfiguration("duration", "500");
    _sensorTask.addMeasure(am);

    ListeningProbeMeasure gm = new ListeningProbeMeasure(Measure.LISTENING_MEASURE);
    gm.name = 'Gyroscope';
    gm.setConfiguration("frequency", "8000");
    _sensorTask.addMeasure(gm);

    _study.addTask(_sensorTask);

    Task _pedometerTask = new SequentialTask("Pedometer task");

    PollingProbeMeasure pm = new PollingProbeMeasure(Measure.POLLING_MEASURE);
    pm.name = 'Pedometer';
    pm.frequency = 8 * 1000; // once every 8 second
    _pedometerTask.addMeasure(pm);

    _study.addTask(_pedometerTask);

    _study.addTask(ParallelTask("Connectivity task"));
  }

  return _study;
}
