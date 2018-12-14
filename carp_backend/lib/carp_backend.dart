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
import 'package:carp_core/carp_core.dart';
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
  String uploadMethod;

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

  /// When uploading to the CARP using the [CarpUploadMethod.OBJECT] method,
  /// [collection] hold the name of the collection to store json objects.
  String collection = DEFAULT_COLLECTION;

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
      bufferSize,
      zip,
      encrypt,
      publicKey})
      : assert(uploadMethod != null),
        super(type: DataEndPointType.CARP, bufferSize: bufferSize, zip: zip, encrypt: encrypt);

  static Function get fromJsonFunction => _$CarpDataEndPointFromJson;
  factory CarpDataEndPoint.fromJson(Map<String, dynamic> json) => _$CarpDataEndPointFromJson(json);
  Map<String, dynamic> toJson() => _$CarpDataEndPointToJson(this);
}

/// A enumeration of upload methods to CARP
class CarpUploadMethod {
  static const String DATA_POINT = "data-point";
  static const String BATCH_DATA_POINT = "batch-data-point";
  static const String FILE = "file";
  static const String OBJECT = "object";
}
