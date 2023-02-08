/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provide a collection reference to a CARP web service.
///
/// The Collections endpoint allows you to store and query custom documents to
/// suit your specific application's needs.
///
/// Note that the collection / document structure is like this:
///
/// `collection/document/collection/document/...`
///
/// I.e., that a collection holds a list of documents, which each can hold a list of collections, etc.
/// For example, the following
///
/// `activities/running/geopositions/pos_1`
///
/// is a reference to the geoposition document `pos_1` in the collection `geopositions` in the document `running`
/// in the collection `activities`.
class CollectionReference extends CarpReference {
  int? _id;
  String _path;

  /// Creates a [CollectionReference] based on the path to the
  /// collection, relative to the root of the web service.
  ///
  /// Note that [path] should be relative and NOT start with `/`.
  /// For example; `activities/running/geopositions`
  CollectionReference._(CarpBaseService service, this._path)
      : super._(service) {
    assert(!(_path.startsWith('/')) || _path.length == 0);
  }

  /// ID of the referenced collection.
  ///
  /// Returns null if this collection is not available on the server.
  /// It might not have been created yet, or has been deleted.
  int? get id => _id;

  /// The name of the referenced collection.
  String get name => path.split('/').last;

  /// Returns the path of this collection (relative to the root of the web service).
  String get path => _path;

  /// The full CARP web service path to this collection.
  String get carpPath =>
      '/api/studies/${service.app!.studyId}/collections/$path';

  /// The full URI for the collection endpoint for this [CollectionReference].
  String get collectionUri => "${service.app!.baseUri.toString()}$carpPath";

  /// The full URI for the collection endpoint for this [CollectionReference] by its unique [id].
  String get collectionUriByID =>
      '${service.app!.baseUri.toString()}/api/studies/${service.app!.studyId}/collections/id/$id';

  /// Reads the collection referenced by this [CollectionReference] from the server.
  ///
  /// If no collection exists on the server (yet), this local CollectionReference is returned.
  Future<CollectionReference> get() async {
    final restHeaders = headers;

    http.Response response =
        await httpr.get(Uri.encodeFull(collectionUri), headers: restHeaders);
    int httpStatusCode = response.statusCode;

    Map<String, dynamic> responseJson = json.decode(response.body);
    if (httpStatusCode == HttpStatus.ok)
      return this
        .._id = responseJson['id']
        .._path = responseJson['name'];

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson['message'],
      path: responseJson["path"],
    );
  }

  /// Get the documents in this collection.
  Future<List<DocumentSnapshot>> get documents async {
    final restHeaders = headers;

    //print('uri :: $collectionUri');
    http.Response response =
        await httpr.get(Uri.encodeFull(collectionUri), headers: restHeaders);
    int httpStatusCode = response.statusCode;

    Map<String, dynamic> responseJson = json.decode(response.body);
    if (httpStatusCode == HttpStatus.ok) {
      List<dynamic> documentsJson = responseJson['documents'];
      List<DocumentSnapshot> documents = [];
      for (var documentJson in documentsJson) {
        String key = documentJson['name'];
        documents.add(DocumentSnapshot._('$path/$key', documentJson));
      }

      return documents;
    }

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson['message'],
      path: responseJson["path"],
    );
  }

  /// Returns a [DocumentReference] with the provided name in this collection.
  ///
  /// If no [name] is provided, an auto-generated name is used.
  DocumentReference document([String? name]) {
    String documentPath;
    if (name == null) {
      final String key = PushIdGenerator.generatePushChildName();
      documentPath = '$path/$key';
    } else {
      documentPath = '$path/$name';
    }

    return DocumentReference._path(service as CarpService, documentPath);
  }

  /// Add a data document to this collection and returns a [DocumentReference] to this document.
  ///
  /// If no [name] is provided, an auto-generated name is used.
  /// If no [data] is provided, this can be set later using the [DocumentReference.setData()] method.
  Future<DocumentReference> add([
    String? name,
    Map<String, dynamic>? data,
  ]) async {
    final DocumentReference newDocument = document(name);
    if (data != null) await newDocument.setData(data);
    return newDocument;
  }

  /// Rename this collection.
  Future rename(String newName) async {
    // PUT the new name of this collection to the CARP web service
    http.Response response = await httpr.put(Uri.encodeFull(collectionUriByID),
        headers: headers, body: '{"name":"$newName"}');
    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == HttpStatus.ok) {
      int start = _path.length - _path.split('/').last.length;
      _path = _path.replaceRange(start, _path.length,
          newName); // renaming path, i.e. the last part of the path
      return;
    }
    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson['message'],
      path: responseJson["path"],
    );
  }

  /// Deletes the collection referred to by this [CollectionReference].
  Future delete() async {
    http.Response response =
        await httpr.delete(Uri.encodeFull(collectionUriByID), headers: headers);

    int httpStatusCode = response.statusCode;
    if (httpStatusCode == HttpStatus.ok) {
      this._id = -1;
      return;
    } else {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      throw CarpServiceException(
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
        message: responseJson['message'],
        path: responseJson["path"],
      );
    }
  }

  String toString() => "CollectionReference - id: '$id', path: '$path'";
}
