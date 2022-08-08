/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of survey;

/// A [SamplingPackage] that knows how to collect data from user surveys based
/// on the [research_package](https://pub.dev/packages/research_package)
/// package.
///
/// In contrast to other sampling packages, this package does not support any
/// [dataTypes]. Collection of [RPTask] data from a user is supported by the
/// [SurveyUserTask] user task.
class SurveySamplingPackage extends SmartphoneSamplingPackage {
  static const String SURVEY = "${NameSpace.CARP}.survey";

  @override
  void onRegister() {
    FromJsonFactory()
        .register(RPAppTask(type: '', rpTask: RPTask(identifier: 'ignored')));
    AppTaskController().registerUserTaskFactory(SurveyUserTaskFactory());
  }

  // no data types supported in this package and hence no permissions, probes,
  // or sampling schema are needed.
  @override
  List<String> get dataTypes => [];

  @override
  List<Permission> get permissions => [];

  @override
  Probe? create(String type) => null;

  @override
  SamplingSchema get samplingSchema => SamplingSchema();
}
