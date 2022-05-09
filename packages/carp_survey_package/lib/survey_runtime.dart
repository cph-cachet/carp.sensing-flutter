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
  List<Permission> get permissions => [];

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
        RPTaskSamplingConfiguration(surveyTask: RPTask(identifier: 'ignored')));
    AppTaskController().registerUserTaskFactory(SurveyUserTaskFactory());
  }

  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        SURVEY, RPTaskSamplingConfiguration(surveyTask: who5Task));
}

/// The probe collecting a survey.
///
/// When triggered, @TODO explain...
///
/// Once the survey is submitted later, then a [RPTaskResultDatum] is added to
/// the [carp_mobile_sensing] event queue.
class SurveyProbe extends Probe {
  // StreamController<DataPoint> controller = StreamController.broadcast();
  // Stream<DataPoint> get data => controller.stream;

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

  void onInitialize() {
    if (configuration?.overrideSamplingConfiguration
        is RPTaskSamplingConfiguration) {
      surveyTask = (configuration?.overrideSamplingConfiguration
              as RPTaskSamplingConfiguration)
          .surveyTask;
    } else {
      warning(
          '$runtimeType - no valid RPTask provided as survey ($surveyTask). Cannot initialize probe.');
    }
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
    addData(RPTaskResultDatum(result));
    if (onSurveySubmit != null) onSurveySubmit!(result);
  }
}
