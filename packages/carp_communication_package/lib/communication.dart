/// A library for collecting communication data, from
///  * text messages (sms)
///  * phone calls
library communication;

import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:telephony/telephony.dart';
import 'package:call_log/call_log.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:crypto/crypto.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';

part 'communication_datum.dart';
part 'communication_probes.dart';
part 'communication_package.dart';
part 'communication_privacy.dart';
part 'communication.g.dart';
