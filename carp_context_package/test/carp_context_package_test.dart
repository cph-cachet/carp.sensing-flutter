import 'package:test/test.dart';
import 'dart:convert';
import 'dart:io';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:carp_context_package/context.dart';

String _encode(Object object) => const JsonEncoder.withIndent(' ').convert(object);

void main() {
  Study study;

  setUp(() {
    SamplingPackageRegistry.register(ContextSamplingPackage());

    study = Study("1234", "bardram", name: "bardram study")
      ..dataEndPoint = DataEndPoint(DataEndPointTypes.PRINT)
      ..addTriggerTask(
          ImmediateTrigger(),
          AutomaticTask(name: 'Task #1')
            ..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());
  });
  
  test('Weather', () {
    double lat = 55.0111;
    double lon = 15.0569;
    String key = '856822fd8e22db5e1ba48c0e7d69844a';
    WeatherMeasure wm = ContextSamplingPackage().common.measures[ContextSamplingPackage.WEATHER];

  });

  test('Study -> JSON', () async {
    print(_encode(study));

    expect(study.id, "1234");
  });

  test('JSON -> Study, assert study id', () async {
    final studyJson = _encode(study);

    Study study_2 = Study.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(study_2.id, study.id);

    print(_encode(study_2));
  });

  test('JSON -> Study, deep assert', () async {
    final studyJson = _encode(study);

    Study study_2 = Study.fromJson(json.decode(studyJson) as Map<String, dynamic>);
    expect(_encode(study_2), equals(studyJson));
  });

  test('Plain JSON string -> Study object', () async {
    print(Directory.current.toString());
    String plainStudyJson = File("test/study_1234.json").readAsStringSync();
    print(plainStudyJson);

    Study plainStudy = Study.fromJson(json.decode(plainStudyJson) as Map<String, dynamic>);
    expect(plainStudy.id, study.id);

    final studyJson = _encode(study);

    Study study_2 = Study.fromJson(json.decode(plainStudyJson) as Map<String, dynamic>);
    expect(_encode(study_2), equals(studyJson));
  });

  test('CARP Location -> OMH Geoposition', () {
    LocationDatum loc = LocationDatum()
      ..longitude = 12.23342
      ..latitude = 3.34224;
    DataPoint dp_1 = DataPoint.fromDatum(study.id, study.userId, loc);
    expect(dp_1.header.dataFormat.namepace, NameSpace.CARP);
    print(_encode(dp_1));

    OMHGeopositionDatum geo = TransformerSchemaRegistry.lookup(NameSpace.OMH).transform(loc);
    DataPoint dp_2 = DataPoint.fromDatum(study.id, study.userId, geo);
    expect(dp_2.header.dataFormat.namepace, NameSpace.OMH);
    expect(geo.geoposition.latitude.value, loc.latitude);
    print(_encode(dp_2));
  });

  test('CARP Activity -> OMH Physical Activity', () {
    ActivityDatum act = ActivityDatum()..type = "walking";
    DataPoint dp_1 = DataPoint.fromDatum(study.id, study.userId, act);
    expect(dp_1.header.dataFormat.namepace, NameSpace.CARP);
    print(_encode(dp_1));

    OMHPhysicalActivityDatum phy = TransformerSchemaRegistry.lookup(NameSpace.OMH).transform(act);
    DataPoint dp_2 = DataPoint.fromDatum(study.id, study.userId, phy);
    expect(dp_2.header.dataFormat.namepace, NameSpace.OMH);
    expect(phy.activity.activityName, act.type);
    print(_encode(dp_2));
  });

  test('Geofence', () {
    GeofenceDatum d;
    GeoPosition home = GeoPosition(55.7946, 12.4472); // Parsbergsvej
    GeoPosition dtu = GeoPosition(55.786025, 12.524159); // DTU
    GeoPosition compute = GeoPosition(55.783499, 12.518914); // DTU Compute
    GeoPosition lyngby = GeoPosition(55.7704, 12.5038); // Kgs. Lyngby

    GeofenceMeasure m = ContextSamplingPackage().common.measures[ContextSamplingPackage.GEOFENCE];
    Geofence f = Geofence.fromMeasure(m)..dwell = 2 * 1000; // dwell timeout 2 secs.
    print(f);

    d = f.moved(home);
    print('starting from home - $d');
    expect(d.type, 'ENTER');

    d = f.moved(dtu);
    print('moved to DTU - $d');
    expect(d.type, 'ENTER');
    print(_encode(d));

    d = f.moved(lyngby);
    print('moved to Lyngby - $d');
    expect(d.type, 'EXIT');

    d = f.moved(compute);
    print('moved to DTU Compute - $d');
    expect(d.type, 'ENTER');

    sleep(const Duration(seconds: 3));
    d = f.moved(dtu);
    expect(d.type, 'DWELL');
    print('moved to DTU - $d');
    d = f.moved(home);
    expect(d.type, 'EXIT');
    print('went home - $d');
  });


  test('Mobility', () {});
}
