/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_services;

/// Provide a deployment endpoint reference to a CARP web service. Used to:
/// - get a deployment configuration for a master device (typically a phone)
/// - set deployment success status
/// - query deployment status
/// - register and unregister this device as part of a deployment
class DeploymentReference extends CarpReference {
  /// The CARP deployment ID.
  String get id => service.app.study.deploymentId;

  /// The device role name for this master device.
  ///
  /// Default name is `phone`.
  String masterDeviceRoleName = 'phone';

  DeploymentReference._(CarpService service, [this.masterDeviceRoleName = 'phone']) : super._(service) {
    this.masterDeviceRoleName ??= 'phone';
  }

  /// The URL for the deployment end point for this [DeploymentReference].
  String get deploymentEndpointUri => "${service.app.uri.toString()}/api/deployments/$id/devices?masterDeviceRoleName=$masterDeviceRoleName";

  /// Get the deployment object at the server for this [DeploymentReference].
  Future<StudyDeploymentSnapshot> get() async {
    final restHeaders = await headers;

    print('uri :: $deploymentEndpointUri');

    http.Response response = await httpr.get(Uri.encodeFull(deploymentEndpointUri), headers: restHeaders);
    int httpStatusCode = response.statusCode;

    Map<String, dynamic> responseJson = json.decode(response.body);

    print(httpStatusCode);
    print(responseJson.toString());

    if (httpStatusCode == HttpStatus.ok) return StudyDeploymentSnapshot._(id, masterDeviceRoleName, null);

    // All other cases are treated as an error.
    throw CarpServiceException(
      httpStatus: HTTPStatus(httpStatusCode, response.reasonPhrase),
      message: responseJson["message"],
    );
  }

  Future<bool> success() async {
    return true;
  }

  Future<StudyDeploymentStatus> status() async {
    return StudyDeploymentStatus._(id, null);
  }

  Future<bool> registerDevice() async {
    return true;
  }

  Future<bool> unRegisterDevice() async {
    return true;
  }
}

/// A [StudyDeploymentSnapshot] contains data read from a deployment in the CARP web service
///
/// The data can be extracted with the [data] property or by using subscript
/// syntax to access a specific field.
class StudyDeploymentSnapshot {
  StudyDeploymentSnapshot._(this._id, this._masterDeviceRoleName, this._snapshot);

  String _id;
  String _masterDeviceRoleName;
  final Map<String, dynamic> _snapshot;

  /// The CARP deployment ID.
  String get id => _id;

  /// The device role name for this master device.
  String get masterDeviceRoleName => _masterDeviceRoleName;

  /// The full data snapshot
  Map<String, dynamic> get snapshot => _snapshot;

//  /// The ID of the snapshot's document
//  int get id => _snapshot['id'];
//
//  /// The name of the snapshot's document
//  String get name => _snapshot['name'];
//
//  /// The id of the collection this document belongs to
//  int get collectionId => _snapshot['collection_id'];
//
//  /// The id of the user who created this document
//  String get createdByUserId => _snapshot['created_by_user_id'];
//
//  /// The timestamp of creation of this document
//  DateTime get createdAt => DateTime.parse(_snapshot['created_at']);
//
//  /// The timestamp of latest update of this document
//  DateTime get updatedAt => DateTime.parse(_snapshot['updated_at']);

  /// Contains all the data of this snapshot
  Map<String, dynamic> get data => _snapshot['data'];

  /// Reads individual data values from the snapshot
  dynamic operator [](String key) => data[key];

  /// Returns `true` if the document exists.
  bool get exists => data != null;

  String toString() => "${this.runtimeType} - deploymentId: $id, masterDeviceRoleName: $masterDeviceRoleName,  size: ${data?.length}";
}

/// A [StudyDeploymentStatus] contains data read from a deployment in the CARP web service
///
/// The data can be extracted with the [data] property or by using subscript
/// syntax to access a specific field.
class StudyDeploymentStatus {
  StudyDeploymentStatus._(this._id, this._snapshot);

  String _id;
  final Map<String, dynamic> _snapshot;

  /// The CARP deployment ID.
  String get id => _id;

  /// The full data snapshot
  Map<String, dynamic> get snapshot => _snapshot;

//  /// The ID of the snapshot's document
//  int get id => _snapshot['id'];
//
//  /// The name of the snapshot's document
//  String get name => _snapshot['name'];
//
//  /// The id of the collection this document belongs to
//  int get collectionId => _snapshot['collection_id'];
//
//  /// The id of the user who created this document
//  String get createdByUserId => _snapshot['created_by_user_id'];
//
//  /// The timestamp of creation of this document
//  DateTime get createdAt => DateTime.parse(_snapshot['created_at']);
//
//  /// The timestamp of latest update of this document
//  DateTime get updatedAt => DateTime.parse(_snapshot['updated_at']);

  /// Contains all the data of this snapshot
  Map<String, dynamic> get data => _snapshot['data'];

  /// Reads individual data values from the snapshot
  dynamic operator [](String key) => data[key];

  /// Returns `true` if the document exists.
  bool get exists => data != null;

  String toString() => "${this.runtimeType} - deploymentId: $id, size: ${data?.length}";
}
