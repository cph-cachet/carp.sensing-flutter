/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of domain;

/// A enumeration of known sampling schemas types.
class SamplingSchemaType {
  static const String MAXIMUM = 'MAXIMUM';
  static const String COMMON = 'COMMON';
  static const String NORMAL = 'NORMAL';
  static const String LIGHT = 'LIGHT';
  static const String MINIMUM = 'MINIMUM';
  static const String NONE = 'NONE';
  static const String DEBUG = 'DEBUG';
}
