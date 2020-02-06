/// A library for collecting survey from the [Research Package](https://pub.dev/packages/research_package):
///  * survey
library survey;

/// A [SamplingPackage] that knows how to collect data from user surveys based on the [research_package] package.
class ResearchPackageSamplingPackage implements SamplingPackage {
  static const String SURVEY = "survey";

  List<String> get dataTypes => [
        SURVEY,
      ];

  List<PermissionGroup> get permissions => []; // Research Package don't need any permission on the phone

  Probe create(String type) {
    switch (type) {
      case SURVEY:
        return RPTaskProbe();
      default:
        return null;
    }
  }

  void onRegister() {
    FromJsonFactory.registerFromJsonFunction("RPTaskMeasure", RPTaskMeasure.fromJsonFunction);
  }

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) user survey sampling schema'
    ..powerAware = false
    ..measures.addEntries([
      // Adding WHO5 as the default survey (mostly for testing purposes) issued once pr. day.
      MapEntry(
          SURVEY,
          PeriodicMeasure(MeasureType(NameSpace.CARP, SURVEY),
              name: 'WHO5', enabled: true, frequency: 24 * 60 * 60 * 1000)),
      //TODO -- add the WHO5 survey task
    ]);

  SamplingSchema get light => common;
  SamplingSchema get minimum => common;
  SamplingSchema get normal => common;

  @override
  // TODO: implement debug
  SamplingSchema get debug => null;
}

/// A class representing how to configure a [RPTask] as part of a sensing [Measure].
///
/// This is a [PeriodicMeasure] which can be triggered on a regular basis (frequency)
/// TODO - add support for other triggers, like on a certain time etc (need to update the trigger model in carp_mobile_sensing).
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RPTaskMeasure extends PeriodicMeasure {
  // TODO - fix when research_package supports serialization to JSON
  @JsonKey(ignore: true)
  RPOrderedTask surveyTask;

  RPTaskMeasure(MeasureType type, {String name, bool enabled, int frequency, int duration, this.surveyTask})
      : super(type, name: name, enabled: enabled, frequency: frequency, duration: duration);

  static Function get fromJsonFunction => _$RPTaskMeasureFromJson;
  factory RPTaskMeasure.fromJson(Map<String, dynamic> json) =>
      FromJsonFactory.fromJson(json[Serializable.CLASS_IDENTIFIER].toString(), json);
  Map<String, dynamic> toJson() => _$RPTaskMeasureToJson(this);
}

/// Holds information about the result of a survey.
@JsonSerializable(fieldRename: FieldRename.snake, includeIfNull: false)
class RPTaskResultDatum extends CARPDatum {
  static const DataFormat CARP_DATA_FORMAT = DataFormat(NameSpace.CARP, ResearchPackageSamplingPackage.SURVEY);
  DataFormat get format => CARP_DATA_FORMAT;

  // TODO - fix when research_package supports serialization to JSON
  @JsonKey(ignore: true)
  RPTaskResult surveyResult;

  RPTaskResultDatum([this.surveyResult]);

  factory RPTaskResultDatum.fromJson(Map<String, dynamic> json) => _$RPTaskResultDatumFromJson(json);
  Map<String, dynamic> toJson() => _$RPTaskResultDatumToJson(this);
}

/// The probe collecting a survey. When triggered, it adds a notification about the survey to the
/// notification queue. Once the survey is submitted later, then a [RPTaskResultDatum] is added to
/// the [carp_mobile_sensing] event queue.
class RPTaskProbe extends PeriodicDatumProbe {
  Future<Datum> getDatum() {
    reafelBloc.addSurveyToNotifications((measure as RPTaskMeasure).surveyTask, onSurveySubmit);

    // when returning null, no datum will be added to the events stream (at this time).
    return null;
  }

  void onSurveySubmit(RPTaskResult result) {
    // when we have the survey result, add it to the event stream
    controller.add(RPTaskResultDatum(result));
  }
}
