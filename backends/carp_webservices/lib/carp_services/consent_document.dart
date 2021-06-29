/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// A [ConsentDocument] contains data read from a consent document in the CARP
/// web service
///
/// The document can be extracted with the [document] property or by using
/// subscript syntax to access a specific field.
class ConsentDocument {
  ConsentDocument._(this._snapshot);

  final Map<String, dynamic>? _snapshot;

  /// The full data snapshot
  Map<String, dynamic>? get snapshot => _snapshot;

  /// The ID of the snapshot's document
  int? get id => _snapshot!['id'];

  /// The id of the study of this document
  String? get studyId => _snapshot!['study_id'];

  /// The id of the user who created this document
  int? get createdByUserId => _snapshot!['created_by_user_id'];

  /// The timestamp of creation of this document
  DateTime get createdAt => DateTime.parse(_snapshot!['created_at']);

  /// The timestamp of latest update of this document
  DateTime get updatedAt => DateTime.parse(_snapshot!['updated_at']);

  /// The actual consent document
  Map<String, dynamic>? get document => _snapshot!['data'];

  /// Reads individual data values from the snapshot
  dynamic operator [](String key) => document![key];

  /// Returns `true` if the document exists.
  bool get exists => document != null;

  String toString() =>
      "ConsentDocument - id : $id, study: $studyId, document size: ${document?.length}";
}
