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
class CommunicationSamplingPackage extends SmartphoneSamplingPackage {
  static const String PHONE_LOG = "phone_log";
  static const String TELEPHONY = "telephony";
  static const String TEXT_MESSAGE_LOG = "text_message_log";
  static const String TEXT_MESSAGE = "text_message";
  static const String CALENDAR = "calendar";

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
    FromJsonFactory().register(CalendarMeasure());

    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)
        .add(TEXT_MESSAGE, textMessageDatumAnoymizer);
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)
        .add(TEXT_MESSAGE_LOG, textMessageLogAnoymizer);
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)
        .add(PHONE_LOG, phoneLogAnoymizer);
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)
        .add(CALENDAR, calendarAnoymizer);
  }

  List<Permission> get permissions =>
      [Permission.phone, Permission.sms, Permission.calendar];

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) communication sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(
          PHONE_LOG,
          MarkedMeasure(
            type: PHONE_LOG,
            measureDescription: {
              'en': MeasureDescription(
                name: 'Phone Log',
                description:
                    "Collects the log on in- and out-going calls from the phone",
              )
            },
            history: Duration(days: 1),
          )),
      MapEntry(
          TEXT_MESSAGE_LOG,
          CAMSMeasure(
            type: TEXT_MESSAGE_LOG,
            measureDescription: {
              'en': MeasureDescription(
                name: 'Text Messages Log',
                description:
                    "Collects the log on in- and out-going text messages (SMS) from the phone",
              )
            },
          )),
      MapEntry(
          TEXT_MESSAGE,
          CAMSMeasure(
            type: TEXT_MESSAGE,
            measureDescription: {
              'en': MeasureDescription(
                name: 'Text Messages',
                description:
                    "Collects the event when a text messages (SMS) is send or received",
              )
            },
          )),
      MapEntry(
          CALENDAR,
          CalendarMeasure(
            type: CALENDAR,
            measureDescription: {
              'en': MeasureDescription(
                name: 'Calendar Events',
                description:
                    "Collects the list of calendar events on the calenders on the phone",
              )
            },
            past: Duration(days: 1),
            future: Duration(days: 1),
          )),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light communication sampling'
    ..measures[PHONE_LOG].enabled = false
    ..measures[TEXT_MESSAGE_LOG].enabled = false
    ..measures[TEXT_MESSAGE].enabled = false
    ..measures[CALENDAR].enabled = false;

  SamplingSchema get minimum => light..type = SamplingSchemaType.minimum;

  SamplingSchema get normal => common;

  SamplingSchema get debug => common
    ..type = SamplingSchemaType.DEBUG
    ..name = 'Debugging communication sampling schema'
    ..powerAware = false
    ..measures[PHONE_LOG] =
        MarkedMeasure(type: PHONE_LOG, history: Duration(days: 1))
    ..measures[TEXT_MESSAGE_LOG] = CAMSMeasure(type: TEXT_MESSAGE_LOG)
    ..measures[CALENDAR] = CalendarMeasure(
      type: CALENDAR,
      past: Duration(days: 1),
      future: Duration(days: 1),
    );
}
