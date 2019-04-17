/*
 * Copyright 2019 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A library of default privacy enhancing transformers.
library privacy;

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// A default [TransformerSchema] for privacy transformers
class PrivacySchema extends TransformerSchema {
  static const String DEFAULT_PRIVACY_SCHEMA = "default-privacy-schema";

  String get namespace => DEFAULT_PRIVACY_SCHEMA;
  void onRegister() {}
}
