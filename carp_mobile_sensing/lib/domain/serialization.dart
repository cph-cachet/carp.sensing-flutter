/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// This is the base class for all JSON serializable objects.
abstract class Serializable {
  //static const String CLASS_IDENTIFIER = "c__";
  static const String CLASS_IDENTIFIER = "\$type";

  /// The runtime class name (type) of this object.
  /// Used for deserialization from JSON objects.
  String $type;

  Serializable() {
    $type = this.runtimeType.toString();
    FromJsonFactory._();
  }

  /// Use this method to register a custom fromJson function for this class
  /// in the [FromJsonFactory].
  registerFromJson(Function fromJsonFunction) => FromJsonFactory.registerFromJsonFunction(this.runtimeType.toString(), fromJsonFunction);

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
    registerFromJsonFunction("AutomaticTask", AutomaticTask.fromJsonFunction);
    registerFromJsonFunction("AppTask", AppTask.fromJsonFunction);

    registerFromJsonFunction("Trigger", Trigger.fromJsonFunction);
    registerFromJsonFunction("ImmediateTrigger", ImmediateTrigger.fromJsonFunction);
    registerFromJsonFunction("DelayedTrigger", DelayedTrigger.fromJsonFunction);
    registerFromJsonFunction("PeriodicTrigger", PeriodicTrigger.fromJsonFunction);
    registerFromJsonFunction("ScheduledTrigger", ScheduledTrigger.fromJsonFunction);
    registerFromJsonFunction("Time", Time.fromJsonFunction);
    registerFromJsonFunction("RecurrentScheduledTrigger", RecurrentScheduledTrigger.fromJsonFunction);
    registerFromJsonFunction("SamplingEventTrigger", SamplingEventTrigger.fromJsonFunction);
    // note that ConditionalSamplingEventTrigger can't be de/serialized to/from JSON - see documentation of it.
    // registerFromJsonFunction("ConditionalSamplingEventTrigger", ConditionalSamplingEventTrigger.fromJsonFunction);

    registerFromJsonFunction("MeasureType", MeasureType.fromJsonFunction);
    registerFromJsonFunction("Measure", Measure.fromJsonFunction);
    registerFromJsonFunction("PeriodicMeasure", PeriodicMeasure.fromJsonFunction);
    registerFromJsonFunction("MarkedMeasure", MarkedMeasure.fromJsonFunction);

    _isInitialized = true;
  }
}
