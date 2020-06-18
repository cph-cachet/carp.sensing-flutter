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
  int _id;
  String _path;

  /// Creates a [CollectionReference] based on the path to the
  /// collection, relative to the root of the web service.
  ///
  /// Note that [path] should be relative and NOT start with `/`.
  /// For example; `activities/running/geopositions`
  CollectionReference._(CarpService service, this._path)
      : assert(_path != null),
        assert(!(_path.startsWith('/')) || _path.length == 0),
        super._(service);

  /// ID of the referenced collection.
  int get id => _id;

  /// The name of the referenced collection.
  String get name => path.split('/').last;

  /// Returns the path of this collection (relative to the root of the web service).
  String get path => _path;

  /// The full CARP web service path to this collection.
  String get carpPath =>
      '/api/studies/${service.app.study.id}/collections/$path';

  /// The full URI for the collection endpoint for this [CollectionReference].
  String get collectionUri => "${service.app.uri.toString()}$carpPath";

  /// The full URI for the collection endpoint for this [CollectionReference] by its unique [id].
  String get _collectionUriByID =>
      '${service.app.uri.toString()}/api/studies/${service.app.study.id}/collections/$id';

  /// Reads the collection referenced by this [CollectionReference] from the server.
  ///
  /// If no collection exists on the server (yet), this local CollectionReference is returned.
  Future<CollectionReference> get() async {
    final restHeaders = await headers;

    http.Response response =
        await httpr.get(Uri.encodeFull(collectionUri), headers: restHeaders);
    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    print('url : $collectionUri');
    print('response code: $httpStatusCode');
    print(_encode(responseJson));

    if (httpStatusCode == 200) return this.._id = responseJson['id'];

    // All other cases are treated as an error.
    throw CarpServiceException(responseJson["error"],
        description: responseJson["message"],
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Get the documents in this collection.
  Future<List<DocumentSnapshot>> get documents async {
    final restHeaders = await headers;

    // GET the list of documents in this collection from the CARP web service

    print(' >> collectionUri : $collectionUri');

    http.Response response =
        await httpr.get(Uri.encodeFull(collectionUri), headers: restHeaders);
    int httpStatusCode = response.statusCode;
    print(' >> httpStatusCode : $httpStatusCode');
    print(' >> response.body : ${response.body}');

    if (httpStatusCode == 200) {
      Map<String, dynamic> responseJson = json.decode(response.body);
      List<DocumentSnapshot> documents = new List<DocumentSnapshot>();
      for (var item in responseJson['documents']) {
        Map<String, dynamic> documentJson = item;
        String key = documentJson["name"];
        documents.add(DocumentSnapshot._("$path/$key", documentJson));
      }
      return documents;
    }
    // All other cases are treated as an error.
    throw CarpServiceException(response.body,
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Returns a [DocumentReference] with the provided name in this collection.
  ///
  /// If no [name] is provided, an auto-generated name is used.
  DocumentReference document([String name]) {
    String documentPath;
    if (name == null) {
      final String key = PushIdGenerator.generatePushChildName();
      documentPath = "$path/$key";
    } else {
      documentPath = "$path/$name";
    }

    return DocumentReference._path(service, documentPath);
  }

  /// Add a data document to this collection and returns a [DocumentReference] to this document.
  ///
  /// If no [name] is provided, an auto-generated name is used.
  /// If no (data] is provided now, this can be set later using the [DocumentReference.setData()] method.
  Future<DocumentReference> add(
      [String name, Map<String, dynamic> data]) async {
    final DocumentReference newDocument = document(name);
    if (data != null) await newDocument.setData(data);
    return newDocument;
  }

  /// Rename this collection.
  Future<void> rename(String newName) async {
    assert(newName != null);
    final restHeaders = await headers;

    // PUT the new name of this collection to the CARP web service
    http.Response response = await httpr.put(Uri.encodeFull(_collectionUriByID),
        headers: restHeaders, body: '{"name":"$newName"}');
    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == 200) {
      int start = _path.length - _path.split('/').last.length;
      _path = _path.replaceRange(start, _path.length,
          newName); // renaming path, i.e. the last part of the path
      return;
    }
    // All other cases are treated as an error.
    throw CarpServiceException(responseJson["error"],
        description: responseJson["message"],
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Deletes the collection referred to by this [CollectionReference].
  Future<void> delete() async {
    final restHeaders = await headers;

    print(_collectionUriByID);
    http.Response response = await httpr
        .delete(Uri.encodeFull(_collectionUriByID), headers: restHeaders);

    int httpStatusCode = response.statusCode;
    if (httpStatusCode == 200)
      return;
    else {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      throw CarpServiceException(responseJson["error"],
          description: responseJson["message"],
          httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
    }
  }

  String toString() => 'CollectionReference - id: $id, path: $path';
}

/// A [DocumentReference] refers to a document in a CARP collection
/// and can be used to write, read, or delete this document.
///
/// The document with the referenced id may or may not exist.
/// If the document does not yet exist, it will be created.
/// If the collection does not yet exist, it will be created.
///
/// A [DocumentReference] can also be used to create a [CollectionReference]
/// to a sub-collection.
class DocumentReference extends CarpReference {
  int _id;
  String _path;

  DocumentReference._id(CarpService service, this._id)
      : assert(_id != null),
        super._(service);

  DocumentReference._path(CarpService service, this._path)
      : assert(_path != null),
        super._(service);

  /// The unique id of this document.
  int get id => _id;

  /// The name of this document.
  String get name => _path.split('/').last;

  /// The path to this document
  String get path => _path;

  /// The full CARP web service path to this document.
  ///
  /// If the id of this document is known, use the `documents` CARP endpoint,
  /// otherwise use the `collections` endpoint.
  String get carpPath => (_id != null)
      ? "/api/studies/${service.app.study.id}/documents/$id"
      : "/api/studies/${service.app.study.id}/collections/$path";

  /// The full URI for the document endpoint for this document.
  String get documentUri => "${service.app.uri.toString()}$carpPath";

  /// Writes to the document referred to by this [DocumentReference].
  ///
  /// If the document does not yet exist, it will be created.
  /// If the collection does not yet exist, it will be created.
  /// Returns a [DocumentSnapshot] with the ID generated at the server side.
  Future<DocumentSnapshot> setData(Map<String, dynamic> data) async {
    // Remember that the CARP collection service generated the ID and returns it in a POST.

    // If this document does not already exist on the server (i.e., have an ID), then create it
    if (id == null) {
      final restHeaders = await headers;

      http.Response response = await httpr.post(Uri.encodeFull(documentUri),
          headers: restHeaders, body: json.encode(data));
      int httpStatusCode = response.statusCode;
      Map<String, dynamic> responseJson = json.decode(response.body);

      if ((httpStatusCode == 200) || (httpStatusCode == 201))
        return DocumentSnapshot._(path, responseJson);

      // All other cases are treated as an error.
      throw CarpServiceException(responseJson["error"],
          description: responseJson["message"],
          httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
    } else {
      return updateData(data);
    }
  }

  /// Updates fields in the document referred to by this [DocumentReference].
  ///
  /// If no document exists yet, the update will fail.
  Future<DocumentSnapshot> updateData(Map<String, dynamic> data) async {
    // if we don't have the document ID, get it first.
    if (id == null) _id = (await this.get()).id;

    final restHeaders = await headers;
    Map<String, dynamic> payload = {'data': data};
    http.Response response = await httpr.put(Uri.encodeFull(documentUri),
        headers: restHeaders, body: json.encode(payload));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == 200) return DocumentSnapshot._(path, responseJson);

    throw CarpServiceException(responseJson["error"],
        description: responseJson["message"],
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Renames the document referred to by this [DocumentReference].
  @Deprecated('Documents cannot be renamed in CANS.')
  Future<DocumentSnapshot> rename(String name) async {
    assert(name != null, 'Document path names cannot be null.');
    assert(name.length > 0, 'Document path names cannot be empty.');
    assert(RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(name),
        'Document name can only contain alphanumeric, hyphen (-), and underscore (_) characters.');

    // if we don't have the document ID, get it first.
    if (id == null) _id = (await this.get()).id;

    final restHeaders = await headers;
    Map<String, dynamic> payload = {'name': name};
    http.Response response = await httpr.put(Uri.encodeFull(documentUri),
        headers: restHeaders, body: json.encode(payload));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    if (httpStatusCode == 200) return DocumentSnapshot._(path, responseJson);

    throw CarpServiceException(responseJson["error"],
        description: responseJson["message"],
        httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
  }

  /// Reads the document referenced by this [DocumentReference].
  ///
  /// If no document exists, the read will return null.
  Future<DocumentSnapshot> get() async {
    final restHeaders = await headers;

    http.Response response =
        await httpr.get(Uri.encodeFull(documentUri), headers: restHeaders);

    int httpStatusCode = response.statusCode;

    if (httpStatusCode == 200)
      return DocumentSnapshot._(path, json.decode(response.body));
    else
      return null;
  }

  /// Deletes the document referred to by this [DocumentReference].
  Future<void> delete() async {
    // if we don't have the document ID, get it first.
    if (id == null) _id = (await this.get()).id;

    final restHeaders = await headers;
    http.Response response =
        await http.delete(Uri.encodeFull(documentUri), headers: restHeaders);

    int httpStatusCode = response.statusCode;
    if (httpStatusCode == 200)
      return;
    else {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      throw CarpServiceException(responseJson["error"],
          description: responseJson["message"],
          httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
    }
  }

  /// Returns the reference of a collection contained inside of this document.
  CollectionReference collection(String name) =>
      service.collection("$path/$name");

  // TODO - this is deprecated and not working for now.
//  /// Fetch the list of collections (names) in this collection.
//  Future<List<String>> get collections async {
//    final rest_headers = await headers;
//
//    // GET the list of collections from the CARP web service
//    // Note that it seems like we can only get a list of collections at the root of the CARP web service, i.e. when [path] == ""
//    http.Response response = await http.get(Uri.encodeFull(collectionUri), headers: rest_headers);
//
//    int httpStatusCode = response.statusCode;
//
//    switch (httpStatusCode) {
//      case 200:
//        {
//          List<dynamic> server_list = json.decode(response.body);
//          List<String> collections = new List<String>();
//          server_list.forEach((c) => collections.add(c.toString()));
//          return collections;
//        }
//      default:
//        // All other cases are treated as an error.
//        {
//          Map<String, dynamic> responseJson = json.decode(response.body);
//          final String error = responseJson["error"];
//          final String description = responseJson["message"];
//          throw CarpServiceException(error,
//              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
//        }
//    }
//  }

  String toString() => 'DocumentReference - id: $id, path: $path';
}

/// A [DocumentSnapshot] contains data read from a collection in the CARP web service
///
/// The data can be extracted with the [data] property or by using subscript
/// syntax to access a specific field.
class DocumentSnapshot {
  DocumentSnapshot._(this._path, this._snapshot);

  final String _path;
  final Map<String, dynamic> _snapshot;

  /// The full data snapshot
  Map<String, dynamic> get snapshot => _snapshot;

  /// The full path to this document
  String get path => _path;

  /// The ID of the snapshot's document
  int get id => _snapshot['id'];

  /// The name of the snapshot's document
  String get name => _snapshot['name'];

  /// The id of the collection this document belongs to
  int get collectionId => _snapshot['collection_id'];

  /// The id of the user who created this document
  String get createdByUserId => _snapshot['created_by_user_id'];

  /// The timestamp of creation of this document
  DateTime get createdAt => DateTime.parse(_snapshot['created_at']);

  /// The timestamp of latest update of this document
  DateTime get updatedAt => DateTime.parse(_snapshot['updated_at']);

  List<String> get collections {
    List<String> collections = new List<String>();
    for (var item in _snapshot['collections']) {
      String key = item["name"];
      collections.add(key);
    }
    return collections;
  }

  /// Contains all the data of this snapshot
  Map<String, dynamic> get data => _snapshot['data'];

  /// Reads individual data values from the snapshot
  dynamic operator [](String key) => data[key];

  /// Returns `true` if the document exists.
  bool get exists => data != null;

  String toString() =>
      "${this.runtimeType} - id: $id, name: $name, path: $path, size: ${data?.length}";
}
