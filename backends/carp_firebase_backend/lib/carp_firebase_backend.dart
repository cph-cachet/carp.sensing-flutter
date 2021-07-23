library carp_firebase_backend;

import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'firebase/firebase_common.dart';
part 'firebase/firebase_data_endpoint.dart';
part 'firebase/firebase_data_managers.dart';
part 'carp_firebase_backend.g.dart';

/// Generic CARP Firebase Backend exception.
class CarpFirebaseBackendException implements Exception {
  dynamic message;
  CarpFirebaseBackendException([this.message]);
  String toString() => '$runtimeType - $message';
}
