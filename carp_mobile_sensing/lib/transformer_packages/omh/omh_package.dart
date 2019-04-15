/// A library for transforming data into the Open mHealth (OMH) data formats.
library omh;

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

class OMHTransformerPackage extends TransformerPackage {
  String get namespace => NameSpace.OMH;
  void onRegister() {}
}

//class CARPLocation2OMHGeoposition extends CARPDatum {}
