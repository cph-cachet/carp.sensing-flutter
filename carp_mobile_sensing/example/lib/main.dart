/*
 * Copyright 2018-2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import 'package:iso_duration_parser/iso_duration_parser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CarpMobileSensing.ensureInitialized();
  runApp(const CARPMobileSensingApp());
}

class CARPMobileSensingApp extends StatelessWidget {
  const CARPMobileSensingApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'CARP Mobile Sensing Demo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const ConsolePage(title: 'CARP Mobile Sensing Demo'),
      );
}

class ConsolePage extends StatefulWidget {
  final String title;
  const ConsolePage({super.key, required this.title});
  @override
  Console createState() => Console();
}

/// A simple UI with a console that shows the sensed data in a json format.
class Console extends State<ConsolePage> {
  String _log = '';
  Sensing _sensing = Sensing();

  @override
  void initState() {
    super.initState();
    _sensing = Sensing();
    Settings().debugLevel = DebugLevel.debug;
    Settings().init().then((_) {
      _sensing.init().then((_) {
        log('Client state : ${SmartPhoneClientManager().state}');
      });
    });
  }

  @override
  void dispose() {
    _sensing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SingleChildScrollView(
          child: StreamBuilder(
            stream: SmartPhoneClientManager().measurements,
            builder: (context, AsyncSnapshot<Measurement> snapshot) => Text(
                (snapshot.hasData)
                    ? _log += toJsonString(snapshot.data)
                    : _log),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: restart,
          tooltip: 'Start/Stop study',
          child: _sensing.isRunning
              ? const Icon(Icons.stop)
              : const Icon(Icons.play_arrow),
        ),
      );

  /// Add [msg] to the console log.
  void log(String msg) => setState(() => _log += '$msg\n');

  /// Clear the console log.
  void clearLog() => setState(() => _log += '');

  /// Restart (start/stop) sampling.
  void restart() => setState(() {
        if (_sensing.isRunning) {
          _sensing.stop();
          log('\nSensing stopped ...');
        } else {
          _sensing.start();
          log('\nSensing started ...');
        }
      });
}

/// This class handles sensing logic.
///
/// This example is useful for creating a Business Logical Object (BLOC) in a
/// Flutter app.
///
/// For a much more elaborate example of a app using CAMS, see the CARP Mobile
/// Sensing App at https://github.com/cph-cachet/carp.sensing-flutter/tree/master/apps/carp_mobile_sensing_app
class Sensing {
  /// Initialize sensing.
  Future<void> init() async {
    // Get the protocol. See below for how to configure a study protocol.
    final protocol =
        await LocalStudyProtocolManager().getStudyProtocol('ignored');

    // Create and configure a client manager for this phone and add the protocol.
    SmartPhoneClientManager()
        .configure()
        .then((_) => SmartPhoneClientManager().addStudyProtocol(protocol));

    // Listening on the data stream and print them as json.
    SmartPhoneClientManager()
        .measurements
        .listen((data) => print(toJsonString(data)));
  }

  /// Is sensing running, i.e. has the study executor been started?
  bool get isRunning =>
      SmartPhoneClientManager().state == ClientManagerState.started;

  /// Start sensing
  void start() => SmartPhoneClientManager().start();

  /// Stop sensing
  void stop() => SmartPhoneClientManager().stop();

  /// Dispose sensing
  void dispose() => SmartPhoneClientManager().dispose();
}

/// This is a simple local [StudyProtocolManager].
///
/// This class shows how to configure a [StudyProtocol] with devices,
/// triggers, tasks, measures, and task controls.
class LocalStudyProtocolManager implements StudyProtocolManager {
  @override
  Future<void> initialize() async {}

  /// Create a new CAMS study protocol.
  @override
  Future<SmartphoneStudyProtocol> getStudyProtocol(String id) async {
    // Create a protocol. Note that the [id] is not used for anything.
    SmartphoneStudyProtocol protocol = SmartphoneStudyProtocol(
        ownerId: 'AB',
        name: 'Track patient movement',
        dataEndPoint: SQLiteDataEndPoint());

    // Define which devices are used for data collection.
    //
    // In this case, its only this phone.
    // See the CARP Mobile Sensing app for a full-blown example of how to
    // use connected devices (e.g., a Polar heart rate monitor) and online
    // services (e.g., a weather service).
    var phone = Smartphone();
    protocol.addPrimaryDevice(phone);

    // Collect timezone info every time the app restarts.
    protocol.addTaskControl(
        ImmediateTrigger(),
        BackgroundTask(measures: [
          Measure(type: DeviceSamplingPackage.TIMEZONE),
        ]),
        phone);

    // Collect device info only once, when this study is deployed.
    protocol.addTaskControl(
      OneTimeTrigger(),
      BackgroundTask(
          measures: [Measure(type: DeviceSamplingPackage.DEVICE_INFORMATION)]),
      phone,
    );

    // Add background measures from the [DeviceSamplingPackage] and
    // [SensorSamplingPackage] sampling packages.

    // Note that some of these measures only works on Android:
    //  * screen events
    //  * ambient light
    //  * free memory (there seems to be a bug in the underlying sysinfo plugin)
    protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(measures: [
        Measure(type: DeviceSamplingPackage.FREE_MEMORY),
        Measure(type: DeviceSamplingPackage.BATTERY_STATE),
        Measure(type: DeviceSamplingPackage.SCREEN_EVENT),
        Measure(type: CarpDataTypes.STEP_COUNT_TYPE_NAME),
        Measure(type: SensorSamplingPackage.AMBIENT_LIGHT)
      ]),
      phone,
    );

    // Collect IMU data every 10 secs for 1 sec.
    // Also shows how the sampling interval can be specified ("overridden").
    // Default sampling interval is 200 ms. Note that it seems like setting the
    // sampling interval does NOT work on Android (see also the docs on the
    // sensor_plus package and on the Android sensor documentation:
    //   https://developer.android.com/reference/android/hardware/SensorManager#registerListener(android.hardware.SensorEventListener,%20android.hardware.Sensor,%20int)
    protocol.addTaskControl(
      PeriodicTrigger(period: const Duration(seconds: 10)),
      BackgroundTask(
        measures: [
          Measure(type: SensorSamplingPackage.ACCELERATION)
            ..overrideSamplingConfiguration = IntervalSamplingConfiguration(
                interval: const Duration(milliseconds: 500)),
          Measure(type: SensorSamplingPackage.ROTATION),
        ],
        duration: const IsoDuration(seconds: 1),
      ),
      phone,
    );

    // Extract acceleration features every minute over 10 seconds
    protocol.addTaskControl(
      ImmediateTrigger(),
      BackgroundTask(
        measures: [
          Measure(type: SensorSamplingPackage.ACCELERATION_FEATURES)
            ..overrideSamplingConfiguration = PeriodicSamplingConfiguration(
              interval: const Duration(minutes: 1),
              duration: const Duration(seconds: 10),
            ),
        ],
      ),
      phone,
    );

    // // Example of how to start and stop sampling using the Control.Start and
    // // Control.Stop method
    // var task_1 = BackgroundTask(
    //   measures: [
    //     Measure(type: CarpDataTypes.ACCELERATION_TYPE_NAME),
    //     Measure(type: CarpDataTypes.ROTATION_TYPE_NAME),
    //   ],
    // );

    // var task_2 = BackgroundTask(
    //   measures: [
    //     Measure(type: DeviceSamplingPackage.BATTERY_STATE),
    //   ],
    // );

    // // Collect IMU data
    // protocol.addTaskControls(
    //   ImmediateTrigger(),
    //   [task_1, task_2],
    //   phone,
    //   Control.Start,
    // );

    // // After a while, stop it again
    // protocol.addTaskControl(
    //   DelayedTrigger(delay: Duration(seconds: 10)),
    //   task_1,
    //   phone,
    //   Control.Stop,
    // );

    // // add a random trigger to collect device info at random times
    // protocol.addTaskControl(
    //   RandomRecurrentTrigger(
    //     startTime: TimeOfDay(hour: 07, minute: 45),
    //     endTime: TimeOfDay(hour: 22, minute: 30),
    //     minNumberOfTriggers: 2,
    //     maxNumberOfTriggers: 8,
    //   ),
    //   BackgroundTask()
    //     ..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE_INFORMATION)),
    //   phone,
    //   Control.Start,
    // );

    // // add a ConditionalPeriodicTrigger to check periodically
    // protocol.addTaskControl(
    //     ConditionalPeriodicTrigger(
    //         period: Duration(seconds: 20),
    //         triggerCondition: () => ('jakob'.length == 5)),
    //     BackgroundTask()
    //       ..addMeasure(Measure(type: DeviceSamplingPackage.DEVICE_INFORMATION)),
    //     phone,
    //     Control.Start);

    // // Collect device info after 30 secs
    // protocol.addTaskControl(
    //   ElapsedTimeTrigger(elapsedTime: IsoDuration(seconds: 30)),
    //   BackgroundTask(
    //     measures: [
    //       Measure(type: DeviceSamplingPackage.DEVICE_INFORMATION),
    //     ],
    //   ),
    //   phone,
    // );

    // Add two app tasks with notifications.
    //
    // These App Tasks are added for demo purpose and you should see notifications
    // on the phone. However, nothing will happen when you click on it.
    // See the PulmonaryMonitor demo app for a full-scale example of how to use
    // the App Task model.

    // Add a task 1 minute after deployment and make a notification.
    // protocol.addTaskControl(
    //   ElapsedTimeTrigger(elapsedTime: const IsoDuration(seconds: 30)),
    //   AppTask(
    //     type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
    //     title: "Elapsed Time - App Task",
    //     measures: [Measure(type: DeviceSamplingPackage.DEVICE_INFORMATION)],
    //     notification: true,
    //   ),
    //   phone,
    // );

    // // Add a cron job every day at 11:45
    // protocol.addTaskControl(
    //     CronScheduledTrigger.parse(cronExpression: '45 11 * * *'),
    //     AppTask(
    //       type: BackgroundSensingUserTask.ONE_TIME_SENSING_TYPE,
    //       title: "Cron - every day at 11:45",
    //       measures: [Measure(type: DeviceSamplingPackage.DEVICE_INFORMATION)],
    //       notification: true,
    //     ),
    //     phone);

    return protocol;
  }

  @override
  Future<bool> saveStudyProtocol(String studyId, StudyProtocol protocol) async {
    throw UnimplementedError();
  }
}
