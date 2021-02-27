/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_domain;

/// A [Measure] holds information about what measure to do/collect for a
/// [TaskDescriptor] in a [StudyProtocol].
class Measure {
  /// The type of measure to do.
  DataType type;

  /// A printer-friendly name for this measure.
  String name;

  /// A longer description of this measure.
  String description;

  /// Whether the measure is enabled - i.e. collecting data - when the
  /// study is running.
  /// A measure is enabled as default.
  bool enabled = true;

  /// A key-value map holding any application-specific configuration.
  Map<String, String> configuration = {};

  Measure({
    @required this.type,
    this.name,
    this.description,
    this.enabled = true,
  }) : super() {
    enabled = enabled ?? true;
  }

  /// Add a key-value pair as configuration for this measure.
  void setConfiguration(String key, String configuration) =>
      this.configuration[key] = configuration;

  /// Get value from the configuration for this measure.
  String getConfiguration(String key) => configuration[key];
}
