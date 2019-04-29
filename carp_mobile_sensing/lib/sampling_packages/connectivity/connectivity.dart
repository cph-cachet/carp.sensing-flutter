/// A library for collecting connectivity data on:
/// * bluetooth info from nearby devices
/// * connectivity status
library connectivity;

import 'dart:async';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:connectivity/connectivity.dart';

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

part 'connectivity_probes.dart';
part 'connectivity_datum.dart';
part 'connectivity.g.dart';
part 'connectivity_package.dart';
part 'connectivity_privacy.dart';
