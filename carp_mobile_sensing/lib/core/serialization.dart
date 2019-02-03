/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of core;

/// This is the base class for all JSON serializable objects.
abstract class Serializable {
  static const String CLASS_IDENTIFIER = "c__";

  /// The runtime class name (type) of this object.
  /// Used for deserialization from JSON objects.
  String c__;

  Serializable() {
    c__ = this.runtimeType.toString();
    FromJsonFactory._();
  }

  /// Use this method to register a custom fromJson function for this class
  /// in the [FromJsonFactory].
  registerFromJson(Function fromJsonFunction) =>
      FromJsonFactory.registerFromJsonFunction(this.runtimeType.toString(), fromJsonFunction);

  /// Return a JSON encoding of this object.
  Map<String, dynamic> toJson();
}

/// A factory class that holds [fromJson] functions to be used in JSON deserialization.
class FromJsonFactory {
  static bool _isInitialized = false;
  static final Map<String, Function> _registry = new Map<String, Function>();

  /// To be used for registering [fromJsonFunction] functions to this Factory.
  /// Should be done for each [type] of class that needs to be deserialized from JSON
  /// to a CARP Flutter class.
  static registerFromJsonFunction(String type, Function f) => _registry[type] = f;

  /// Deserialize [json] of the specified class [type].
  static Serializable fromJson(String type, Map<String, dynamic> json) => Function.apply(_registry[type], [json]);

  static void _() {
    if (_isInitialized) return;

    //TODO : This should be done using reflection or a build_runner script that can auto-generate this.
    registerFromJsonFunction("Study", Study.fromJsonFunction);
    registerFromJsonFunction("DataEndPoint", DataEndPoint.fromJsonFunction);
    registerFromJsonFunction("FileDataEndPoint", FileDataEndPoint.fromJsonFunction);
    registerFromJsonFunction("Task", Task.fromJsonFunction);
    registerFromJsonFunction("ParallelTask", ParallelTask.fromJsonFunction);
    registerFromJsonFunction("SequentialTask", SequentialTask.fromJsonFunction);

    registerFromJsonFunction("MeasureType", MeasureType.fromJsonFunction);
    registerFromJsonFunction("Measure", Measure.fromJsonFunction);
    registerFromJsonFunction("PeriodicMeasure", PeriodicMeasure.fromJsonFunction);
//    registerFromJsonFunction("AudioMeasure", AudioMeasure.fromJsonFunction);
//    registerFromJsonFunction("NoiseMeasure", NoiseMeasure.fromJsonFunction);
//    registerFromJsonFunction("WeatherMeasure", WeatherMeasure.fromJsonFunction);
//    registerFromJsonFunction("PhoneLogMeasure", PhoneLogMeasure.fromJsonFunction);

    _isInitialized = true;
  }
}
