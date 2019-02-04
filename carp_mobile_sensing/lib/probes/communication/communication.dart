/// A library for collecting communication data, from
/// * text messages (sms)
/// * phone calls
library communication;

import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sms/sms.dart';
import 'dart:async';
import 'package:call_log/call_log.dart';

part 'communication_datum.dart';
part 'communication_probes.dart';
part 'communication_measures.dart';
part 'communication_package.dart';
part 'communication.g.dart';
