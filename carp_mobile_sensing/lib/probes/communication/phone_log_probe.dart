/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of communication;

/// A probe that collects the phone log from this device.
/// Only collects this information when the [getDatum] method is called.
class PhoneLogProbe extends DatumProbe {
  PhoneLogProbe(PhoneLogMeasure _measure) : super(_measure);

  @override
  Future<Datum> getDatum() async {
    PhoneLogDatum pld = new PhoneLogDatum();
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

    for (CallLogEntry call in entries ?? []) {
      pld.phoneLog.add(PhoneCall.fromCallLogEntry(call));
    }

    return pld;
  }
}
