/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A library for handling data stores.
library datastore;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:archive/archive_io.dart';

part 'local/console_data_manager.dart';
part 'local/file_data_manager.dart';

/// The [DataManager] interface is used to upload [Datum] objects to any
/// data manager that implements this interface.
abstract class DataManager {
  /// Initialize the data manager by specifying the running [Study].
  Future initialize(Study study);

  /// Upload data to the data store.
  /// Returns a message on whether data was successfully uploaded or not.
  Future<String> uploadData(Datum data);

  /// Close the data manager (e.g. closing connections).
  Future close();
}

/// An abstract [DataManager] implementation useful for extension.
abstract class AbstractDataManager implements DataManager {
  Study study;

  Future initialize(Study study) async {
    assert(study != null);
    this.study = study;
  }

  /// JSON encode an object.
  String jsonEncode(Object object) => const JsonEncoder.withIndent(' ').convert(object);
}

/// A registry of [DataManager]s.
///
/// When creating a new [DataManager] you can register it here using the [register()] method
/// which is later used to call [lookup()] when trying to find an appropriate [DataManager] for
/// a specific [DataEndPointType].
class DataManagerRegistry {
  static Map<String, DataManager> _registry = new Map<String, DataManager>();

  /// Register a [DataManager] with a specific type.
  static register(String type, DataManager manager) {
    _registry[type] = manager;
  }

  /// Lookup an instance of a [DataManager] based on the [DataEndPointType].
  static DataManager lookup(String type) {
    DataManager _manager = _registry[type];

    // if there is no manager registered, try to register some of the built-in ones.
    if (_manager == null) {
      switch (type) {
        case DataEndPointType.PRINT:
          _manager = new ConsoleDataManager();
          break;
        case DataEndPointType.FILE:
          _manager = new FileDataManager();
          break;
//        case DataEndPointType.FIREBASE:
//          _manager = new FirebaseStorageDataManager();
//          break;
//      case DataEndPointType.CARP:
//        _manager = new CARPBackend(authEndPoint, dataEndPoint);
//        break;
//      case DataEndPointType.OMH:
//        _manager = new OMHBackend();
//        break;
        default:
          _manager = new ConsoleDataManager();
          break;
      }
      register(type, _manager);
    }

    return _manager;
  }
}

/// An interface for defining a way to get a [Study].
abstract class StudyManager {
  Future<Study> getStudy(String studyId);
}
