/*
 * Copyright 2024 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of 'carp_services.dart';

/// Zip the [json] JSON.
List<int> zipJson(Map<String, dynamic> json) => zipString(toJsonString(json));
// String zipJson(Map<String, dynamic> json) => zipString(toJsonString(json));

/// Zip the [str] string.
// String zipString(String str) => base64.encode(gzip.encode(utf8.encode(str)));
List<int> zipString(String str) => gzip.encode(utf8.encode(str));
