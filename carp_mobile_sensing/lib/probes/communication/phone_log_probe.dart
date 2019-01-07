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
  PhoneLogProbe() : super();

  @override
  void initialize(Measure measure) {
    assert(measure is PhoneLogMeasure, 'A PhoneLogProbe must be intialized with a PhoneLogMeasure');
    super.initialize(measure);
  }

  @override
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
