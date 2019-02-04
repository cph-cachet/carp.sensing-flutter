/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A library for collecting communication data, from
///  * text messages (sms)
///  * phone calls
library communication_package;

import 'package:json_annotation/json_annotation.dart';
import 'package:sms/sms.dart';
import 'dart:async';
import 'package:call_log/call_log.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'communication_datum.dart';
part 'communication_probes.dart';
part 'communication_measures.dart';
part 'communication_package.g.dart';

class CommunicationSamplingPackage implements SamplingPackage {
  static const String PHONE_LOG = "phone_log";
  static const String TELEPHONY = "telephony";
  static const String TEXT_MESSAGE_LOG = "text-message-log";
  static const String TEXT_MESSAGE = "text-message";

  List<String> get dataTypes => [
        PHONE_LOG,
        //TELEPHONY,
        TEXT_MESSAGE_LOG,
        TEXT_MESSAGE,
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
      default:
        return null;
    }
  }

  void onRegister() {
    FromJsonFactory.registerFromJsonFunction("PhoneLogMeasure", PhoneLogMeasure.fromJsonFunction);
  }

  SamplingSchema get common => SamplingSchema()
    ..type = SamplingSchemaType.COMMON
    ..name = 'Common (default) communication sampling schema'
    ..powerAware = true
    ..measures.addEntries([
      MapEntry(DataType.PHONE_LOG,
          PhoneLogMeasure(MeasureType(NameSpace.CARP, DataType.PHONE_LOG), name: 'Phone Log', enabled: true, days: 30)),
      MapEntry(
          DataType.TEXT_MESSAGE_LOG,
          Measure(MeasureType(NameSpace.CARP, DataType.TEXT_MESSAGE_LOG),
              name: 'Text Message (SMS) Log', enabled: true)),
      MapEntry(DataType.TEXT_MESSAGE,
          Measure(MeasureType(NameSpace.CARP, DataType.TEXT_MESSAGE), name: 'Text Message (SMS)', enabled: true)),
    ]);

  SamplingSchema get light => common
    ..type = SamplingSchemaType.LIGHT
    ..name = 'Light communication sampling'
    ..measures[PHONE_LOG].enabled = false
    ..measures[TEXT_MESSAGE_LOG].enabled = false
    ..measures[TEXT_MESSAGE].enabled = false;

  SamplingSchema get minimum => light..type = SamplingSchemaType.MINIMUM;

  SamplingSchema get normal => common;
}
