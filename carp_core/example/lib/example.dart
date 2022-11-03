import 'package:carp_core/carp_protocols/carp_core_protocols.dart';
import 'package:carp_core/carp_deployment/carp_core_deployment.dart';
import 'package:carp_core/carp_client/carp_core_client.dart';
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
    MasterDeviceDeployment? deploymentInformation = await deploymentService
        ?.getDeviceDeploymentFor(studyDeploymentId, patientPhone.roleName);
    DateTime deploymentDate =
        deploymentInformation!.lastUpdateDate; // To verify correct deployment.
    await deploymentService?.deploymentSuccessfulFor(
        studyDeploymentId, patientPhone.roleName, deploymentDate);
  }

  // Now that all devices have been registered and deployed, the deployment is ready.
  status = await deploymentService?.getStudyDeploymentStatus(studyDeploymentId);
  var isReady = status?.status == StudyDeploymentStatusTypes.DeploymentReady;
  assert(isReady, true);
}

/// Example of how to use the **client** sub-system domain models
void carpCoreClientExample() async {
  ParticipationService? participationService;
  DeploymentService? deploymentService;
  DeviceDataCollectorFactory? deviceRegistry;

  // Retrieve invitation to participate in the study using a specific device.
  ActiveParticipationInvitation? invitation = (await participationService
          ?.getActiveParticipationInvitations('accountId'))
      ?.first;
  String? studyDeploymentId = invitation?.studyDeploymentId;
  String? deviceToUse = invitation?.devices?.first.deviceRoleName;

  // Create a study runtime for the study.
  var client = ClientManager();
  // Configure the client by specifying the deployment servie, the device controller,
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
