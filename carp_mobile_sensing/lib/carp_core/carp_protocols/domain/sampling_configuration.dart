/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core;

/// Contains configuration on how to sample a data stream of a given type.
abstract class SamplingConfiguration {}

///Specifies the sampling scheme for a [DataType], including possible options,
///defaults, and constraints.
abstract class DataTypeSamplingScheme {
  /// The [DataType] this sampling scheme relates to.
  DataType type;

  /// The default configuration of a [Measure] for the [type].
  Measure defaultMeasure;
}

/// A helper class to construct iterable objects which hold [DataTypeSamplingScheme]
/// member definitions.
/// This is similar to an enum, but removes the need for an intermediate enum
/// type and generic type parameters are retained per member.
abstract class DataTypeSamplingSchemeList {
  /// Returns a list of [Measure]s from this [DataTypeSamplingSchemeList].
  ///
  /// If [types] are specified, it returns a list of [Measure]s for the
  /// specified [types].
  ///
  /// This method is a convenient way to get a list of pre-configured
  /// measures of the correct type with default settings.
  List<Measure> getMeasureList({List<DataType> types});
}
