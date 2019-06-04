part of runtime;

/// A registry for sampling packages. Global singleton.
_SamplingPackageRegistry SamplingPackageRegistry = _SamplingPackageRegistry();

class _SamplingPackageRegistry {
  List<SamplingPackage> _packages = List<SamplingPackage>();
  List<SamplingPackage> get packages => _packages;

  _SamplingPackageRegistry() : super() {
    // HACK - creating a serializable object (such as a [Study]) ensures that
    // JSON deserialization in [Serializable] is initialized
    Study("1234", "unknown");
    // register the known, built-in packages
    register(DeviceSamplingPackage());
    register(SensorSamplingPackage());
    register(ConnectivitySamplingPackage());
    register(AppsSamplingPackage());
  }

  /// Register a sampling package.
  void register(SamplingPackage package) {
    _packages.add(package);
    DataType.add(package.dataTypes);
    package.onRegister();
  }
}

/// Interface for a sampling package that holds a set of sampling
///  - types
///  - probes
///  - schemas
abstract class SamplingPackage {
  /// The default (common) sampling schema for all measures in this package.
  SamplingSchema get common;

  /// The sampling schema for normal sampling, when power-aware sampling is enabled.
  /// See [PowerAwarenessState].
  SamplingSchema get normal;

  /// The sampling schema for light sampling, when power-aware sampling is enabled.
  /// See [PowerAwarenessState].
  SamplingSchema get light;

  /// The sampling schema for minimum sampling, when power-aware sampling is enabled.
  /// See [PowerAwarenessState].
  SamplingSchema get minimum;

  /// A debugging sampling schema for all measures in this package.
  /// Typically provides very detailed and frequent sampling in order to debug the probes.
  SamplingSchema get debug;

  /// The list of data type this package supports.
  List<String> get dataTypes;

  /// Creates a new [Probe] of the specified [type].
  Probe create(String type);

  /// Callback method when this package is being registered.
  void onRegister();
}
