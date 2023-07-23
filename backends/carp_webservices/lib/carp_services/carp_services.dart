/*
 * Copyright 2018-2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

library carp_services;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_webservices/carp_auth/carp_auth.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'carp_base_service.dart';
part 'carp_service.dart';
part 'deployment_service.dart';
part 'participation_service.dart';
part 'protocol_service.dart';
part 'data_stream_service.dart';
part 'data_stream_reference.dart';
part 'carp_app.dart';
part 'carp_tasks.dart';
part 'consent_document.dart';
part 'carp_references.dart';
part 'data_point_reference.dart';
part 'data_point.dart';
part 'deployment_reference.dart';
part 'participation_reference.dart';
part 'collection_reference.dart';
part 'document_reference.dart';
part 'file_reference.dart';
part 'http_retry.dart';
part 'push_id_generator.dart';
part 'authentication_form.dart';
part 'authentication_dialog.dart';
part 'invitations_dialog.dart';

part 'carp_services.g.dart';

// String _encode(Object object) =>
//     const JsonEncoder.withIndent(' ').convert(object);

/// Exception for CARP REST/HTTP service communication.
class CarpServiceException implements Exception {
  HTTPStatus? httpStatus;
  String? message;
  String? path;

  CarpServiceException({this.httpStatus, this.message, this.path});

  String toString() =>
      "CarpServiceException: ${(httpStatus != null) ? httpStatus.toString() + " - " : ""} ${message ?? ""} - ${path ?? ""}";
}

/// Implements HTTP Response Code and associated Reason Phrase.
/// See https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
class HTTPStatus {
  /// Mapping of the most common HTTP status code to text.
  /// See https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
  static const Map<int, String> httpStatusPhrases = {
    100: "Continue",
    200: "OK",
    201: "Created",
    202: "Accepted",
    300: "Multiple Choices",
    301: "Moved Permanently",
    400: "Bad Request",
    401: "Unauthorized",
    402: "Payment Required",
    403: "Forbidden",
    404: "Not Found",
    405: "Method Not Allowed",
    408: "Request Timeout",
    409: "Conflict",
    410: "Gone",
    500: "Internal Server Error",
    501: "Not Implemented",
    502: "Bad Gateway",
    503: "Service Unavailable",
    504: "Gateway Timeout",
    505: "HTTP Version Not Supported",
  };

  int httpResponseCode;
  String? httpReasonPhrase;

  HTTPStatus(this.httpResponseCode, [String? httpPhrase]) {
    this.httpReasonPhrase = ((httpPhrase == null) || (httpPhrase.length == 0))
        ? httpStatusPhrases[httpResponseCode]
        : httpPhrase;
  }

  String toString() => "$httpResponseCode $httpReasonPhrase";
}
