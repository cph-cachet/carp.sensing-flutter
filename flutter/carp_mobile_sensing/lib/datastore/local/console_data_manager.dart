/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */
import 'dart:async';
import 'dart:convert';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

/// A very simple data manager that just "uploads" the data to the console (i.e., prints it).
/// Used mainly for testing and debugging purposes.
class ConsoleDataManager extends AbstractDataManager {
  Study study;

  @override
  Future initialize(Study study) {
    super.initialize(study);
  }

  @override
  Future<String> uploadData(Datum data) {
    print("^^^^^^^^^^^^^^^\n" + jsonEncode(data));
    return new Future.value("200 OK");
  }

  @override
  Future close() async {}

  @override
  String toString() {
    return "JSON Print Data Manager";
  }
}
