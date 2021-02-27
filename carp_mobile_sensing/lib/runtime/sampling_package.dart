part of runtime;

/// A registry of [SamplingPackage] packages.
class SamplingPackageRegistry {
  static final SamplingPackageRegistry _instance = SamplingPackageRegistry._();

  /// Get the singleton [SamplingPackageRegistry].
  factory SamplingPackageRegistry() => _instance;

  /// A list of registered packages.
  List<SamplingPackage> get packages => _packages;
  final List<SamplingPackage> _packages = [];

  /// The list of [Permission] needed for the entire list of packages (combined list).
  List<Permission> get permissions => _permissions;
  final List<Permission> _permissions = [];

  SamplingPackageRegistry._() {
    // HACK - creating a serializable object (such as a [Study]) ensures that
    // JSON deserialization in [Serializable] is initialized
    StudyProtocol();

    // add the basic permissions needed
    _permissions.add(Permission.storage);

    // register the built-in packages
    register(DeviceSamplingPackage());
    register(SensorSamplingPackage());
  }

  /// Register a sampling package.
  void register(SamplingPackage package) {
    _packages.add(package);
    package.permissions.forEach((permission) =>
        (!_permissions.contains(permission))
            ? _permissions.add(permission)
            : null);
    CAMSDataType.add(package.dataTypes);
    package.onRegister();
  }

  /// A schema that does maximum sampling.
  ///
  /// Takes its settings from the [SamplingSchema.common()] schema, but
  /// enables all measures.
  SamplingSchema maximum({String namespace}) => common(namespace: namespace)
    ..format = SamplingSchemaType.MAXIMUM
    ..name = 'Default ALL sampling'
    ..powerAware = true
    ..measures.values.forEach((measure) => measure.enabled = true);

  /// A default `common` sampling schema.
  ///
  /// This schema contains measure configurations based on best-effort
  /// experience and is intended for sampling on a daily basis with recharging
  /// at least once pr. day. This scheme is power-aware.
  ///
  /// These default settings are described in this [table](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Schemas#samplingschemacommon).
  SamplingSchema common({String namespace = NameSpace.UNKNOWN}) {
    SamplingSchema schema = SamplingSchema()
      ..format = SamplingSchemaType.COMMON
      ..name = 'Common (default) sampling'
      ..powerAware = true;

    // join sampling schemas from each registered sampling package.
    packages.forEach((package) => schema.addSamplingSchema(package.common));
    schema.measures.values
        .forEach((measure) => measure.format.namespace = namespace);

    return schema;
  }

  /// A sampling schema that does not adapt any [Measure]s.
  ///
  /// This schema is used in the power-aware adaptation of sampling. See [PowerAwarenessState].
  /// [SamplingSchema.normal] is an empty schema and therefore don't change anything when
  /// used to adapt a [StudyProtocol] and its [Measure]s in the [adapt] method.
  SamplingSchema normal({String namespace, bool powerAware}) => SamplingSchema(
      format: SamplingSchemaType.NORMAL,
      name: 'Default sampling',
      powerAware: powerAware);

  /// A default light sampling schema.
  ///
  /// This schema is used in the power-aware adaptation of sampling.
  /// See [PowerAwarenessState].
  /// This schema is intended for sampling on a daily basis with recharging
  /// at least once pr. day. This scheme is power-aware.
  ///
  /// See this [table](https://github.com/cph-cachet/carp.sensing-flutter/wiki/Schemas#samplingschemalight) for an overview.
  SamplingSchema light({String namespace}) {
    SamplingSchema schema = SamplingSchema()
      ..format = SamplingSchemaType.LIGHT
      ..name = 'Light sampling'
      ..powerAware = true;

    // join sampling schemas from each registered sampling package.
    packages.forEach((package) => schema.addSamplingSchema(package.light));
    schema.measures.values
        .forEach((measure) => measure.format.namespace = namespace);

    return schema;
  }

