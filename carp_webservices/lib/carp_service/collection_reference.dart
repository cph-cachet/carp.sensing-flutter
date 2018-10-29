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
        super._(service);

  /// Returns the path of this collection.
  String get path {
    return _path;
  }

  /// Returns the full CARP path to this collection.
  String get carpPath {
    return "/api/studies/${service.app.study.id}/collections/$path";
  }

  /// Fetch the collections in this collection.
  ///
  /// TODO - it seems like this only works at the root of the CARP web service.
  Future<List<CollectionReference>> get collections async {
    // TODO - implement call to CARP;
    // Note that it seems like we can only get a list of collections at the root of the CARP web service, i.e. when [path] == ""
    return [
      CollectionReference._(service, "A"),
      CollectionReference._(service, "B"),
      CollectionReference._(service, "C")
    ];
  }

  /// Fetch the objects in this collection.
  Future<List<ObjectSnapshot>> get objects async {
    // TODO - implement call to CARP
    Map<String, dynamic> data = Map<String, dynamic>();
    return [ObjectSnapshot._(path, data)];
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

/// A [ObjectReference] refers to an object location in a CARP collection
/// and can be used to write, read, or delete this object.
///
/// The object at the referenced location may or may not exist.
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

  /// Returns the id of this object.
  String get id {
    return _id;
  }

  /// Returns the full CARP path to this object.
  String get carpPath {
    return "/api/studies/${service.app.study.id}/collections/${_collection.path}/$id";
  }

  /// Writes to the object referred to by this [ObjectReference].
  ///
  /// If the object does not yet exist, it will be created.
  /// Returns the generated ID of this object.
  Future<String> setData(Map<String, dynamic> data) async {
    // TODO - implement this...
    // Remember that the CARP collection service generated the ID and returns it in a POST.
    return _id;
  }

  /// Updates fields in the object referred to by this [ObjectReference].
  ///
  /// If no document exists yet, the update will fail.
  Future<void> updateData(Map<String, dynamic> data) {
    // TODO - implement this...
    return null;
  }

  /// Reads the object referenced by this [ObjectReference].
  ///
  /// If no object exists, the read will return null.
  Future<ObjectSnapshot> get() async {
    // TODO - implement this...
    return ObjectSnapshot._(carpPath, Map<String, dynamic>());
  }

  /// Deletes the object referred to by this [ObjectReference].
  Future<void> delete() {
    // TODO - implement this...
    return null;
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
  String get objectID => _path.split('/').last;

  /// Returns `true` if the object exists.
  bool get exists => data != null;
}
