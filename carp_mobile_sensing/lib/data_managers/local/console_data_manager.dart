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
  @override
  String get type => DataEndPointTypes.PRINT;

  @override
  Future<void> onDataPoint(DataPoint dataPoint) async =>
      print(jsonEncode(dataPoint));

  @override
  Future<void> onDone() async {}

  @override
  Future<void> onError(error) async => print('ERROR >> $error');

  @override
  String toString() => 'JSON Print Data Manager';
}
