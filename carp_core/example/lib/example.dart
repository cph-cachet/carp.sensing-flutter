import 'package:carp_core/carp_core.dart';
import 'package:carp_serializable/carp_serializable.dart';

// These examples tries to mimic the example from the carp_core Kotlin
// example at https://github.com/cph-cachet/carp.core-kotlin#example
//
// These are a very simple examples showing the basic of carp_core.
//
// Examples of how carp_core is used in CARP Mobile Sensing (CAMS) can be
// found at:
//
//   * https://github.com/cph-cachet/carp.sensing-flutter
//   * https://github.com/cph-cachet/carp.sensing-flutter/wiki

/// Example of how to use the **protocol** sub-system domain models
void carpCoreProtocolExample() async {
  // Create a new study protocol.
  StudyProtocol protocol = StudyProtocol(
    ownerId: 'owner@dtu.dk',
    name: 'Track patient movement',
  );

  // Define which devices are used for data collection.
  Smartphone phone = Smartphone(roleName: 'phone');
  protocol.addMasterDevice(phone);

  // Define what needs to be measured, on which device, when.
  List<Measure> measures = [
    Measure(type: 'dk.cachet.geolocation'),
    Measure(type: 'dk.cachet.stepcount'),
  ];

  TaskConfiguration startMeasures = BackgroundTask(
    name: "Start measures",
    measures: measures,
  );
  protocol.addTaskControl(
    TriggerConfiguration(sourceDeviceRoleName: phone.roleName),
    startMeasures,
    phone,
    Control.Start,
  );

  // JSON output of the study protocol, compatible with the rest of the CARP infrastructure.
  String json = toJsonString(protocol.toJson());
  print(json);
}

/// Example of how to use the **deployment** sub-system domain models
void carpCoreDeploymentExample() async {
  DeploymentService? deploymentService;
  StudyProtocol trackPatientStudy = StudyProtocol(
    ownerId: 'abc@dtu.dk',
    name: 'Tracking',
  );
  Smartphone patientPhone =
      trackPatientStudy.primaryDevices.first as Smartphone;

  // This is called by `StudyService` when deploying a participant group.
  StudyDeploymentStatus? status =
      await deploymentService?.createStudyDeployment(trackPatientStudy);
  String studyDeploymentId = status!.studyDeploymentId;

  // What comes after is similar to what is called by the client in `carp.client`:
  // - Register the device to be deployed.
  var registration = DeviceRegistration();
  status = await deploymentService?.registerDevice(
      studyDeploymentId, patientPhone.roleName, registration);

  // - Retrieve information on what to run and indicate the device is ready to
  //   collect the requested data.
  DeviceDeploymentStatus? patientPhoneStatus = status?.masterDeviceStatus;
  if (patientPhoneStatus!.remainingDevicesToRegisterBeforeDeployment!
      .isEmpty) // True since there are no dependent devices.
  {
    PrimaryDeviceDeployment? deploymentInformation = await deploymentService
        ?.getDeviceDeploymentFor(studyDeploymentId, patientPhone.roleName);
    DateTime deploymentDate =
        deploymentInformation!.lastUpdateDate ?? DateTime.now();
    await deploymentService?.deploymentSuccessfulFor(
        studyDeploymentId, patientPhone.roleName, deploymentDate);
  }

  // Now that all devices have been registered and deployed, the deployment is ready.
  status = await deploymentService?.getStudyDeploymentStatus(studyDeploymentId);
  var isReady = status?.status == StudyDeploymentStatusTypes.DeploymentReady;
  assert(isReady, true);
}

/// Example of how to use the **data** sub-system domain models.
///
/// Calls to this subsystem are abstracted away by the 'deployments' subsystem
/// and are planned to be abstracted away by the 'clients' subsystem.
/// Example code which is called once a deployment is running and data is subsequently
/// uploaded by the client.
void carpCoreDataExample() async {
  DataStreamService? dataStreamService;
  String studyDeploymentId = '...'; // Provided by the 'deployments' subsystem.

// This is called by the `DeploymentsService` once the deployment starts running.
  String device = "Patient's phone";
// val geolocation = DataStreamsConfiguration.ExpectedDataStream( device, CarpDataTypes.GEOLOCATION.type )
// val stepCount = DataStreamsConfiguration.ExpectedDataStream( device, CarpDataTypes.STEP_COUNT.type )
// val configuration = DataStreamsConfiguration( studyDeploymentId, setOf( geolocation, stepCount ) )
// dataStreamService.openDataStreams( configuration )

// // Upload data from the client.
// val geolocationData = MutableDataStreamSequence<Geolocation>(
//     dataStream = dataStreamId<Geolocation>( studyDeploymentId, device ),
//     firstSequenceId = 0,
//     triggerIds = listOf( 0 ) // Provided by device deployment; maps to the `atStartOfStudy()` trigger.
// )
// DataStreamBatch uploadData  = DataStreamBatch(dataStream: , firstSequenceId: , measurements: , triggerIds: );

// ).apply {
//     appendSequence( geolocationData )

// dataStreamService?.appendToDataStreams( studyDeploymentId, [uploadData] );
}

/// Example of how to use the **client** sub-system domain models.
///
/// Example initialization of a smartphone client for the participant that got
/// invited to the study in the 'studies' code sample above:
void carpCoreClientExample() async {
  ParticipationService? participationService;
  DeploymentService? deploymentService;
  DeviceDataCollectorFactory? deviceRegistry;

  // Retrieve invitation to participate in the study using a specific device.
  ActiveParticipationInvitation? invitation = (await participationService
          ?.getActiveParticipationInvitations('accountId'))
      ?.first;
  String? studyDeploymentId = invitation?.studyDeploymentId;
  String? deviceToUse = invitation?.assignedDevices?.first.device.roleName;

  // Create a study runtime for the study.
  var client = ClientManager();
  // Configure the client by specifying the deployment service, the device controller,
  // and a unique device id.
  client.configure(
    deploymentService: deploymentService!,
    deviceController: deviceRegistry!,
    deviceId: "xxxxxxxxx",
  );

  Study study = Study(studyDeploymentId!, deviceToUse!);
  StudyStatus status = await client.addStudy(study);

  // Register connected devices in case needed.
  if (status == StudyStatus.RegisteringDevices) {
    var connectedDevice = study.deviceRoleName;
    var connectedRegistration = client.registration;
    deploymentService.registerDevice(
      studyDeploymentId,
      connectedDevice,
      connectedRegistration!,
    );

    // Try deployment now that devices have been registered.
    StudyStatus status = await client.tryDeployment(study);
    var isDeployed = status == StudyStatus.Deployed;
    assert(isDeployed, true);
  }
}
