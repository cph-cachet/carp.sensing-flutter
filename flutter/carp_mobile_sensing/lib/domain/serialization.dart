/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// This is the base class for all JSON serializable objects.
abstract class Serializable {
  String $;

  Serializable() {
    $ = this.runtimeType.toString();
    FromJsonFactory.init();
  }

  //static Function get fromJsonFunction {}

  /// Use this method to register a custom fromJson function for this class
  /// in the [FromJsonFactory].
  _registerFromJson(Function fromJsonFunction) =>
      FromJsonFactory.registerFromJsonFunction(this.runtimeType.toString(), fromJsonFunction);

  /// Return a JSON encoding of this object.
  Map<String, dynamic> toJson();
}

class FromJsonFactory {
  static final bool _isInitialized = false;
  static final Map<String, Function> _registry = new Map<String, Function>();

  static registerFromJsonFunction(String type, Function f) => _registry[type] = f;

  static Serializable fromJson(String type, Map<String, dynamic> json) => Function.apply(_registry[type], [json]);

  static void init() {
    if (_isInitialized) return;

    //TODO : This should be done using reflection or a build_runner script that can auto-generate this.
    registerFromJsonFunction("Study", Study.fromJsonFunction);
    registerFromJsonFunction("DataEndPoint", DataEndPoint.fromJsonFunction);
    registerFromJsonFunction("Task", Task.fromJsonFunction);
    registerFromJsonFunction("ParallelTask", ParallelTask.fromJsonFunction);
    registerFromJsonFunction("SequentialTask", SequentialTask.fromJsonFunction);
    registerFromJsonFunction("Measure", Measure.fromJsonFunction);
    registerFromJsonFunction("ProbeMeasure", ProbeMeasure.fromJsonFunction);
    registerFromJsonFunction("PollingProbeMeasure", PollingProbeMeasure.fromJsonFunction);
    registerFromJsonFunction("SensorMeasure", SensorMeasure.fromJsonFunction);
    registerFromJsonFunction("ConnectivityMeasure", ConnectivityMeasure.fromJsonFunction);
    registerFromJsonFunction("BluetoothMeasure", BluetoothMeasure.fromJsonFunction);
  }
}
