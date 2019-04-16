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
      ..dataEndPoint = DataEndPoint(DataEndPointType.PRINT)
      ..addTask(Task('Task #1')..measures = SamplingSchema.common(namespace: NameSpace.CARP).measures.values.toList());
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

  test('', () {});
}
