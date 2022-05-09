import 'dart:convert';
import 'dart:io';
import 'package:test/test.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_context_package/context.dart';
// import 'package:activity_recognition_flutter/activity_recognition_flutter.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import 'package:openmhealth_schemas/openmhealth_schemas.dart' as omh;

String _encode(Object object) =>
    const JsonEncoder.withIndent(' ').convert(object);

void main() {
  late StudyProtocol protocol;
  Smartphone phone;

  setUp(() {
    // make sure that the json functions are loaded
    DomainJsonFactory();
    ContextSamplingPackage().onRegister();

    // register the context sampling package
    SamplingPackageRegistry().register(ContextSamplingPackage());

    // Create a new study protocol.
    protocol = StudyProtocol(
      ownerId: 'alex@uni.dk',
      name: 'Context package test',
      description: '',
    );

    // Define which devices are used for data collection.
    phone = Smartphone();
    protocol.addMasterDevice(phone);

    // adding all available measures to one one trigger and one task
    protocol.addTriggeredTask(
      ImmediateTrigger(),
      AutomaticTask()
        ..measures = SamplingPackageRegistry()
            .dataTypes
            .map((type) => Measure(type: type))
            .toList(),
      phone,
    );
  });

  test('CAMSStudyProtocol -> JSON', () async {
    print(protocol);
    print(toJsonString(protocol));
    expect(protocol.ownerId, 'alex@uni.dk');
  });

  test('StudyProtocol -> JSON -> StudyProtocol :: deep assert', () async {
    print('#1 : $protocol');
    final studyJson = toJsonString(protocol);

    StudyProtocol protocolFromJson =
        StudyProtocol.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(toJsonString(protocolFromJson), equals(studyJson));
    print('#2 : $protocolFromJson');
  });

  test('JSON File -> StudyProtocol', () async {
    // Read the study protocol from json file
    String plainJson = File('test/json/study_1.json').readAsStringSync();

    StudyProtocol protocolFromFile =
        StudyProtocol.fromJson(json.decode(plainJson) as Map<String, dynamic>);

    expect(protocolFromFile.ownerId, protocol.ownerId);
    expect(
      protocolFromFile.masterDevices.first.roleName,
      Smartphone.DEFAULT_ROLENAME,
    );
    expect(
      protocolFromFile.triggeredTasks.length,
      protocol.triggeredTasks.length,
    );
    print(toJsonString(protocolFromFile));
  });

  test('CARP Location', () {
    LocationDatum loc = LocationDatum()
      ..longitude = 12.23342
      ..latitude = 3.34224
      ..altitude = 124.2134235;
    DataPoint dp_1 = DataPoint.fromData(loc);
    expect(dp_1.carpHeader.dataFormat.namespace, NameSpace.CARP);
    print(_encode(dp_1));

    loc.altitude = 'encrypted value';
    print(_encode(dp_1));
  });

  test('CARP Location -> OMH Geoposition', () {
    LocationDatum loc = LocationDatum()
      ..longitude = 12.23342
      ..latitude = 3.34224;
    DataPoint dp_1 = DataPoint.fromData(loc);
    expect(dp_1.carpHeader.dataFormat.namespace, NameSpace.CARP);
    print(_encode(dp_1));

    OMHGeopositionDataPoint geo = TransformerSchemaRegistry()
        .lookup(NameSpace.OMH)!
        .transform(loc) as OMHGeopositionDataPoint;
    DataPoint dp_2 = DataPoint.fromData(geo);
    expect(dp_2.carpHeader.dataFormat.namespace, NameSpace.OMH);
    expect(geo.datapoint.body, isA<omh.Geoposition>());
    var geopos = geo.datapoint.body as omh.Geoposition;
    expect(geopos.latitude.value, loc.latitude);
    print(_encode(dp_2));
  });

  test('CARP Activity -> OMH Physical Activity', () {
    ActivityDatum act = ActivityDatum(ActivityType.WALKING, 100);
    DataPoint dp_1 = DataPoint.fromData(act);
    expect(dp_1.carpHeader.dataFormat.namespace, NameSpace.CARP);
    print(_encode(dp_1));

    OMHPhysicalActivityDataPoint phy = TransformerSchemaRegistry()
        .lookup(NameSpace.OMH)!
        .transform(act) as OMHPhysicalActivityDataPoint;
    DataPoint dp_2 = DataPoint.fromData(phy);
    expect(dp_2.carpHeader.dataFormat.namespace, NameSpace.OMH);
    var act_2 = phy.datapoint.body as omh.PhysicalActivity;
    expect(act_2.activityName, act.typeString);
    print(_encode(dp_2));
  });

  test('Geofence', () {
    GeofenceDatum? d;
    GeoPosition home = GeoPosition(55.7946, 12.4472); // Parsbergsvej
    GeoPosition dtu = GeoPosition(55.786025, 12.524159); // DTU
    GeoPosition compute = GeoPosition(55.783499, 12.518914); // DTU Compute
    GeoPosition lyngby = GeoPosition(55.7704, 12.5038); // Kgs. Lyngby

    GeofenceSamplingConfiguration config = GeofenceSamplingConfiguration(
      center: home,
      dwell: const Duration(minutes: 10),
      radius: 5,
    );

    Geofence f = Geofence.fromGeofenceSamplingConfiguration(config)
      ..dwell = const Duration(seconds: 2); // dwell timeout 2 secs.
    print(f);

    d = f.moved(home);
    print('starting from home - $d');
    expect(d!.type, GeofenceType.ENTER);

    d = f.moved(home);
    print('moved home - $d');
    expect(d, null);

    d = f.moved(dtu);
    print('moved to DTU - $d');
    expect(d!.type, GeofenceType.EXIT);

    d = f.moved(home);
    print('moved home - $d');
    expect(d!.type, GeofenceType.ENTER);

    d = f.moved(lyngby);
    print('moved to Lyngby - $d');
    expect(d!.type, GeofenceType.EXIT);

    d = f.moved(compute);
    print('moved to DTU Compute - $d');
    expect(d, null);

    d = f.moved(home);
    print('went home, sleeping - $d');
    sleep(const Duration(seconds: 3));
    d = f.moved(home);
    expect(d!.type, GeofenceType.DWELL);

    d = f.moved(compute);
    print('moved to DTU Compute - $d');
    expect(d!.type, GeofenceType.EXIT);
  });

  test('Mobility', () {});
}
