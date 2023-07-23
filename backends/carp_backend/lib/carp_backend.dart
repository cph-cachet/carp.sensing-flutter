/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

library carp_backend;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:research_package/model.dart';

part 'carp_data_manager.dart';
part 'data_stream_buffer.dart';
part 'localization_manager.dart';
part 'informed_consent_manager.dart';
part 'carp_resource_manager.dart';
part 'carp_localization.dart';
part 'carp_backend.g.dart';
part 'message_manager.dart';

/// Specify a CARP Web Service (CAWS) endpoint for uploading data.
///
/// If a study deployment is downloaded from CAWS (i.e., via the
/// [CarpDeploymentService]), then the address and authentication used for downloading
/// is used, and the [uri], [clientId], [clientSecret], [email] and [password]
/// need not to be specified.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class CarpDataEndPoint extends DataEndPoint {
  /// The method used to upload to CARP. See [CarpUploadMethod] for options.
  CarpUploadMethod uploadMethod;

  /// A printer-friendly name of the CAWS endpoint. Can be anything, but its
  /// recommended to name it according to the CAWS service name.
  String name;

  /// The URI of the CARP Web Service.
  String? uri;

  /// The CARP web service client ID.
  String? clientId;

  /// The CARP web service client secret.
  String? clientSecret;

  /// Email used as username in password authentication.
  String? email;

  /// Password used in password authentication.
  ///
  /// Note that the password is in **clear text** and should hence only be used
  /// if it is entered by the user locally on the phone.
  String? password;

  /// Only upload when connected via WiFi network?
  bool onlyUploadOnWiFi = false;

  /// How often should data be uploaded. In minutes.
  int uploadInterval = 10;

  /// Should the local buffered data on the phone be deleted once uploaded?
  bool deleteWhenUploaded = true;

  /// Creates a [CarpDataEndPoint].
  CarpDataEndPoint({
    this.uploadMethod = CarpUploadMethod.stream,
    this.name = 'CARP Web Services',
    this.uri,
    this.clientId,
    this.clientSecret,
    this.email,
    this.password,
    this.onlyUploadOnWiFi = false,
    this.uploadInterval = 10,
    this.deleteWhenUploaded = true,
    super.dataFormat,
  }) : super(
          type: DataEndPointTypes.CAWS,
        );

  /// Creates a [CarpDataEndPoint] based on a [CarpApp] [app].
  CarpDataEndPoint.fromCarpApp({
    CarpUploadMethod uploadMethod = CarpUploadMethod.stream,
    bool onlyUploadOnWiFi = false,
    int uploadInterval = 10,
    bool deleteWhenUploaded = true,
    String dataFormat = NameSpace.CARP,
    required CarpApp app,
  }) : this(
          uploadMethod: uploadMethod,
          name: app.name,
          uri: app.uri.toString(),
          clientId: app.oauth.clientID,
          clientSecret: app.oauth.clientSecret,
          dataFormat: dataFormat,
          onlyUploadOnWiFi: onlyUploadOnWiFi,
          uploadInterval: uploadInterval,
          deleteWhenUploaded: deleteWhenUploaded,
        );

  Function get fromJsonFunction => _$CarpDataEndPointFromJson;

  factory CarpDataEndPoint.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory().fromJson(json) as CarpDataEndPoint;
  Map<String, dynamic> toJson() => _$CarpDataEndPointToJson(this);

  String toString() =>
      '$runtimeType [$name] - method: ${uploadMethod.toString().split('.').last}';
}

/// A enumeration of upload methods to CAWS
enum CarpUploadMethod {
  /// Upload data as data streams (the default method).
  stream,

  /// Upload measurements as data points using the non-core DataPoint endpoint.
  datapoint,

  /// Collect measurements in a SQLite DB file and upload as a `db` file.
  file,
}

/// Exception for CAWS communication.
class CarpBackendException implements Exception {
  String? message;
  CarpBackendException([this.message]);
  String toString() => "$runtimeType - ${message ?? ""}";
}
