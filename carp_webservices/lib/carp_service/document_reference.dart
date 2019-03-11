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
/// `/collections/activities/running/geopositions/pos_1`
///
/// is a reference to the geoposition document `pos_1` in the collection `geopositions` in the document `running`
/// in the collection `activities`.
class CollectionReference extends CarpReference {
  String _path;

  /// Creates a [CollectionReference] based on the path to the
  /// collection, relative to the root of the web service.
  ///
  /// Note that [path] should be absolute and start with `/`.
  /// For example; `/activities/running/geopositions`
  CollectionReference._(CarpService service, this._path)
      : assert(_path != null),
        assert(_path.startsWith('/') || _path.length == 0),
        super._(service);

  /// ID of the referenced collection.
  int get id => ??;

  /// Returns the path of this collection (relative to the root of the web service).
  String get path {
    return _path;
  }

  /// The full CARP web service path to this collection.
  String get carpPath {
    return "/api/studies/${service.app.study.id}/collections$path";
  }

  /// The URL for the collection endpoint for this [CollectionReference].
  String get collectionUri => "${service.app.uri.toString()}$carpPath";


  //TODO -- this has to be removed

  /// Fetch the list of collections (names) in this collection.
  ///
  /// TODO - it seems like this only works at the root of the CARP web service.
  Future<List<String>> get collections async {
    final rest_headers = await headers;

    // GET the list of collections from the CARP web service
    // Note that it seems like we can only get a list of collections at the root of the CARP web service, i.e. when [path] == ""
    http.Response response = await http.get(Uri.encodeFull(collectionUri), headers: rest_headers);

    int httpStatusCode = response.statusCode;

    switch (httpStatusCode) {
      case 200:
        {
          List<dynamic> server_list = json.decode(response.body);
          List<String> collections = new List<String>();
          server_list.forEach((c) => collections.add(c.toString()));
          return collections;
        }
      default:
        // All other cases are treated as an error.
        {
          Map<String, dynamic> responseJson = json.decode(response.body);
          final String error = responseJson["error"];
          final String description = responseJson["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }




  /// Get the documents in this collection.
  Future<List<DocumentSnapshot>> get documents async {
    final rest_headers = await headers;

    // GET the list of documents in this collection from the CARP web service
    http.Response response = await http.get(Uri.encodeFull(collectionUri), headers: rest_headers);
    int httpStatusCode = response.statusCode;

    switch (httpStatusCode) {
      case 200:
        {
          List<dynamic> server_list = json.decode(response.body);
          List<DocumentSnapshot> documents = new List<DocumentSnapshot>();
          for (var item in server_list) {
            Map<String, dynamic> documentJson = item;
            String key = documentJson["id"];
            documents.add(DocumentSnapshot._("$path/$key", documentJson));
          }
          return documents;
        }
      default:
        // All other cases are treated as an error.
        {
          Map<String, dynamic> responseJson = json.decode(response.body);
          final String error = responseJson["error"];
          final String description = responseJson["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }

  /// Returns a [DocumentReference] with the provided id in this collection.
  ///
  /// If no [id] is provided, an auto-generated ID is used.
  DocumentReference document([String id]) {
    return DocumentReference._(service, this, id);
  }

  /// Add a data document to this collection.
  ///
  /// Returns a [DocumentReference] with an auto-generated ID, after
  /// populating it with provided [data].
  Future<DocumentReference> add(Map<String, dynamic> data) async {
    final DocumentReference newDocument = document();
    await newDocument.setData(data);
    return newDocument;
  }
}

/// A [DocumentReference] refers to a document in a CARP collection
/// and can be used to write, read, or delete this object.
///
/// The object with the referenced id may or may not exist.
/// If the object does not yet exist, it will be created.
/// If the collection does not yet exist, it will be created.
///
/// TODO:
/// A [DocumentReference] can also be used to create a [CollectionReference]
/// to a sub-collection.
class DocumentReference extends CarpReference {
  String _id;
  CollectionReference _collection;

  DocumentReference._(CarpService service, this._collection, this._id)
      : assert(_collection != null),
        super._(service);

  /// The unique id of this object.
  String get id => _id;

  /// The full URI path to this object.
  String get objectUri => "${_collection.collectionUri}/$id";

  /// The CARP path to this object.
  String get carpPath => "${_collection.carpPath}/$id";

  /// Writes to the object referred to by this [DocumentReference].
  ///
  /// If the object does not yet exist, it will be created.
  /// If the collection does not yet exist, it will be created.
  /// Returns a [DocumentSnapshot] with the ID generated at the server side.
  Future<DocumentSnapshot> setData(Map<String, dynamic> data) async {
    // Remember that the CARP collection service generated the ID and returns it in a POST.

    // If this object does not already exist on the server (i.e., have an ID), then create it
    if ((id == null) || (id.length == 0)) {
      final rest_headers = await headers;

      http.Response response =
          await http.post(Uri.encodeFull(_collection.collectionUri), headers: rest_headers, body: json.encode(data));
      int httpStatusCode = response.statusCode;
      Map<String, dynamic> responseJson = json.decode(response.body);

      // get the id generated from the server
      _id = responseJson["id"];

      switch (httpStatusCode) {
        // CARP web service returns "201 Created" when created.
        case 200:
        case 201:
          {
            return DocumentSnapshot._(carpPath, responseJson);
          }
        default:
          // All other cases are treated as an error.
          {
            final String error = responseJson["error"];
            final String description = responseJson["error_description"];
            throw CarpServiceException(error,
                description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
          }
      }
    } else {
      return updateData(data);
    }
  }

  /// Updates fields in the object referred to by this [DocumentReference].
  ///
  /// If no object exists yet, the update will fail.
  Future<DocumentSnapshot> updateData(Map<String, dynamic> data) async {
    final rest_headers = await headers;

    http.Response response = await http.put(Uri.encodeFull(objectUri), headers: rest_headers, body: json.encode(data));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    switch (httpStatusCode) {
      case 200:
        {
          return DocumentSnapshot._(carpPath, responseJson);
        }
      default:
        {
          final String error = responseJson["error"];
          final String description = responseJson["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }

  /// Reads the document referenced by this [DocumentReference].
  ///
  /// If no object exists, the read will return null.
  Future<DocumentSnapshot> get() async {
    final rest_headers = await headers;

    http.Response response = await http.get(Uri.encodeFull(objectUri), headers: rest_headers);

    int httpStatusCode = response.statusCode;
    switch (httpStatusCode) {
      case 200:
        {
          Map<String, dynamic> responseJson = json.decode(response.body);
          return DocumentSnapshot._(carpPath, responseJson);
        }
      default:
        return null;
    }
  }

  /// Deletes the object referred to by this [DocumentReference].
  Future<void> delete() async {
    final rest_headers = await headers;

    http.Response response = await http.delete(Uri.encodeFull(objectUri), headers: rest_headers);

    int httpStatusCode = response.statusCode;
    switch (httpStatusCode) {
      case 200:
        {
          return;
        }
      default:
        {
          final Map<String, dynamic> responseJson = json.decode(response.body);
          final String error = responseJson["error"];
          final String description = responseJson["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }

  /// Returns the reference of a collection contained inside of this
  /// document.
  ///
  /// TODO - this needs to be supported on the web service side of CARP....
  CollectionReference collection(String name) {
    // TODO - implement this...
    return CollectionReference._(service, name);
  }
}

/// A [DocumentSnapshot] contains data read from a collection in the CARP web service
///
/// The data can be extracted with the [data] property or by using subscript
/// syntax to access a specific field.
class DocumentSnapshot {
  DocumentSnapshot._(this._path, this.data);

  final String _path;

  /// The reference that produced this object
  //ObjectReference get reference => _firestore.document(_path);

  /// Contains all the data of this snapshot
  final Map<String, dynamic> data;

  /// Reads individual values from the snapshot
  dynamic operator [](String key) => data[key];

  /// Returns the ID of the snapshot's object
  String get id => _path.split('/').last;

  /// Returns `true` if the object exists.
  bool get exists => data != null;

  String toString() => "ObjectSnapshot - id: $id, data size: ${data.length}";
}
