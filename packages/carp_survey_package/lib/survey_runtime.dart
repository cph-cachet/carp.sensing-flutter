/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of survey;

/// A [SamplingPackage] that knows how to collect data from user surveys based on the [research_package] package.
class SurveySamplingPackage implements SamplingPackage {
  static const String SURVEY = "survey";

  List<String> get dataTypes => [
        SURVEY,
      ];

  List<Permission> get permissions =>
      []; // Research Package don't need any permission on the phone

  Probe create(String type) {
    switch (type) {
      case SURVEY:
        return SurveyProbe();
      default:
        return null;
    }
  }

  void onRegister() {
    FromJsonFactory().register(RPTaskMeasure(type: null));
    AppTaskController().registerUserTaskFactory(SurveyUserTaskFactory());
  }

  /// Adding WHO5 as the default survey.
  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Default survey measure - the WHO5 well-being index survey'
    ..powerAware = false
    ..measures.addEntries([
      MapEntry(
          SURVEY,
          RPTaskMeasure(
            type: MeasureType(NameSpace.CARP, SURVEY),
            name: 'WHO5',
            enabled: true,
            surveyTask: who5Task,
          )),
    ]);

  SamplingSchema get light => common;
  SamplingSchema get minimum => common;
  SamplingSchema get normal => common;
  SamplingSchema get debug => common;
}

/// The probe collecting a survey.
///
/// When triggered, @TODO explain...
///
/// Once the survey is submitted later, then a [RPTaskResultDatum] is added to
/// the [carp_mobile_sensing] event queue.
class SurveyProbe extends AbstractProbe {
  StreamController<Datum> controller = StreamController.broadcast();
  Stream<Datum> get events => controller.stream;
  RPTaskMeasure get surveyMeasure => (measure as RPTaskMeasure);

  /// The survey to be filled in
  RPTask surveyTask;

  /// The callback function providing a [SurveyPage] object to be displayed in the app.
  /// This function is called when the survey is triggered, i.e. in the [SurveyProbe.resume] method.
  ///
  /// This callback function needs to be provided by the app on runtime. I.e. this part of the measure
  /// cannot be specified in the JSON format of the measure as e.g. downloaded from a study manager.
  void Function(SurveyPage) onSurveyTriggered;

  /// The callback function to be called when the survey is submitted by the user (hits done).
  /// Carries the [RPTaskResult] result of the survey.
  void Function(RPTaskResult) onSurveySubmit;

  /// The callback function to be called when the survey is canceled by the user.
  /// The optional [RPTaskResult] is provided at it's current state. Can be null.
  void Function([RPTaskResult]) onSurveyCancel;

  SurveyProbe(
      {this.onSurveyTriggered, this.onSurveySubmit, this.onSurveyCancel})
      : super();

  void onInitialize(Measure measure) {
    assert(measure is RPTaskMeasure);
    //surveyMeasure = (measure as RPTaskMeasure);
    surveyTask = surveyMeasure.surveyTask;
  }

  Future onResume() async {
    onSurveyTriggered(SurveyPage(
      surveyTask,
      _onSurveySubmit,
      onSurveyCancel: onSurveyCancel,
    ));
  }

  Future onRestart() async {}
  Future onPause() async {}
  Future onStop() async {}

  void _onSurveySubmit(RPTaskResult result) {
    // when we have the survey result, add it to the event stream
    controller?.add(RPTaskResultDatum(result));
    onSurveySubmit(result);
  }
}
