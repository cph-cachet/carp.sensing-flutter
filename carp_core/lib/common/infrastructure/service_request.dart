/*
 * Copyright 2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_common;

/// An abstract base class for all RPC requests to CARP.
abstract class ServiceRequest extends Serializable {
  String apiVersion = "1.1";
}
