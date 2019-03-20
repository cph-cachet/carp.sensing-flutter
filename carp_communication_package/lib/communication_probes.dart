/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// A probe that collects the phone log from this device.
/// Only collects this information once when the [getDatum] method is called.
class PhoneLogProbe extends DatumProbe {
  Future<Datum> getDatum() async {
    int days = (measure as PhoneLogMeasure).days;
    Iterable<CallLogEntry> entries;
    if ((days == null) || (days == -1)) {
      entries = await CallLog.get();
    } else {
      var now = DateTime.now();
      int from = now.subtract(Duration(days: days)).millisecondsSinceEpoch;
      int to = now.millisecondsSinceEpoch;
      entries = await CallLog.query(dateFrom: from, dateTo: to);
    }

    PhoneLogDatum pld = new PhoneLogDatum();
    for (CallLogEntry call in entries ?? []) {
      pld.phoneLog.add(PhoneCall.fromCallLogEntry(call));
    }

    return pld;
  }
}

/// A probe that collects a complete list of all text (SMS) messages from this device.
///
/// This probe only collects the list of SMS messages once.
/// If you want to listen to text messages being received,
/// use a [TextMessageProbe] instead.
class TextMessageLogProbe extends DatumProbe {
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
  Stream<Datum> get stream =>
      SmsReceiver().onSmsReceived.map((event) => TextMessageDatum.fromTextMessage(TextMessage.fromSmsMessage(event)));
}
