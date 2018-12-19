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
    _study = Study("1234", "bardram", name: "bardram study");
    _study.dataEndPoint = FileDataEndPoint()
      ..bufferSize = 50 * 1000
      ..zip = true
      ..encrypt = false;

    _study.addTask(TaskDescriptor('1st Taks')
      ..addMeasure(Measure(DataFormat('carp', 'location')))
      ..addMeasure(Measure(DataFormat('carp', 'noise'))));

    _study.addTask(ParallelTask('2nd Taks')
      ..addMeasure(Measure(DataFormat('carp', 'accelerometer')))
      ..addMeasure(Measure(DataFormat('carp', 'light'))));

    _study.addTask(SequentialTask('3rd Taks')
      ..addMeasure(Measure(DataFormat('carp', 'sound')))
      ..addMeasure(Measure(DataFormat('carp', 'weather'))));
  }

  return _study;
}