  /// A default minimum sampling schema.
  ///
  /// This schema is used in the power-aware adaptation of sampling.
  /// See [PowerAwarenessState].
  SamplingSchema minimum({String namespace}) {
    SamplingSchema schema = SamplingSchema()
      ..format = SamplingSchemaType.MINIMUM
      ..name = 'Minimum sampling'
      ..powerAware = true;

    // join sampling schemas from each registered sampling package.
    packages.forEach((package) => schema.addSamplingSchema(package.minimum));
    schema.measures.values
        .forEach((measure) => measure.format.namespace = namespace);

    return schema;
  }

  /// A non-sampling sampling schema.
  ///
  /// This schema is used in the power-aware adaptation of sampling.
  /// See [PowerAwarenessState].
  /// This schema pauses all sampling by disabling all probes.
  /// Sampling will be restored to the minimum level, once the device is
  /// recharged above the [PowerAwarenessState.MINIMUM_SAMPLING_LEVEL] level.
  SamplingSchema none({String namespace = NameSpace.CARP}) {
    SamplingSchema schema = SamplingSchema(
        format: SamplingSchemaType.NONE, name: 'No sampling', powerAware: true);
    CAMSDataType.all.forEach((key) => schema.measures[key] =
        Measure(type: DataType(namespace, key), enabled: false));

    return schema;
  }

  /// A sampling schema for debugging purposes.
  /// Collects and combines the [SamplingPackage.debug] [SamplingSchema]s
  /// for each package.
  SamplingSchema debug({String namespace = NameSpace.CARP}) {
    SamplingSchema schema = SamplingSchema()
      ..format = SamplingSchemaType.DEBUG
      ..name = 'Debugging sampling'
      ..powerAware = false;

    // join sampling schemas from each registered sampling package.
    packages.forEach((package) => schema.addSamplingSchema(package.debug));
    schema.measures.values
        .forEach((measure) => measure.format.namespace = namespace);

    return schema;
  }
}

/// Interface for a sampling package.
///
/// A sampling package provides information on sampling:
///  - types supported
///  - schemas - common and for power aware sampling
///  - permissions needed
///
/// It also contains factory methods for:
///  - creating a [Probe] based on a [Measure] type
///  - creating a [DeviceManager] based on a device type
abstract class SamplingPackage {
  /// The list of data type this package supports.
  List<String> get dataTypes;

  /// The default (common) sampling schema for all measures in this package.
  SamplingSchema get common;

  /// The sampling schema for normal sampling, when power-aware sampling
  /// is enabled. See [PowerAwarenessState].
  SamplingSchema get normal;

  /// The sampling schema for light sampling, when power-aware sampling is
  /// enabled. See [PowerAwarenessState].
  SamplingSchema get light;

  /// The sampling schema for minimum sampling, when power-aware sampling is
  /// enabled. See [PowerAwarenessState].
  SamplingSchema get minimum;

  /// A debugging sampling schema for all measures in this package.
  /// Typically provides very detailed and frequent sampling in order to
  /// debug the probes.
  SamplingSchema get debug;

  /// The list of permissions that this package need.
  ///
  /// See [PermissionGroup](https://pub.dev/documentation/permission_handler/latest/permission_handler/PermissionGroup-class.html)
  /// for a list of possible permissions.
  ///
  /// For Android permission in the Manifest.xml file,
  /// see [Manifest.permission](https://developer.android.com/reference/android/Manifest.permission.html)
  List<Permission> get permissions;

  /// Creates a new [Probe] of the specified [type].
  Probe create(String type);

  /// What device type is this package using?
  ///
  /// Default value is a smartphone. Override this if another type is supported.
  ///
  /// Note that it is assumed that a sampling package only supports **one**
  /// type of device.
  String get deviceType;

  /// Get a [DeviceManager] for the type of device in this package.
  ///
  /// Default manager is a smartphone.
  /// Override this if another type of manager  is supported.
  DeviceManager get deviceManager;

  /// Callback method when this package is being registered.
  void onRegister();
}

/// An abstract class for all sampling packages that run on the phone itself.
abstract class SmartphoneSamplingPackage implements SamplingPackage {
  static const String SMARTPHONE_DEVICE_TYPE = 'smarthone';

  String get deviceType => SMARTPHONE_DEVICE_TYPE;
  DeviceManager get deviceManager => SmartphoneDeviceManager();
}
