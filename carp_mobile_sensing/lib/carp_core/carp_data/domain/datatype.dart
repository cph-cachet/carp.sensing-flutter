/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
part of carp_core_domain;

/// Specifies the type of a [Measure] or [DataPoint].
///
/// Defines a type of data which can be processed by the platform
/// (e.g., measured / collected / uploaded).
/// This is used by the infrastructure to determine whether the requested data
/// can be collected on a device, how to upload it, how to process it in a
/// secondary data stream, or how triggers can act on it.
class DataType {
  /// The data type namespace. See [NameSpace].
  ///
  /// Uniquely identifies the organization/person who determines how to
  /// interpret [name].
  /// To prevent conflicts, a reverse domain namespace is suggested:
  /// e.g., "org.openmhealth" or "dk.cachet.carp".
  String namespace;

  /// The name of this data format. See [DataType].
  ///
  /// Uniquely identifies something within the [namespace].
  /// The name may not contain any periods. Periods are reserved for namespaces.
  String name;

  // /// Create a [DataType].
  // DataType(this.namespace, this.name) : super();

  String toString() => '$namespace.$name';

  bool operator ==(other) {
    if (other is! DataType) return false;
    return (other.namespace == namespace && other.name == name);
  }

  // taken from https://dart.dev/guides/libraries/library-tour#implementing-map-keys
  int get hashCode {
    var result = 17;
    result = 37 * result + namespace.hashCode;
    result = 37 * result + name.hashCode;
    return result;
  }
}

/// Enumeration of data type namespaces.
///
/// Namespaces are used in specification of [DataType] both when sensing
/// and uploading [Data].
///
/// Currently know namespaces include:
/// * `org.openmhealth` : Open mHealth
/// * `dk.cachet.carp`  : CACHET Research Platform (CARP)
class NameSpace {
  static const String UNKNOWN = 'unknown';
  static const String OMH = 'org.openmhealth';
  static const String CARP = 'dk.cachet.carp';
}
