// /*
//  * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
//  * Technical University of Denmark (DTU).
//  * Use of this source code is governed by a MIT-style license that can be
//  * found in the LICENSE file.
//  */
// part of domain;

// /// Specifies the type of a [Measure] or [DataPoint].
// ///
// /// Defines a type of data which can be processed by the platform
// /// (e.g., measured / collected / uploaded).
// /// This is used by the infrastructure to determine whether the requested data
// /// can be collected on a device, how to upload it, how to process it in a
// /// secondary data stream, or how triggers can act on it.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class DataType extends carp_core_domain.Serializable
//     with carp_core_domain.DataType {
//   /// The data type namespace. See [NameSpace].
//   ///
//   /// Uniquely identifies the organization/person who determines how to
//   /// interpret [name].
//   /// To prevent conflicts, a reverse domain namespace is suggested:
//   /// e.g., "org.openmhealth" or "dk.cachet.carp".
//   String namespace;

//   /// The name of this data format. See [CAMSDataType].
//   ///
//   /// Uniquely identifies something within the [namespace].
//   /// The name may not contain any periods. Periods are reserved for namespaces.
//   String name;

//   /// Create a [DataType].
//   DataType(this.namespace, this.name) : super();

//   Function get fromJsonFunction => _$DataTypeFromJson;
//   factory DataType.fromJson(Map<String, dynamic> json) => FromJsonFactory()
//       .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
//   Map<String, dynamic> toJson() => _$DataTypeToJson(this);

//   String toString() => '$namespace.$name';

//   bool operator ==(other) {
//     if (other is! DataType) return false;
//     return (other.namespace == namespace && other.name == name);
//   }

//   // taken from https://dart.dev/guides/libraries/library-tour#implementing-map-keys
//   int get hashCode {
//     var result = 17;
//     result = 37 * result + namespace.hashCode;
//     result = 37 * result + name.hashCode;
//     return result;
//   }
// }
