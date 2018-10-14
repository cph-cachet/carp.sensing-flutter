/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// A probe that collects a list of text messages from this device.
///
/// This probe only collects the list of SMS messages once.
/// If you want to listen to text messages being received,
/// use a [TextMessageProbe] instead.
class TextMessageLogProbe extends DatumProbe {
  TextMessageLogProbe(ProbeMeasure _measure) : super(_measure);

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

/// The [TextMessageProbe] listens to SMS messages and collects a
/// [TextMessageDatum] everytime a new SMS message is received.
class TextMessageProbe extends StreamSubscriptionListeningProbe {
  SmsReceiver _receiver;

  TextMessageProbe(TextMessageMeasure measure) : super(measure);

  @override
  void initialize() {
    super.initialize();
    _receiver = SmsReceiver();
  }

  @override
  Future start() async {
    super.start();

    // starting the subscription to the battery - triggered every time the charging level changes.
    subscription = _receiver.onSmsReceived.listen(onData, onError: onError, onDone: onDone, cancelOnError: true);
  }

  void onData(dynamic event) async {
    assert(event is SmsMessage);
    SmsMessage sms = event;

    TextMessageDatum _tmd = TextMessageDatum(TextMessage.fromSmsMessage(sms));

    this.notifyAllListeners(_tmd);
  }
}
