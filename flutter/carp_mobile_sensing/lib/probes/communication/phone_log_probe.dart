/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// A probe that collects the phone log from this device.
/// Only collects this information once.
///
/// TODO: This probes does not work yet. See issue.
class PhoneLogProbe extends DatumProbe {
  PhoneLogProbe(ProbeMeasure _measure) : super(_measure);

  @override
  Future<Datum> getDatum() async {
    PhoneLogDatum pld = new PhoneLogDatum();

    // The phone_log pluging does not support Dart 2.0.
    // The code below doesn't work until this is fixed.
/*
    var _callLogs = await PhoneLog.getPhoneLogs(
        // startDate: 20180605, duration: 15 seconds
        startDate: new Int64(1525590000000),
        duration: new Int64(13));

    for (CallRecord call in _callRecords ?? []) {
      DateTime _timestamp =
          new DateTime(call.dateYear, call.dateMonth, call.dateDay, call.dateHour, call.dateMinute, call.dateSecond);
      PhoneCall _pc = new PhoneCall(_timestamp, call.callType, call.duration, call.formatedNumber, call.number);
      pld.phoneLog.add(_pc);
    }
*/

    return pld;
  }
}
