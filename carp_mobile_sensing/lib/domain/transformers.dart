/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// Signature of a data transformer.
typedef DatumTransformer = Datum Function(Datum);

/// Signature of a data stream transformer.
typedef DatumStreamTransformer = Stream<Datum> Function(Stream<Datum>);

/// A no-operation transformer.
Datum noop(Datum data) => data;

/// A registry for transformer packages. Global singleton.
_TransformerPackageRegistry TransformerPackageRegistry = _TransformerPackageRegistry();

class _TransformerPackageRegistry {
  Map<String, TransformerPackage> _packages = Map<String, TransformerPackage>();
  Map<String, TransformerPackage> get packages => _packages;

  /// Register a transformer package.
  void register(TransformerPackage package) {
    _packages[package.namespace] = package;
    package.onRegister();
  }

  /// Lookup a transformer package based on its namespace.
  TransformerPackage lookup(String namespace) => _packages[namespace];
}

/// An abstract class defining a transformer package, which hold a set of [DatumTransformer],
/// that can map from the native CARP namespace to another namespace. A [TransformerPackage]
/// must be implemented for each supported namespace.
abstract class TransformerPackage {
  /// The type of namespace that this package can transform to (see e.g. [NameSpace] for
  /// pre-defined namespaces).
  String get namespace;

  Map<String, DatumTransformer> _transformers = Map();

  /// A map of transformers in this package, indexed by the data type they can transform.
  Map<String, DatumTransformer> get transformers => _transformers;

  /// Callback method when this package is being registered.
  void onRegister();

  /// Add a transformer to this package based on its type mapped to its [DataType].
  void add(String type, DatumTransformer transformer) => transformers[type] = transformer;

  Datum transform(Datum data) {
    Function transformer = transformers[data.format.name];
    return (transformer != null) ? transformer(data) : data;
  }
}

/// Specify a schema for transforming data according to a set of privacy rules.
class PrivacySchema {
  Map<String, DatumTransformer> transformers = Map();

  PrivacySchema() : super();

  factory PrivacySchema.none() => PrivacySchema();
  factory PrivacySchema.full() => PrivacySchema();

  addProtector(String type, DatumTransformer protector) => transformers[type] = protector;

  /// Returns a privacy protected version of [data].
  ///
  /// If a transformer for this data type exists, the data is transformed.
  /// Otherwise, the same data is returned unchanged.
  Datum protect(Datum data) {
    Function transformer = transformers[data.format.name];
    return (transformer != null) ? transformer(data) : data;
  }
}

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);
