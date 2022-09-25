/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// Signature of a data transformer.
typedef DatumTransformer = Datum Function(Datum);

/// A no-operation transformer.
Datum noop(Datum datum) => datum;

/// A factory which can create a [DatumTransformer].
abstract class DatumTransformerFactory {
  static DatumTransformer? get transformer => null;
}

/// A registry of [DatumTransformerSchema]s which hold a set of
/// [DatumTransformer]s.
class TransformerSchemaRegistry {
  static final TransformerSchemaRegistry _instance =
      TransformerSchemaRegistry._();

  /// The map between the namespace of a transformer schema and the schema.
  Map<String, DatumTransformerSchema> get schemas => _schemas;
  final Map<String, DatumTransformerSchema> _schemas = {};

  /// Get the singleton instance of the [TransformerSchemaRegistry].
  factory TransformerSchemaRegistry() => _instance;

  TransformerSchemaRegistry._() {
    // register 3 default transformer schemas:
    // 1. a no-operation CARP schema
    // 2. a default OMH schema
    // 3. a default FHIR schema
    // 4. a default privacy transformation schemas
    register(CARPTransformerSchema());
    register(OMHTransformerSchema());
    register(FHIRTransformerSchema());
    register(PrivacySchema());
  }

  /// Register a transformer schema.
  void register(DatumTransformerSchema schema) {
    _schemas[schema.namespace] = schema;
    schema.onRegister();
  }

  /// Lookup a transformer schema based on its namespace.
  DatumTransformerSchema? lookup(String namespace) => _schemas[namespace];
}

/// An abstract class defining a transformer schema, which hold a set of
/// [DatumTransformer]s, which that can map from the native CARP namespace
/// to another namespace.
/// A [DatumTransformerSchema] must be implemented for each supported namespace.
abstract class DatumTransformerSchema {
  /// The type of namespace that this package can transform to (see e.g.
  /// [NameSpace] for pre-defined namespaces).
  String get namespace;

  final Map<String, DatumTransformer> _transformers = {};

  /// A map of transformers in this schema, indexed by the data type they
  /// can transform.
  Map<String, DatumTransformer> get transformers => _transformers;

  /// Callback method when this schema is being registered.
  void onRegister();

  /// Add a transformer to this schema based on its type mapped to its
  /// [String].
  void add(String type, DatumTransformer transformer) =>
      transformers[type] = transformer;

  /// Transform the [datum] according to the transformer for its data type.
  Datum transform(Datum datum) {
    DatumTransformer? transformer = transformers[datum.format.toString()];
    return (transformer != null) ? transformer(datum) : datum;
  }
}

/// A default [DatumTransformerSchema] for CARP no-operation transformers
class CARPTransformerSchema extends DatumTransformerSchema {
  @override
  String get namespace => NameSpace.CARP;
  @override
  void onRegister() {}
}

/// A default [DatumTransformerSchema] for Open mHealth (OMH) transformers
class OMHTransformerSchema extends DatumTransformerSchema {
  @override
  String get namespace => NameSpace.OMH;
  @override
  void onRegister() {}
}

/// A default [DatumTransformerSchema] for HL7 FHIR transformers
class FHIRTransformerSchema extends DatumTransformerSchema {
  @override
  String get namespace => NameSpace.FHIR;
  @override
  void onRegister() {}
}

/// A default [DatumTransformerSchema] for privacy transformers
class PrivacySchema extends DatumTransformerSchema {
  static const String DEFAULT = 'default-privacy-schema';

  @override
  String get namespace => DEFAULT;
  @override
  void onRegister() {}
}
