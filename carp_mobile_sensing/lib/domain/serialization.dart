/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// This is the base class for all JSON serializable objects.
///
/// Using this class allow for implementing both serialization and
/// deserialization to/from JSON.
/// This is done using the [json_serializable](https://pub.dev/packages/json_serializable) package.
///
/// To support serialization, each subclass should implement the [toJson] method.
/// For example
///
///     Map<String, dynamic> toJson() => _$StudyToJson(this);
///
/// To support deserialization, each JSON object should inlude its [type]
/// (i.e., class name) information. In JSON this is identified by the
/// [CLASS_IDENTIFIER] static property.
/// In order to support de-serialization, the [fromJsonFunction] getter
/// and a class factory must be implemented. For example
///
///    Function get fromJsonFunction => _$StudyFromJson;
///    factory Study.fromJson(Map<String, dynamic> json) =>
///      FromJsonFactory()
///          .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
///
/// Finally, the [fromJsonFunction] must be registered on app startup (before
/// use of de-serialization) in the [FromJsonFactory] singleton, like this:
///
///        registerFromJsonFunction(Study._());
///
/// Note that any constructur will work, since only the `fromJsonFunction`
/// function is used. Hence, a private constructure like `Study._()` is fine.
abstract class Serializable {
  /// The identifier of the class type in JSON serialization.
  static const String CLASS_IDENTIFIER = '\$type';

  /// The runtime class name (type) of this object.
  /// Used for deserialization from JSON objects.
  String $type;

  /// Create a object that can be serialized to JSON.
  Serializable() {
    $type = runtimeType.toString();
  }

  /// The function which can convert a JSON string to an object of this type.
  Function get fromJsonFunction;

  /// Return a JSON encoding of this object.
  Map<String, dynamic> toJson();
}

/// A factory class that holds [fromJson] functions to be used in JSON
/// deserialization.
class FromJsonFactory {
  static final FromJsonFactory _instance = FromJsonFactory._();
  factory FromJsonFactory() => _instance;

  final Map<String, Function> _registry = {};

  FromJsonFactory._() {
    registerFromJsonFunction(Study._());
    registerFromJsonFunction(DataEndPoint._());
    registerFromJsonFunction(FileDataEndPoint());
    registerFromJsonFunction(Task());
    registerFromJsonFunction(AutomaticTask());
    registerFromJsonFunction(AppTask._());
    registerFromJsonFunction(Trigger());
    registerFromJsonFunction(ImmediateTrigger());
    registerFromJsonFunction(DelayedTrigger());
    registerFromJsonFunction(PeriodicTrigger._());
    registerFromJsonFunction(ScheduledTrigger._());
    registerFromJsonFunction(Time());
    registerFromJsonFunction(RecurrentScheduledTrigger._());
    registerFromJsonFunction(SamplingEventTrigger._());
    registerFromJsonFunction(ConditionalSamplingEventTrigger._());
    registerFromJsonFunction(MeasureType._());
    registerFromJsonFunction(Measure._());
    registerFromJsonFunction(PeriodicMeasure._());
    registerFromJsonFunction(MarkedMeasure._());
  }

  /// To be used for registering [fromJsonFunction] functions to this Factory.
  /// Should be done for each [type] of class that needs to be deserialized
  /// from JSON to a CARP Flutter class.
  void registerFromJsonFunction(Serializable type) {
    assert(type is Serializable);
    _registry['${type.runtimeType}'] = type.fromJsonFunction;
  }

  /// Deserialize [json] of the specified class [type].
  Serializable fromJson(String type, Map<String, dynamic> json) =>
      Function.apply(_registry[type], [json]);
}
