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
    Study(id: '1234');

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
    DataType.add(package.dataTypes);
    package.onRegister();
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
