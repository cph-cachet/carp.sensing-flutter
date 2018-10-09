/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:sms/sms.dart';

/// A probe that collects a list of text messages from this device.
/// Only collects this information once.
class TextMessageProbe extends DatumProbe {
  TextMessageProbe(ProbeMeasure _measure) : super(_measure);

  @override
  Future<Datum> getDatum() async {
    SmsQuery query = new SmsQuery();
    List<SmsMessage> _messages = await query.getAllSms;

    TextMessageLogDatum tmld = new TextMessageLogDatum();
    tmld.textMessageLog = _messages.map(smsToTextMessage).toList();
    return tmld;
  }

  TextMessage smsToTextMessage(SmsMessage sms) => TextMessage.fromSmsMessage(sms);
}
