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
  static const String NONE = "no-privacy-schema";
  static const String DEFAULT = "default-privacy-schema";

  String get namespace => DEFAULT;
  void onRegister() {}
}
