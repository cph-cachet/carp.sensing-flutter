/*
 * Copyright 2018-2022 Copenhagen Center for Health Technology (CACHET) at the
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
  /// Measure type for collection of the phone log for a specific time period.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use the [HistoricSamplingConfiguration] for configuration.
  static const String PHONE_LOG = "dk.cachet.carp.phone_log";

  // static const String TELEPHONY = "dk.cachet.carp.telephony";

  /// Measure type for collection of the text message (SMS) log for a specific
  /// time period.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use the [HistoricSamplingConfiguration] for configuration.
  static const String TEXT_MESSAGE_LOG = "dk.cachet.carp.text_message_log";

  /// Measure type for collection of text message (SMS) as they are recieved.
  ///  * Event-based measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * No sampling configuration needed.
  static const String TEXT_MESSAGE = "dk.cachet.carp.text_message";

  /// Measure type for collection of calendar entries from the calendar on the
  /// phone for a specific period.
  ///  * One-time measure.
  ///  * Uses the [Smartphone] master device for data collection.
  ///  * Use the [HistoricSamplingConfiguration] for configuration.
  static const String CALENDAR = "dk.cachet.carp.calendar";

  @override
  List<String> get dataTypes => [
        PHONE_LOG,
        //TELEPHONY,
        TEXT_MESSAGE_LOG,
        TEXT_MESSAGE,
        CALENDAR,
      ];

  @override
  Probe? create(String type) {
    switch (type) {
      case PHONE_LOG:
        return (Platform.isAndroid) ? PhoneLogProbe() : null;
      case TEXT_MESSAGE_LOG:
        return (Platform.isAndroid) ? TextMessageLogProbe() : null;
      case TEXT_MESSAGE:
        return (Platform.isAndroid) ? TextMessageProbe() : null;
      // case TELEPHONY:
      //   throw "Not implemented yet";
      case CALENDAR:
        return CalendarProbe();
      default:
        return null;
    }
  }

  @override
  void onRegister() {
    // register the default privacy transformers
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .add(TEXT_MESSAGE, textMessageDatumAnoymizer);
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .add(TEXT_MESSAGE_LOG, textMessageLogAnoymizer);
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .add(PHONE_LOG, phoneLogAnoymizer);
    TransformerSchemaRegistry()
        .lookup(PrivacySchema.DEFAULT)!
        .add(CALENDAR, calendarAnoymizer);
  }

  @override
  List<Permission> get permissions =>
      [Permission.phone, Permission.sms, Permission.calendar];

  @override
  SamplingSchema get samplingSchema => SamplingSchema()
    ..addConfiguration(
        PHONE_LOG,
        HistoricSamplingConfiguration(
          past: const Duration(days: 1),
          future: const Duration(days: 1),
        ))
    ..addConfiguration(
        TEXT_MESSAGE_LOG,
        HistoricSamplingConfiguration(
          past: const Duration(days: 1),
          future: const Duration(days: 1),
        ))
    ..addConfiguration(
        CALENDAR,
        HistoricSamplingConfiguration(
          past: const Duration(days: 1),
          future: const Duration(days: 1),
        ));
}
