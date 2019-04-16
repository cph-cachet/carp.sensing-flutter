/// A library of default privacy enhancing transformers.
library privacy;

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// A default [TransformerSchema] for privacy transformers
class PrivacySchema extends TransformerSchema {
  static const String DEFAULT = "default";

  String get namespace => DEFAULT;
  void onRegister() {}
}
