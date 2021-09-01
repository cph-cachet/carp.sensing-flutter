/*
 * Copyright 2020 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of survey;

/// A [SamplingPackage] that knows how to collect data from user surveys based
/// on the `research_package` package.
class SurveySamplingPackage extends SmartphoneSamplingPackage {
  static const String SURVEY = "${NameSpace.CARP}.survey";

  @override
  List<String> get dataTypes => [
        SURVEY,
      ];

  @override
  List<Permission> get permissions =>
      []; // Research Package don't need any permission on the phone

  @override
  Probe? create(String type) {
    switch (type) {
      case SURVEY:
        return SurveyProbe();
      default:
        return null;
    }
  }

  @override
  void onRegister() {
    FromJsonFactory().register(
        RPTaskMeasure(type: SURVEY, surveyTask: RPTask(identifier: 'ignored')));
    AppTaskController().registerUserTaskFactory(SurveyUserTaskFactory());
  }

  /// Adding WHO5 as the default survey.
  SamplingSchema get common => SamplingSchema(
      type: SamplingSchemaType.common,
      name: 'Default survey measure - the WHO5 well-being index survey',
      powerAware: false)
    ..measures.addEntries([
      MapEntry(
          SURVEY,
          RPTaskMeasure(
            type: SURVEY,
            name: 'WHO-5',
            description: "The WHO well-being survey",
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
  StreamController<DataPoint> controller = StreamController.broadcast();
  Stream<DataPoint> get data => controller.stream;

  /// The survey to be filled in
  RPTask? surveyTask;

  /// The callback function providing a [SurveyPage] object to be displayed in the app.
  /// This function is called when the survey is triggered, i.e. in the
  /// [SurveyProbe.resume] method.
  ///
  /// This callback function needs to be provided by the app on runtime.
  /// I.e. this part of the measure cannot be specified in the JSON format of
  /// the measure as e.g. downloaded from a study manager.
  void Function(SurveyPage)? onSurveyTriggered;

  /// The callback function to be called when the survey is submitted by the
  /// user. Carries the [RPTaskResult] result of the survey.
  void Function(RPTaskResult)? onSurveySubmit;

  /// The callback function to be called when the survey is canceled by the user.
  /// The optional [RPTaskResult] is provided at it's current state. Can be null.
  void Function([RPTaskResult?])? onSurveyCancel;

  SurveyProbe({
    this.onSurveyTriggered,
    this.onSurveySubmit,
    this.onSurveyCancel,
  }) : super();

  void onInitialize(Measure measure) {
    assert(measure is RPTaskMeasure);
    surveyTask = (measure as RPTaskMeasure).surveyTask;
  }

  Future onResume() async {
    if (onSurveyTriggered == null) {
      warning(
          "The 'onSurveyTriggered' callback fundtion has not been set in $runtimeType");
    } else {
      onSurveyTriggered!(SurveyPage(
        task: surveyTask!,
        resultCallback: _onSurveySubmit,
        onSurveyCancel: onSurveyCancel,
      ));
    }
  }

  Future onRestart() async {}
  Future onPause() async {}
  Future onStop() async {}

  void _onSurveySubmit(RPTaskResult result) {
    // when we have the survey result, add it to the event stream
    controller.add(DataPoint.fromData(RPTaskResultDatum(result)));
    if (onSurveySubmit != null) onSurveySubmit!(result);
  }
}
