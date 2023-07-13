/*
 * Copyright 2018-2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of domain;

/// A mixin holding smartphone-specific data for a [SmartphoneStudyProtocol] and
/// [SmartphoneDeployment].
mixin SmartphoneProtocolExtension {
  SmartphoneApplicationData _data = SmartphoneApplicationData();

  Map<String, dynamic>? get applicationData => _data.toJson();

  set applicationData(Map<String, dynamic>? data) => _data = (data != null)
      ? SmartphoneApplicationData.fromJson(data)
      : SmartphoneApplicationData();

  /// The description of this study protocol containing the title, description,
  /// purpose, and the responsible researcher for this study.
  @JsonKey(includeFromJson: false, includeToJson: false)
  StudyDescription? get studyDescription => _data.studyDescription;
  set studyDescription(StudyDescription? description) =>
      _data.studyDescription = description;

  String get description => studyDescription?.description ?? '';

  /// The PI responsible for this protocol.
  @JsonKey(includeFromJson: false, includeToJson: false)
  StudyResponsible? get responsible => studyDescription?.responsible;

  /// Specifies where and how to stored or upload the data collected from this
  /// deployment. If `null`, the sensed data is not stored, but may still be
  /// used in the app.
  @JsonKey(includeFromJson: false, includeToJson: false)
  DataEndPoint? get dataEndPoint => _data.dataEndPoint;
  set dataEndPoint(DataEndPoint? dataEndPoint) =>
      _data.dataEndPoint = dataEndPoint;

  void addApplicationData(String key, dynamic value) {
    _data.applicationData ??= {};
    _data.applicationData?[key] = value;
  }

  dynamic getApplicationData(String key) => _data.applicationData?[key];

  void removeApplicationData(String key) => _data.applicationData?.remove(key);
}

/// Holds application-specific data for a [SmartphoneStudyProtocol].
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SmartphoneApplicationData {
  /// The description of this study protocol containing the title, description,
  /// purpose, and the responsible researcher for this study.
  StudyDescription? studyDescription;

  /// Specifies where and how to stored or upload the data collected from this
  /// deployment. If `null`, the sensed data is not stored, but may still be
  /// used in the app.
  DataEndPoint? dataEndPoint;

  /// Application-specific data to be stored as part of the study protocol
  /// which will be included in all deployments of this study protocol.
  Map<String, dynamic>? applicationData;

  SmartphoneApplicationData({
    this.studyDescription,
    this.dataEndPoint,
    this.applicationData,
  }) : super();

  factory SmartphoneApplicationData.fromJson(Map<String, dynamic> json) =>
      _$SmartphoneApplicationDataFromJson(json);
  Map<String, dynamic> toJson() => _$SmartphoneApplicationDataToJson(this);
}

/// A description of how a study is to be executed on a smartphone.
///
/// A [SmartphoneStudyProtocol] defining the primary device ([PrimaryDeviceConfiguration])
/// responsible for aggregating data (typically this phone), the optional
/// devices ([DeviceConfiguration]) connected to the primary device,
/// and the [Trigger]'s which lead to data collection on said devices.
@JsonSerializable(fieldRename: FieldRename.none, includeIfNull: false)
class SmartphoneStudyProtocol extends StudyProtocol
    with SmartphoneProtocolExtension {
  /// Create a new [SmartphoneStudyProtocol].
  SmartphoneStudyProtocol({
    required super.ownerId,
    required super.name,
    StudyDescription? studyDescription,
    DataEndPoint? dataEndPoint,
  }) : super(
          description: studyDescription?.description ?? '',
        ) {
    // add the smartphone specific protocol data as application-specific data
    _data = SmartphoneApplicationData(
      studyDescription: studyDescription,
      dataEndPoint: dataEndPoint,
    );
  }

  @override
  bool addPrimaryDevice(PrimaryDeviceConfiguration primaryDevice) {
    super.addPrimaryDevice(primaryDevice);

    // add the trigger, task, error, and heartbeat measures to the protocol since
    // CAMS always collects and upload this data from the primary device (the phone)
    addTaskControl(
      NoOpTrigger(),
      BackgroundTask(measures: [
        Measure(type: Heartbeat.dataType),
        Measure(type: Error.dataType),
        Measure(type: CarpDataTypes.TRIGGERED_TASK_TYPE_NAME),
        Measure(type: CarpDataTypes.COMPLETED_TASK_TYPE_NAME)
      ]),
      primaryDevice,
      Control.Start,
    );

    return true;
  }

  @override
  bool addConnectedDevice(
    DeviceConfiguration device,
    PrimaryDeviceConfiguration primaryDevice,
  ) {
    super.addConnectedDevice(device, primaryDevice);

    // add the trigger, task, and heartbeat measures to the protocol since CAMS
    // always collects and upload this data from any device
    addTaskControl(
      NoOpTrigger(),
      BackgroundTask(measures: [
        Measure(type: Heartbeat.dataType),
        Measure(type: CarpDataTypes.TRIGGERED_TASK_TYPE_NAME),
        Measure(type: CarpDataTypes.COMPLETED_TASK_TYPE_NAME)
      ]),
      device,
      Control.Start,
    );

    return true;
  }

  factory SmartphoneStudyProtocol.fromJson(Map<String, dynamic> json) =>
      _$SmartphoneStudyProtocolFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SmartphoneStudyProtocolToJson(this);
}
