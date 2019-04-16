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

/// A registry for transformer schemas. Global singleton.
_TransformerSchemaRegistry TransformerSchemaRegistry = _TransformerSchemaRegistry();

class _TransformerSchemaRegistry {
  Map<String, TransformerSchema> _schemas = Map<String, TransformerSchema>();
  Map<String, TransformerSchema> get schemas => _schemas;

  _TransformerSchemaRegistry() {
    // register 3 default transformer schemas:
    // 1. a no-operation CARP schema
    // 2. a default OMH schema
    // 3. a default privacy transformation schemas
    register(CARPTransformerSchema());
    register(OMHTransformerSchema());
    register(PrivacySchema());
  }

  /// Register a transformer package.
  void register(TransformerSchema schema) {
    _schemas[schema.namespace] = schema;
    schema.onRegister();
  }

  /// Lookup a transformer package based on its namespace.
  TransformerSchema lookup(String namespace) => _schemas[namespace];
}

abstract class TransformedDatum {
  static DatumTransformer get transformer => null;
}

/// An abstract class defining a transformer schema, which hold a set of [DatumTransformer],
/// that can map from the native CARP namespace to another namespace. A [TransformerSchema]
/// must be implemented for each supported namespace.
abstract class TransformerSchema {
  /// The type of namespace that this package can transform to (see e.g. [NameSpace] for
  /// pre-defined namespaces).
  String get namespace;

  Map<String, DatumTransformer> _transformers = Map();

  /// A map of transformers in this schema, indexed by the data type they can transform.
  Map<String, DatumTransformer> get transformers => _transformers;

  /// Callback method when this schema is being registered.
  void onRegister();

  /// Add a transformer to this schema based on its type mapped to its [DataType].
  void add(String type, DatumTransformer transformer) => transformers[type] = transformer;

  /// Transform the [data] according to the transformer for its type.
  Datum transform(Datum data) {
    Function transformer = transformers[data.format.name];
    return (transformer != null) ? transformer(data) : data;
  }
}

/// A default [TransformerSchema] for CARP no-operation transformers
class CARPTransformerSchema extends TransformerSchema {
  String get namespace => NameSpace.CARP;
  void onRegister() {}
}
