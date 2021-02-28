/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_domain;

/// Contains configuration on how to sample a data stream of a given type.
abstract class SamplingConfiguration {}

///Specifies the sampling scheme for a [DataType], including possible options,
///defaults, and constraints.
abstract class DataTypeSamplingScheme {
  /// The [DataType] this sampling scheme relates to.
  DataType type;
}
