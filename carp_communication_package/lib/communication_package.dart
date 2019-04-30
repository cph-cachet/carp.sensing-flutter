/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// This is the base class for this communication sampling package.
///
/// To use this package, register it in the [carp_mobile_sensing] package using
///
/// ```
///   SamplingPackageRegistry.register(CommunicationSamplingPackage());
/// ```
class CommunicationSamplingPackage implements SamplingPackage {
  static const String PHONE_LOG = "phone_log";
  static const String TELEPHONY = "telephony";
  static const String TEXT_MESSAGE_LOG = "text-message-log";
  static const String TEXT_MESSAGE = "text-message";
  static const String CALENDAR = "text-message";

  List<String> get dataTypes => [
        PHONE_LOG,
        //TELEPHONY,
        TEXT_MESSAGE_LOG,
        TEXT_MESSAGE,
        CALENDAR,
      ];

  Probe create(String type) {
    switch (type) {
      case PHONE_LOG:
        return PhoneLogProbe();
      case TEXT_MESSAGE_LOG:
        return TextMessageLogProbe();
      case TEXT_MESSAGE:
        return TextMessageProbe();
      case TELEPHONY:
        throw "Not implemented yet";
      case CALENDAR:
        return CalendarProbe();
      default:
        return null;
    }
  }

  void onRegister() {
    FromJsonFactory.registerFromJsonFunction("PhoneLogMeasure", PhoneLogMeasure.fromJsonFunction);
    FromJsonFactory.registerFromJsonFunction("CalendarMeasure", CalendarMeasure.fromJsonFunction);

    TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).add(TEXT_MESSAGE, text_message_datum_anoymizer);
    TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).add(TEXT_MESSAGE_LOG, text_message_log_anoymizer);
    TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).add(PHONE_LOG, phone_log_anoymizer);
    TransformerSchemaRegistry.lookup(PrivacySchema.DEFAULT).add(CALENDAR, calendar_anoymizer);
  }

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) communication sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          PHONE_LOG,
          PhoneLogMeasure(MeasureType(NameSpace.CARP, PHONE_LOG),
              name: 'Phone Log', enabled: true, frequency: 1 * 24 * 60 * 60 * 1000, days: 2)),
      MapEntry(TEXT_MESSAGE_LOG,
          Measure(MeasureType(NameSpace.CARP, TEXT_MESSAGE_LOG), name: 'Text Message (SMS) Log', enabled: true)),
      MapEntry(
          TEXT_MESSAGE, Measure(MeasureType(NameSpace.CARP, TEXT_MESSAGE), name: 'Text Message (SMS)', enabled: true)),
      MapEntry(
          CALENDAR,
          CalendarMeasure(MeasureType(NameSpace.CARP, CALENDAR),
              name: 'Calendar Events', enabled: true, frequency: 1 * 24 * 60 * 60 * 1000, daysBack: 1, daysFuture: 1)),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light communication sampling'
    ..measures[PHONE_LOG].enabled = false
    ..measures[TEXT_MESSAGE_LOG].enabled = false
    ..measures[TEXT_MESSAGE].enabled = false
    ..measures[CALENDAR].enabled = false;

  SamplingSchema get minimum => light..type = SamplingSchemaType.MINIMUM;

  SamplingSchema get normal => common;
}
