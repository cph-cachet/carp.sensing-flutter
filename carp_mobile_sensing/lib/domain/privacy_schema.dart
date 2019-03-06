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

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

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
