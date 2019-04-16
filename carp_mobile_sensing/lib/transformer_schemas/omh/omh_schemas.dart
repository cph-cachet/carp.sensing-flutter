/// A library for transforming data into the Open mHealth (OMH) data formats.
library omh;

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// A default [TransformerSchema] for Open mHealth (OMH) transformers
class OMHTransformerSchema extends TransformerSchema {
  String get namespace => NameSpace.OMH;
  void onRegister() {}
}
