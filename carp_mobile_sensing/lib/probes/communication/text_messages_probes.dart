/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// A probe that collects a complete list of all text (SMS) messages from this device.
///
/// This probe only collects the list of SMS messages once.
/// If you want to listen to text messages being received,
/// use a [TextMessageProbe] instead.
class TextMessageLogProbe extends DatumProbe {
  TextMessageLogProbe(Measure measure) : super(measure);

  Future<Datum> getDatum() async {
    SmsQuery query = new SmsQuery();
    List<SmsMessage> _messages = await query.getAllSms;
    return TextMessageLogDatum()..textMessageLog = _messages.map(_smsToTextMessage).toList();
  }

  TextMessage _smsToTextMessage(SmsMessage sms) => TextMessage.fromSmsMessage(sms);
}

/// The [TextMessageProbe] listens to SMS messages and collects a
/// [TextMessageDatum] every time a new SMS message is received.
class TextMessageProbe extends StreamProbe {
  SmsReceiver receiver = SmsReceiver();

  TextMessageProbe(Measure measure) : super(measure, textMessageStream);
}

Stream<Datum> get textMessageStream =>
    SmsReceiver().onSmsReceived.map((event) => TextMessageDatum.fromTextMessage(TextMessage.fromSmsMessage(event)));
