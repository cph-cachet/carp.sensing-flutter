/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of managers;

/// A very simple data manager that just "uploads" the data to the
/// console (i.e., prints it). Used mainly for testing and debugging purposes.
class ConsoleDataManager extends AbstractDataManager {
  String get type => DataEndPointTypes.PRINT;

  Future initialize(StudyProtocol study, Stream<Datum> data) async {
    assert(study.dataEndPoint is DataEndPoint);
    await super.initialize(study, data);
  }

  void onDatum(Datum datum) => print('>> ${jsonEncode(datum)}');

  void onDone() {}

  void onError(Object error) => print('>> ${jsonEncode(ErrorDatum(error))}');

  String toString() => 'JSON Print Data Manager';
}
