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

  Future initialize(
    String studyDeploymentId,
    DataEndPoint dataEndPoint,
    Stream<DataPoint> data,
  ) async {
    await super.initialize(studyDeploymentId, dataEndPoint, data);
    assert(dataEndPoint is DataEndPoint);
  }

  void onDataPoint(DataPoint dataPoint) => print('>> ${jsonEncode(dataPoint)}');

  void onDone() {}

  void onError(Object error) => print('>> ${jsonEncode(ErrorDatum(error))}');

  String toString() => 'JSON Print Data Manager';
}
