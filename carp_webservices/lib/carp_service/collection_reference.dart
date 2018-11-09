/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_service;

/// Provide a collection reference to a CARP web service.
///
/// The Collections endpoint allows you to store and query custom objects to
/// suit your specific application's needs.
class CollectionReference extends CarpReference {
  String _path;

  CollectionReference._(CarpService service, this._path)
      : assert(_path != null),
        assert(_path.startsWith('/') || _path.length == 0),
        super._(service);

  /// Returns the path of this collection (relative to the root of the database).
  /// Note that [path] should be absolute and start with `/`.
  String get path {
    return _path;
  }

  /// The full CARP path to this collection.
  String get carpPath {
    return "/api/studies/${service.app.study.id}/collections$path";
  }

  /// The URL for the collection end point for this [CollectionReference].
  String get collectionUri => "${service.app.uri.toString()}$carpPath";

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
        // TODO - later we can handle more HTTP status codes here.
        {
          Map<String, dynamic> responseJson = json.decode(response.body);
          final String error = responseJson["error"];
          final String description = responseJson["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }

  /// Fetch the objects in this collection.
  Future<List<ObjectSnapshot>> get objects async {
    final rest_headers = await headers;

    // GET the list of objects in this collection from the CARP web service
    http.Response response = await http.get(Uri.encodeFull(collectionUri), headers: rest_headers);
    int httpStatusCode = response.statusCode;

    switch (httpStatusCode) {
      case 200:
        {
          List<dynamic> server_list = json.decode(response.body);
          List<ObjectSnapshot> objects = new List<ObjectSnapshot>();
          for (var item in server_list) {
            //print(json.encode(item));
            //Map<String, dynamic> objectJson = json.decode(item);
            Map<String, dynamic> objectJson = item;
            String key = objectJson["id"];
            objects.add(ObjectSnapshot._("$path/$key", objectJson));
          }
          return objects;
        }
      default:
        // All other cases are treated as an error.
        // TODO - later we can handle more HTTP status codes here.
        {
          Map<String, dynamic> responseJson = json.decode(response.body);
          final String error = responseJson["error"];
          final String description = responseJson["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }

  /// Returns a `ObjectReference` with the provided id in this collection.
  ///
  /// If no [id] is provided, an auto-generated ID is used.
  ObjectReference object([String id]) {
    return ObjectReference._(service, this, id);
  }

  /// Add a data object to this collection.
  ///
  /// Returns a `ObjectReference` with an auto-generated ID, after
  /// populating it with provided [data].
  Future<ObjectReference> add(Map<String, dynamic> data) async {
    final ObjectReference newObject = object();
    await newObject.setData(data);
    return newObject;
  }
}

/// A [ObjectReference] refers to an object in a CARP collection
/// and can be used to write, read, or delete this object.
///
/// The object with the referenced id may or may not exist.
/// If the object does not yet exist, it will be created.
/// If the collection does not yet exist, it will be created.
///
/// TODO:
/// A [ObjectReference] can also be used to create a [CollectionReference]
/// to a sub-collection.
class ObjectReference extends CarpReference {
  String _id;
  CollectionReference _collection;

  ObjectReference._(CarpService service, this._collection, this._id)
      : assert(_collection != null),
        super._(service);

  /// The unique id of this object.
  String get id => _id;

  /// The full URI path to this object.
  String get objectUri => "${_collection.collectionUri}/$id";

  /// The CARP path to this object.
  String get carpPath => "${_collection.carpPath}/$id";

  /// Writes to the object referred to by this [ObjectReference].
  ///
  /// If the object does not yet exist, it will be created.
  /// If the collection does not yet exist, it will be created.
  /// Returns a [ObjectSnapshot] with the ID generated at the server side.
  Future<ObjectSnapshot> setData(Map<String, dynamic> data) async {
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
            return ObjectSnapshot._(carpPath, responseJson);
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

    //response.reasonPhrase;
  }

  /// Updates fields in the object referred to by this [ObjectReference].
  ///
  /// If no object exists yet, the update will fail.
  Future<ObjectSnapshot> updateData(Map<String, dynamic> data) async {
    final rest_headers = await headers;

    http.Response response = await http.put(Uri.encodeFull(objectUri), headers: rest_headers, body: json.encode(data));

    int httpStatusCode = response.statusCode;
    Map<String, dynamic> responseJson = json.decode(response.body);

    switch (httpStatusCode) {
      case 200:
        {
          return ObjectSnapshot._(carpPath, responseJson);
        }
      default:
        // All other cases are treated as an error.
        // TODO - later we can handle more HTTP status codes here.
        {
          final String error = responseJson["error"];
          final String description = responseJson["error_description"];
          throw CarpServiceException(error,
              description: description, httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase));
        }
    }
  }

  /// Reads the object referenced by this [ObjectReference].
  ///
  /// If no object exists, the read will return null.
  Future<ObjectSnapshot> get() async {
    final rest_headers = await headers;

    http.Response response = await http.get(Uri.encodeFull(objectUri), headers: rest_headers);

    int httpStatusCode = response.statusCode;
    switch (httpStatusCode) {
      case 200:
        {
          Map<String, dynamic> responseJson = json.decode(response.body);
          return ObjectSnapshot._(carpPath, responseJson);
        }
      default:
        // All other cases are treated as a null response.
        return null;
    }
  }

  /// Deletes the object referred to by this [ObjectReference].
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
        // All other cases are treated as an error.
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

/// A ObjectSnapshot contains data read from a collection in CARP web service
///
/// The data can be extracted with the data property or by using subscript
/// syntax to access a specific field.
class ObjectSnapshot {
  ObjectSnapshot._(this._path, this.data);

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
