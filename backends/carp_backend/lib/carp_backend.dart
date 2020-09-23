/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

library carp_backend;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_webservices/carp_service/carp_service.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';

part 'carp_data_managers.dart';
part 'carp_backend.g.dart';

/// Specify a CARP Web Service endpoint.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class CarpDataEndPoint extends FileDataEndPoint {
  /// The default collection name.
  static const String DEFAULT_COLLECTION = "carp_sensing";

  /// The method used to upload to CARP -- see [CarpUploadMethod] for options.
  CarpUploadMethod uploadMethod;

  /// The name of the CARP endpoint.
  /// Can be anything, but its recommended to name it according to the CARP service name.
  String name;

  /// The URI of the CARP endpoint.
  String uri;

  /// The CARP web service client ID
  String clientId;

  /// The CARP web service client secret
  String clientSecret;

  /// Email used as username in password authentication.
  String email;

  /// Password used in password authentication.
  ///
  /// TODO : right now in clear text -- not so good.
  String password;

  /// When uploading to the CARP using the [CarpUploadMethod.DOCUMENT] method,
  /// [collection] hold the name of the collection to store json objects.
  String collection = DEFAULT_COLLECTION;

  /// When uploading to CARP using file in the [CarpUploadMethod.BATCH_DATA_POINT]
  /// or [CarpUploadMethod.FILE] methods, specifies if the local file on the phone
  /// should be deleted once uploaded.
  bool deleteWhenUploaded = true;

  /// Creates a [CarpDataEndPoint].
  ///
  /// [uploadMethod] specified the upload method as enumerated in [CarpUploadMethod].
  CarpDataEndPoint(this.uploadMethod,
      {this.name,
      this.uri,
      this.clientId,
      this.clientSecret,
      this.email,
      this.password,
      this.collection,
      this.deleteWhenUploaded = true,
      bufferSize = 500 * 1000, // default buffer size = 500 MB
      zip = true, // zip file pr. default
      encrypt = false, // don't encrypt pr. default
      publicKey})
      : assert(uploadMethod != null),
        super(type: DataEndPointTypes.CARP, bufferSize: bufferSize, zip: zip, encrypt: encrypt, publicKey: publicKey) {
    // the CARP server cannot handle zipped files (yet)
    if (this.uploadMethod == CarpUploadMethod.BATCH_DATA_POINT) {
      this.zip = false;
      this.encrypt = false;
    }
  }

  static Function get fromJsonFunction => _$CarpDataEndPointFromJson;
  factory CarpDataEndPoint.fromJson(Map<String, dynamic> json) => _$CarpDataEndPointFromJson(json);
  Map<String, dynamic> toJson() => _$CarpDataEndPointToJson(this);

  String toString() => 'CARP - $name [$uri]';
}

/// A enumeration of upload methods to CARP
enum CarpUploadMethod { DATA_POINT, BATCH_DATA_POINT, FILE, DOCUMENT }
