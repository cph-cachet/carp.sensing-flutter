/// A library for collecting data from apps on the phone.
library carp_apps_package;

import 'package:json_annotation/json_annotation.dart';
import 'package:device_apps/device_apps.dart';
import 'dart:async';
import 'package:app_usage/app_usage.dart' as app_usage;
import 'dart:io';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'apps_data.dart';
part 'app_probes.dart';
part 'apps_package.dart';
part 'apps.g.dart';
