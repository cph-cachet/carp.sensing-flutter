/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A description of how a study is to be executed on a smartphone.
///
/// A [SmartphoneStudyProtocol] defining the primary device ([PrimaryDeviceConfiguration])
/// responsible for aggregating data (typically this phone), the optional
/// devices ([DeviceConfiguration]) connected to the master device,
/// and the [Trigger]'s which lead to data collection on said devices.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SmartphoneStudyProtocol extends StudyProtocol {
  SmartphoneApplicationData _data = SmartphoneApplicationData();

  @override
  Map<String, dynamic> get applicationData => _data.toJson();

  @override
  set applicationData(Map<String, dynamic>? data) => _data = (data != null)
      ? SmartphoneApplicationData.fromJson(data)
      : SmartphoneApplicationData();

  /// The description of this study protocol containing the title, description,
  /// purpose, and the responsible researcher for this study.
  StudyDescription? get protocolDescription => _data.protocolDescription;
  set protocolDescription(StudyDescription? description) =>
      _data.protocolDescription = description;

  @override
  String get description => protocolDescription?.description ?? '';

  /// The PI responsible for this protocol.
  StudyResponsible? get responsible => protocolDescription?.responsible;

  /// Specifies where and how to stored or upload the data collected from this
  /// deployment. If `null`, the sensed data is not stored, but may still be
  /// used in the app.
  DataEndPoint? get dataEndPoint => _data.dataEndPoint;
  set dataEndPoint(DataEndPoint? dataEndPoint) =>
      _data.dataEndPoint = dataEndPoint;

  /// Create a new [SmartphoneStudyProtocol].
  SmartphoneStudyProtocol({
    required super.ownerId,
    required super.name,
    StudyDescription? protocolDescription,
    DataEndPoint? dataEndPoint,
  }) : super(
          description: protocolDescription?.description ?? '',
        ) {
    _data = SmartphoneApplicationData(
        protocolDescription: protocolDescription, dataEndPoint: dataEndPoint);
  }

  factory SmartphoneStudyProtocol.fromJson(Map<String, dynamic> json) =>
      _$SmartphoneStudyProtocolFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SmartphoneStudyProtocolToJson(this);
}

/// Holds application-specific data for a [SmartphoneStudyProtocol].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SmartphoneApplicationData {
  /// The description of this study protocol containing the title, description,
  /// purpose, and the responsible researcher for this study.
  StudyDescription? protocolDescription;

  /// Specifies where and how to stored or upload the data collected from this
  /// deployment. If `null`, the sensed data is not stored, but may still be
  /// used in the app.
  DataEndPoint? dataEndPoint;

  SmartphoneApplicationData({this.protocolDescription, this.dataEndPoint})
      : super();

  factory SmartphoneApplicationData.fromJson(Map<String, dynamic> json) =>
      _$SmartphoneApplicationDataFromJson(json);
  Map<String, dynamic> toJson() => _$SmartphoneApplicationDataToJson(this);
}
