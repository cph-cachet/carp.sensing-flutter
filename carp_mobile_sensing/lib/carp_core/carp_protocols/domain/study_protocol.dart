/*
 * Copyright 2021 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of carp_core_domain;

/// A description of how a study is to be executed.
///
/// This is part of the [carp.protocols](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-protocols.md) domain model.
///
/// A [StudyProtocol] defining the master device ([MasterDeviceDescriptor])
/// responsible for aggregating data (typically this phone), the optional
/// devices ([DeviceDescriptor]) connected to the master device,
/// and the [Trigger]'s which lead to data collection on said devices.
///
/// A study may be fetched via a [DeploymentService] that knows how to fetch a
/// study protocol for this device.
class StudyProtocol {
  final List<MasterDeviceDescriptor> _masterDevices = [];
  List<DeviceDescriptor> _connectedDevices = [];
  final List<Trigger> _triggers = [];
  List<TaskDescriptor> _tasks;
  final Map<Trigger, Set<TriggeredTask>> _triggeredTasks = {};

  /// The owner of this study.
  String ownerId;

  /// A short printer-friendly name for this study.
  String name;

  /// A longer description of this study.
  String description;

  /// The master devices involved in this protocol.
  List<MasterDeviceDescriptor> get masterDevices => _masterDevices;

  /// The devices this device needs to connect to.
  List<DeviceDescriptor> get connectedDevices => _connectedDevices;

  /// The set of [Trigger]s which can trigger [TaskDescriptor]s in this study protocol.
  List<Trigger> get triggers => _triggers;

  /// The set of tasks which can be triggered as part of this protocol.
  List<TaskDescriptor> get tasks => _tasks;

  /// Add a [masterDevice] which is responsible for aggregating and synchronizing
  /// incoming data. Its role name should be unique in the protocol.
  void addMasterDevice(MasterDeviceDescriptor masterDevice) =>
      _masterDevices.add(masterDevice);

  /// Add a [device] which is connected to this [masterDevice].
  /// Its role name should be unique in the protocol.
  void addConnectedDevice(DeviceDescriptor device) =>
      _connectedDevices.add(device);

  /// Add the [trigger] to this protocol.
  void addTrigger(Trigger trigger) => _triggers.add(trigger);

  /// Add a [task] to be sent to a [targetDevice] once a [trigger] within this
  /// protocol is initiated.
  /// In case the [trigger] or [task] is not yet included in this study protocol,
  /// it will be added.
  /// The [targetDevice] needs to be added prior to this call since it needs to
  /// be set up as either a master device or connected device.
  void addTriggeredTask(
    Trigger trigger,
    TaskDescriptor task,
    DeviceDescriptor targetDevice,
  ) {
    // Add trigger and task to ensure they are included in the protocol.
    if (!triggers.contains(trigger)) addTrigger(trigger);
    addTask(task);

    // Add triggered task.
    if (_triggeredTasks[trigger] = null) _triggeredTasks[trigger] = {};
    _triggeredTasks[trigger].add(TriggeredTask(task, targetDevice));
  }

  /// Gets all the tasks (and the devices they are triggered to) for the
  /// specified [trigger].
  Set<TriggeredTask> getTriggeredTasks(Trigger trigger) {
    assert(_triggers.contains(trigger),
        'The passed trigger is not part of this study protocol.');
    return _triggeredTasks[trigger];
  }

  /// Gets all the tasks triggered for the specified [device].
  Set<TaskDescriptor> getTasksForDevice(DeviceDescriptor device) {
    assert(connectedDevices.contains(device),
        'The passed device is not part of this study protocol.');

    final Set<TaskDescriptor> deviceTasks = {};
    _triggeredTasks.values.forEach((tasks) {
      tasks.forEach((triggered) {
        if (triggered.targetDevice == device) deviceTasks.add(triggered.task);
      });
    });

    return deviceTasks;
  }

  /// Add the [task] to this protocol.
  void addTask(TaskDescriptor task) => tasks.add(task);

  /// Remove the [task] currently present in this configuration
  /// including removing it from any [Trigger]'s which initiate it.
  void removeTask(TaskDescriptor task) {
    // Remove task from triggered tasks
    _triggeredTasks.values.forEach((tasks) {
      tasks.forEach((triggered) {
        if (triggered.task == task) tasks.remove(task);
      });
    });

    // Remove task itself.
    _tasks.remove(task);
  }

  String toString() => '$runtimeType - $name';
}

// /// A person that created a [StudyProtocol].
// /// Typically the Principal Investigator (PI) who is reposnibile for the study.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class ProtocolOwner extends Serializable {
//   String id;
//   String name;
//   String title;
//   String email;
//   String address;
//   String affiliation;

//   ProtocolOwner({
//     this.id,
//     this.name,
//     this.title,
//     this.email,
//     this.affiliation,
//     this.address,
//   });

//   Function get fromJsonFunction => _$ProtocolOwnerFromJson;
//   factory ProtocolOwner.fromJson(Map<String, dynamic> json) => FromJsonFactory()
//       .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
//   Map<String, dynamic> toJson() => _$ProtocolOwnerToJson(this);

//   String toString() => '$runtimeType - $name, $title <$email>';
// }

// /// Specify an endpoint where a [DataManager] can upload data.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class DataEndPoint extends Serializable {
//   /// The type of endpoint as enumerated in [DataEndPointTypes].
//   String type;

//   /// The public key in a PKI setup for encryption of data
//   String publicKey;

//   /// Creates a [DataEndPoint]. [type] is defined in [DataEndPointTypes].
//   DataEndPoint({this.type, this.publicKey}) : super();

//   Function get fromJsonFunction => _$DataEndPointFromJson;
//   factory DataEndPoint.fromJson(Map<String, dynamic> json) => FromJsonFactory()
//       .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
//   Map<String, dynamic> toJson() => _$DataEndPointToJson(this);

//   String toString() => type;
// }

// /// A description of how a study is to be executed.
// ///
// /// This is part of the [carp.protocols](https://github.com/cph-cachet/carp.core-kotlin/blob/develop/docs/carp-protocols.md) domain model.
// ///
// /// A [StudyProtocol] defining the master device ([MasterDeviceDescriptor])
// /// responsible for aggregating data (typically this phone), the optional
// /// devices ([DeviceDescriptor]) connected to the master device,
// /// and the [Trigger]'s which lead to data collection on said devices.
// ///
// /// A study may be fetched via a [DeploymentService] that knows how to fetch a
// /// study protocol for this device.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class StudyProtocol extends Serializable {
//   /// The id of this [StudyProtocol].
//   // String id;

//   /// A short printer-friendly name for this study.
//   String name;

//   /// A longer printer-friendly title for this study.
//   String title;

//   /// A longer description of this study.
//   String description;

//   /// The purpose of the study. To be used to inform the user about
//   /// this study and its purpose.
//   String purpose;

//   /// The owner of this study.
//   ProtocolOwner owner;

//   /// The ID of the user executing this study.
//   // String userId;

//   /// The sampling strategy according to [SamplingSchemaType].
//   String samplingStrategy = SamplingSchemaType.NORMAL;

//   /// Specify where and how to upload this study data.
//   DataEndPoint dataEndPoint;

//   /// The preferred format of the data to be uploaded according to
//   /// [DataFormatType]. Default using the [NameSpace.CARP].
//   String dataFormat;

//   /// The [masterDevice] which is responsible for aggregating and synchronizing
//   /// incoming data. Typically this phone.
//   MasterDeviceDescriptor masterDevice;

//   List<DeviceDescriptor> _connectedDevices = [];

//   /// The devices this device needs to connect to.
//   List<DeviceDescriptor> get connectedDevices => _connectedDevices;

//   final List<Trigger> _triggers = [];

//   /// The set of [Trigger]s which can trigger [TaskDescriptor]s in this study protocol.
//   List<Trigger> get triggers => _triggers;

//   List<TaskDescriptor> _tasks;

//   /// The set of tasks which can be triggered as part of this protocol.
//   List<TaskDescriptor> get tasks => _tasks;

//   final Map<Trigger, Set<TriggeredTask>> _triggeredTasks = {};

//   /// Create a new [StudyProtocol] object with a set of configurations.
//   ///
//   /// If no [dataFormat] the CARP namespace is used.
//   StudyProtocol({
//     // this.userId,
//     this.owner,
//     this.name,
//     this.title,
//     this.description,
//     this.purpose,
//     this.samplingStrategy,
//     this.dataEndPoint,
//     this.dataFormat,
//     // this.publicKey,
//   }) : super() {
//     // id ??= Uuid().v1();
//     samplingStrategy ??= SamplingSchemaType.NORMAL;
//     dataFormat ??= NameSpace.CARP;
//   }

//   /// Add a [device] which is connected to this [masterDevice].
//   /// Its role name should be unique in the protocol.
//   void addConnectedDevice(DeviceDescriptor device) =>
//       _connectedDevices.add(device);

//   /// Add the [trigger] to this protocol.
//   void addTrigger(Trigger trigger) => _triggers.add(trigger);

//   /// Add a [TaskDescriptor] with a [CAMSTrigger] to this [StudyProtocol]
//   void addTriggeredTask(
//     Trigger trigger,
//     TaskDescriptor task, {
//     DeviceDescriptor targetDevice,
//   }) {
//     // Add trigger and task to ensure they are included in the protocol.
//     if (!triggers.contains(trigger)) addTrigger(trigger);
//     addTask(task);

//     // if no target device is specified, asume this phone
//     targetDevice ??= masterDevice;

//     // Add triggered task.
//     if (_triggeredTasks[trigger] = null) _triggeredTasks[trigger] = {};
//     _triggeredTasks[trigger].add(TriggeredTask(task, targetDevice));
//   }

//   /// Gets all the tasks (and the devices they are triggered to) for the
//   /// specified [trigger].
//   Set<TriggeredTask> getTriggeredTasks(Trigger trigger) {
//     assert(_triggers.contains(trigger),
//         'The passed trigger is not part of this study protocol.');
//     return _triggeredTasks[trigger];
//   }

//   /// Gets all the tasks triggered for the specified [device].
//   Set<TaskDescriptor> getTasksForDevice(DeviceDescriptor device) {
//     assert(connectedDevices.contains(device),
//         'The passed device is not part of this study protocol.');

//     final Set<TaskDescriptor> deviceTasks = {};
//     _triggeredTasks.values.forEach((tasks) {
//       tasks.forEach((triggered) {
//         if (triggered.targetDevice == device) deviceTasks.add(triggered.task);
//       });
//     });

//     return deviceTasks;
//   }

//   /// Add the [task] to this protocol.
//   void addTask(TaskDescriptor task) => tasks.add(task);

//   /// Remove the [task] currently present in this configuration
//   /// including removing it from any [Trigger]'s which initiate it.
//   void removeTask(TaskDescriptor task) {
//     // Remove task from triggered tasks
//     _triggeredTasks.values.forEach((tasks) {
//       tasks.forEach((triggered) {
//         if (triggered.task == task) tasks.remove(task);
//       });
//     });

//     // Remove task itself.
//     _tasks.remove(task);
//   }

//   /// Get the list of all [Mesure]s in this study protocol.
//   List<Measure> get measures {
//     List<Measure> _measures = [];
//     tasks.forEach((task) => _measures.addAll(task.measures));

//     return _measures;
//   }

//   /// Adapt the sampling [Measure]s of this [StudyProtocol] to the specified
//   /// [SamplingSchema].
//   void adapt(SamplingSchema schema, {bool restore = true}) {
//     assert(schema != null);
//     samplingStrategy = schema.type;
//     schema.adapt(this, restore: restore);
//   }

//   Function get fromJsonFunction => _$StudyProtocolFromJson;
//   factory StudyProtocol.fromJson(Map<String, dynamic> json) => FromJsonFactory()
//       .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
//   Map<String, dynamic> toJson() => _$StudyProtocolToJson(this);

//   String toString() => '$runtimeType - $name, $title';
// }

// /// A person that created a [StudyProtocol].
// /// Typically the Principal Investigator (PI) who is reposnibile for the study.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class ProtocolOwner extends Serializable {
//   String id;
//   String name;
//   String title;
//   String email;
//   String address;
//   String affiliation;

//   ProtocolOwner({
//     this.id,
//     this.name,
//     this.title,
//     this.email,
//     this.affiliation,
//     this.address,
//   });

//   Function get fromJsonFunction => _$ProtocolOwnerFromJson;
//   factory ProtocolOwner.fromJson(Map<String, dynamic> json) => FromJsonFactory()
//       .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
//   Map<String, dynamic> toJson() => _$ProtocolOwnerToJson(this);

//   String toString() => '$runtimeType - $name, $title <$email>';
// }

// /// Specify an endpoint where a [DataManager] can upload data.
// @JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
// class DataEndPoint extends Serializable {
//   /// The type of endpoint as enumerated in [DataEndPointTypes].
//   String type;

//   /// The public key in a PKI setup for encryption of data
//   String publicKey;

//   /// Creates a [DataEndPoint]. [type] is defined in [DataEndPointTypes].
//   DataEndPoint({this.type, this.publicKey}) : super();

//   Function get fromJsonFunction => _$DataEndPointFromJson;
//   factory DataEndPoint.fromJson(Map<String, dynamic> json) => FromJsonFactory()
//       .fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
//   Map<String, dynamic> toJson() => _$DataEndPointToJson(this);

//   String toString() => type;
// }

// /// A enumeration of known (but not necessarily implemented) endpoint API types.
// ///
// /// Note that the type is basically a [String], which allow for extension of
// /// new application-specific data endpoints.
// class DataEndPointTypes {
//   static const String UNKNOWN = 'UNKNOWN';
//   static const String PRINT = 'PRINT';
//   static const String FILE = 'FILE';
//   static const String SQLITE = 'SQLITE';
//   static const String FIREBASE_STORAGE = 'FIREBASE_STORAGE';
//   static const String FIREBASE_DATABSE = 'FIREBASE_DATABSE';
//   static const String CARP = 'CARP';
//   static const String OMH = 'OMH';
//   static const String AWS = 'AWS';
// }
