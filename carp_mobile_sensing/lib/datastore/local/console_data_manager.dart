/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

part of datastore;

/// A very simple data manager that just "uploads" the data to the console (i.e., prints it).
/// Used mainly for testing and debugging purposes.
class ConsoleDataManager extends AbstractDataManager {
  Study study;

  @override
  Future initialize(Study study) async {
    super.initialize(study);
  }

  @override
  Future<bool> uploadData(Datum data) async {
    print("^^^^^^^^^^^^^^^\n" + jsonEncode(data));
    return true;
  }

  @override
  Future close() async {}

  @override
  String toString() {
    return "JSON Print Data Manager";
  }
}
