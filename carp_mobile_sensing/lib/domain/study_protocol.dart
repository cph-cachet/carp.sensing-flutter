/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A description of how a study is to be executed on a smartphone.
///
/// A [SmartphoneStudyProtocol] defining the master device ([MasterDeviceDescriptor])
/// responsible for aggregating data (typically this phone), the optional
/// devices ([DeviceDescriptor]) connected to the master device,
/// and the [Trigger]'s which lead to data collection on said devices.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SmartphoneStudyProtocol extends StudyProtocol {
  /// The description of this study protocol containing the title, description,
  /// purpose, and the responsible researcher for this study.
  StudyDescription? protocolDescription;

  /// The PI responsible for this protocol.
  StudyReponsible? get responsible => protocolDescription?.responsible;

  /// The sampling strategy used in this study based on the standard
  /// [SamplingSchemaType] types.
  SamplingSchemaType samplingStrategy;

  /// Specifies where and how to stored or upload the data collected from this
  /// deployment. If `null`, the sensed data is not stored, but may still be
  /// used in the app.
  DataEndPoint? dataEndPoint;

  /// Create a new [SmartphoneStudyProtocol].
  SmartphoneStudyProtocol({
    required String ownerId,
    required String name,
    this.protocolDescription,
    this.samplingStrategy = SamplingSchemaType.normal,
  }) : super(
          ownerId: ownerId,
          name: name,
          description: protocolDescription?.description,
        );

  factory SmartphoneStudyProtocol.fromJson(Map<String, dynamic> json) =>
      _$SmartphoneStudyProtocolFromJson(json);
  Map<String, dynamic> toJson() => _$SmartphoneStudyProtocolToJson(this);

  String toString() => '${super.toString()}, description: $protocolDescription';
}
