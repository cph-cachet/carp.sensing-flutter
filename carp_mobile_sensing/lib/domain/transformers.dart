/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// Signature of a data transformer.
typedef DataPointTransformer = DataPoint Function(DataPoint);

/// Signature of a data stream transformer.
typedef DataPointStreamTransformer = Stream<DataPoint> Function(
    Stream<DataPoint>);

/// A no-operation transformer.
DataPoint noop(DataPoint data) => data;

/// A registry of [DataPointTransformerSchema]s which hold a set of
/// [DataPointTransformer]s.
class DataPointTransformerSchemaRegistry {
  static final DataPointTransformerSchemaRegistry _instance =
      DataPointTransformerSchemaRegistry._();

  /// The map between the namespace of a transformer schema and the schema.
  Map<String, DataPointTransformerSchema> get schemas => _schemas;
  final Map<String, DataPointTransformerSchema> _schemas = {};

  /// Get the singleton instance of the [DataPointTransformerSchemaRegistry].
  factory DataPointTransformerSchemaRegistry() => _instance;

  DataPointTransformerSchemaRegistry._() {
    // register 3 default transformer schemas:
    // 1. a no-operation CARP schema
    // 2. a default OMH schema
    // 3. a default privacy transformation schemas
    register(CARPTransformerSchema());
    register(OMHTransformerSchema());
    register(PrivacySchema());
  }

  /// Register a transformer schema.
  void register(DataPointTransformerSchema schema) {
    _schemas[schema.namespace] = schema;
    schema.onRegister();
  }

  /// Lookup a transformer schema based on its namespace.
  DataPointTransformerSchema lookup(String namespace) => _schemas[namespace];
}

/// An interface for Datum that is created from a transformer.
abstract class TransformedDatum {
  static DataPointTransformer get transformer => null;
}

/// An abstract class defining a transformer schema, which hold a set of
/// [DataPointTransformer]s, which that can map from the native CARP namespace
/// to another namespace.
/// A [DataPointTransformerSchema] must be implemented for each supported namespace.
abstract class DataPointTransformerSchema {
  /// The type of namespace that this package can transform to (see e.g.
  /// [NameSpace] for pre-defined namespaces).
  String get namespace;

  final Map<String, DataPointTransformer> _transformers = {};

  /// A map of transformers in this schema, indexed by the data type they
  /// can transform.
  Map<String, DataPointTransformer> get transformers => _transformers;

  /// Callback method when this schema is being registered.
  void onRegister();

  /// Add a transformer to this schema based on its type mapped to its
  /// [DataType].
  void add(String type, DataPointTransformer transformer) =>
      transformers[type] = transformer;

  /// Transform the [data] according to the transformer for its data type.
  DataPoint transform(DataPoint data) {
    Function transformer = transformers[data.carpHeader.dataFormat];
    return (transformer != null) ? transformer(data) : data;
  }
}

/// A default [DataPointTransformerSchema] for CARP no-operation transformers
class CARPTransformerSchema extends DataPointTransformerSchema {
  String get namespace => NameSpace.CARP;
  void onRegister() {}
}

/// A default [DataPointTransformerSchema] for Open mHealth (OMH) transformers
class OMHTransformerSchema extends DataPointTransformerSchema {
  String get namespace => NameSpace.OMH;
  void onRegister() {}
}

/// A default [DataPointTransformerSchema] for privacy transformers
class PrivacySchema extends DataPointTransformerSchema {
  static const String DEFAULT = 'default-privacy-schema';

  String get namespace => DEFAULT;
  void onRegister() {}
}
