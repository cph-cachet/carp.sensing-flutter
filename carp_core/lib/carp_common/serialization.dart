/*
 * Copyright 2018-2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_common;

/// This is the base class for all JSON serializable objects.
///
/// Using this class allow for implementing both serialization and
/// deserialization to/from JSON.
/// This is done using the [json_serializable](https://pub.dev/packages/json_serializable)
/// package.
///
/// It also allows for serialization of polymorphic classes.
///
/// To support polymorphic serialization, each subclass should:
///
///  * annotate the class with `@JsonSerializable`
///  * add the three json methods
///      * `Function get fromJsonFunction => ...`
///      * `factory ...fromJson(...)`
///      * `Map<String, dynamic> toJson() => ...`
///  * register the classes in the `FromJsonFactory()` registry.
///  * build json function using the `flutter pub run build_runner build --delete-conflicting-outputs` command
///
/// Below is a simple example of two classes `A` and `B` where B extends A.
///
/// ```dart
/// @JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
/// class A extends Serializable {
///   int index;
///
///   A() : super();
///
///   Function get fromJsonFunction => _$AFromJson;
///   factory A.fromJson(Map<String, dynamic> json) => FromJsonFactory().fromJson(json);
///   Map<String, dynamic> toJson() => _$AToJson(this);
/// }
///
/// @JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
/// class B extends A {
///   String str;
///
///   B() : super();
///
///   Function get fromJsonFunction => _$BFromJson;
///   factory B.fromJson(Map<String, dynamic> json) => FromJsonFactory().fromJson(json);
///   Map<String, dynamic> toJson() => _$BToJson(this);
/// }
/// ````
///
/// Note that the naming of the `fromJson()` and `toJson()` functions follows
/// [json_serializable](https://pub.dev/packages/json_serializable)
/// package. For example the `fromJson` function for class `A` is called `_$AFromJson`.
///
/// The [fromJsonFunction] must be registered on app startup (before
/// use of de-serialization) in the [FromJsonFactory] singleton, like this:
///
/// ```dart
///  FromJsonFactory().register(A());
/// ````
///
/// For this purpose it is helpful to have an empty constructor, but any constructur
/// will work, since only the `fromJsonFunction` function is used.
/// Hence, a private constructure like `A._()` is also fine.
///
/// Polymorphic serialization is handled by setting the `$type` property in the
/// [Serializable] class. Per default, an object's `runtimeType` is used as the
/// `$type` for an object. Hence, the json of object of type `A` and `B` would
/// look like this:
///
/// ```json
///  {
///   "$type": "A",
///   "index": 1
///  }
///  {
///   "$type": "B",
///   "str": "abc"
///  }
/// ```
///
/// However, if you want to specify your own object/class type (e.g., if you get
/// json serialized from another language which uses a package structure like
/// Java, C# or Kotlin), you can specify the json type in the [jsonType] property
/// of the class.
///
/// For example, if the class `B` above should use a different `$type` annotation,
/// using the following:
///
/// ```dart
/// @JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
/// class B extends A {
///
///   <<as above>>
///
///   String get jsonType => 'dk.cachet.$runtimeType';
/// }
/// ````
///
/// In which case the json would look like:
///
/// ```json
///  {
///   "$type": "dk.cachet.B",
///   "str": "abc"
///  }
/// ```
///
abstract class Serializable {
  /// The identifier of the class type in JSON serialization.
  static const String CLASS_IDENTIFIER = '\$type';

  /// The runtime class name (type) of this object.
  /// Used for deserialization from JSON objects.
  String $type;

  /// Create an object that can be serialized to JSON.
  Serializable() {
    $type = jsonType;
  }

  /// The function which can convert a JSON string to an object of this type.
  Function get fromJsonFunction;

  /// Return a JSON encoding of this object.
  Map<String, dynamic> toJson();

  /// Return the [$type] to be used for JSON serialization of this class.
  /// Default is [runtimeType]. Only specify this if you need another type.
  String get jsonType => this.runtimeType.toString();
}

/// A factory that holds [fromJson] functions to be used in JSON
/// deserialization.
class FromJsonFactory {
  static final FromJsonFactory _instance = FromJsonFactory._();
  factory FromJsonFactory() => _instance;

  final Map<String, Function> _registry = {};

  // When initializing this factory, register all CAMS classes which should
  // support deserialization from JSON.
  //
  // TODO: Remember to add any new classes here.
  // TODO: This could be auto-generated using a builder....
  FromJsonFactory._() {
    // DEPLOYMENT
    register(DeviceRegistration());
    register(DeviceRegistration(),
        type:
            'dk.cachet.carp.protocols.domain.devices.DefaultDeviceRegistration');

    register(DeviceDeploymentStatus());
    register(
      DeviceDeploymentStatus(),
      type:
          'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Unregistered',
    );
    register(
      DeviceDeploymentStatus(),
      type:
          'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Registered',
    );
    register(
      DeviceDeploymentStatus(),
      type: 'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Deployed',
    );
    register(DeviceDeploymentStatus(),
        type:
            'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.NeedsRedeployment');

    register(StudyDeploymentStatus());
    register(StudyDeploymentStatus(),
        type: 'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Invited');
    register(StudyDeploymentStatus(),
        type:
            'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeployingDevices');
    register(StudyDeploymentStatus(),
        type:
            'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeploymentReady');
    register(StudyDeploymentStatus(),
        type: 'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Stopped');

    // PROTOCOL
    register(StudyProtocol());
    register(ProtocolOwner());
    register(Trigger());
    register(ElapsedTimeTrigger());
    register(ManualTrigger());
    register(ScheduledTrigger());

    register(TaskDescriptor());
    register(ConcurrentTask());
    register(CustomProtocolTask());
    register(Measure(type: 'ignored'));
    register(DataTypeMeasure(type: 'ignored'));
    register(PhoneSensorMeasure(type: 'ignored'));
    register(SamplingConfiguration());

    register(DeviceDescriptor());
    register(MasterDeviceDescriptor());
    register(CustomProtocolDevice());
    register(Smartphone());
    register(AltBeacon());
    register(DeviceDescriptor(),
        type:
            'dk.cachet.carp.protocols.infrastructure.test.StubMasterDeviceDescriptor');
    register(DeviceDescriptor(),
        type:
            'dk.cachet.carp.protocols.infrastructure.test.StubDeviceDescriptor');
  }

  /// Register a [Serializable] class which can be deserialized from JSON.
  ///
  /// If [type] is specified, then this is used as the type indentifier as
  /// specified in [CLASS_IDENTIFIER].
  /// Othervise the [Serializable] class [jsonType] is used.
  ///
  /// A type needs to be registered **before** a class can be deserialized from
  /// JSON to a Flutter class.
  void register(Serializable serializable, {String type}) =>
      _registry['${type ?? serializable.jsonType}'] =
          serializable.fromJsonFunction;

  /// Rester all [serializables].
  ///
  /// A convinient way to call [register] for multiple types.
  void registerAll(List<Serializable> serializables) {}

  /// Deserialize [json] based on its type.
  Serializable fromJson(Map<String, dynamic> json) =>
      Function.apply(_registry[json[Serializable.CLASS_IDENTIFIER]], [json]);
}

/// A convient function to convert a Dart object into a JSON string.
String toJsonString(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

// bool _fromJsonFunctionsRegistrered = false;

// // Register all the fromJson functions for the deployment domain classes.
// void _registerFromJsonFunctions() {
//   if (_fromJsonFunctionsRegistrered) return;
//   _fromJsonFunctionsRegistrered = true;

//   // DEPLOYMENT
//   FromJsonFactory().register(DeviceRegistration());
//   FromJsonFactory().register(DeviceRegistration(),
//       type:
//           'dk.cachet.carp.protocols.domain.devices.DefaultDeviceRegistration');

//   FromJsonFactory().register(DeviceDeploymentStatus());
//   FromJsonFactory().register(
//     DeviceDeploymentStatus(),
//     type:
//         'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Unregistered',
//   );
//   FromJsonFactory().register(
//     DeviceDeploymentStatus(),
//     type: 'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Registered',
//   );
//   FromJsonFactory().register(
//     DeviceDeploymentStatus(),
//     type: 'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.Deployed',
//   );
//   FromJsonFactory().register(DeviceDeploymentStatus(),
//       type:
//           'dk.cachet.carp.deployment.domain.DeviceDeploymentStatus.NeedsRedeployment');

//   FromJsonFactory().register(StudyDeploymentStatus());
//   FromJsonFactory().register(StudyDeploymentStatus(),
//       type: 'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Invited');
//   FromJsonFactory().register(StudyDeploymentStatus(),
//       type:
//           'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeployingDevices');
//   FromJsonFactory().register(StudyDeploymentStatus(),
//       type:
//           'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.DeploymentReady');
//   FromJsonFactory().register(StudyDeploymentStatus(),
//       type: 'dk.cachet.carp.deployment.domain.StudyDeploymentStatus.Stopped');

//   // PROTOCOL
//   FromJsonFactory().register(StudyProtocol());
//   FromJsonFactory().register(ProtocolOwner());
//   FromJsonFactory().register(Trigger());
//   FromJsonFactory().register(ElapsedTimeTrigger());
//   FromJsonFactory().register(ManualTrigger());
//   FromJsonFactory().register(ScheduledTrigger());

//   FromJsonFactory().register(TaskDescriptor());
//   FromJsonFactory().register(ConcurrentTask());
//   FromJsonFactory().register(CustomProtocolTask());
//   FromJsonFactory().register(Measure(type: 'ignored'));
//   FromJsonFactory().register(DataTypeMeasure(type: 'ignored'));
//   FromJsonFactory().register(PhoneSensorMeasure(type: 'ignored'));
//   FromJsonFactory().register(SamplingConfiguration());

//   FromJsonFactory().register(DeviceDescriptor());
//   FromJsonFactory().register(MasterDeviceDescriptor());
//   FromJsonFactory().register(CustomProtocolDevice());
//   FromJsonFactory().register(Smartphone());
//   FromJsonFactory().register(AltBeacon());
//   FromJsonFactory().register(DeviceDescriptor(),
//       type:
//           'dk.cachet.carp.protocols.infrastructure.test.StubMasterDeviceDescriptor');
//   FromJsonFactory().register(DeviceDescriptor(),
//       type:
//           'dk.cachet.carp.protocols.infrastructure.test.StubDeviceDescriptor');
// }
