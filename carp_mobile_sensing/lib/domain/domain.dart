/// The CAMS implementation of the core CARP domain classes like
/// [StudyProtocol], [TaskDescriptor], and [Measure].
/// Also hold JSON serialization and deseralization logic to handle seraialization
/// of the domain objects.
library domain;

import 'dart:io';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import 'package:carp_core/carp_core.dart';

part 'study_protocol.dart';
part 'sampling_schema.dart';
part 'measures.dart';
part 'device_descriptor.dart';
part 'device_deployment.dart';
part 'app_task.dart';
part 'triggers.dart';
part 'datum.dart';
part 'device_info.dart';
part 'task_descriptor.dart';
part 'transformers.dart';

part 'domain.g.dart';

bool _fromJsonFunctionsRegistrered = false;

/// Register all the fromJson functions for the deployment domain classes.
void registerFromJsonFunctions() {
  if (_fromJsonFunctionsRegistrered) return;
  _fromJsonFunctionsRegistrered = true;

  // Protocol classes
  FromJsonFactory().register(CAMSStudyProtocol());
  FromJsonFactory().register(ProtocolOwner());
  FromJsonFactory().register(DataEndPoint());
  FromJsonFactory().register(StudyProtocolDescription());
  // FromJsonFactory().register(FileDataEndPoint());

  // Task classes
  FromJsonFactory().register(AutomaticTask());
  FromJsonFactory().register(AppTask());

  // Trigger classes
  FromJsonFactory().register(CAMSTrigger());
  FromJsonFactory().register(ImmediateTrigger());
  FromJsonFactory().register(DelayedTrigger());
  FromJsonFactory().register(PeriodicTrigger());
  FromJsonFactory().register(DateTimeTrigger());
  FromJsonFactory().register(Time());
  FromJsonFactory().register(RecurrentScheduledTrigger());
  FromJsonFactory().register(SamplingEventTrigger());
  FromJsonFactory().register(ConditionalEvent({}));
  FromJsonFactory().register(ConditionalSamplingEventTrigger());

  // Measure classes
  // FromJsonFactory().register(DataType('', ''));
  FromJsonFactory().register(CAMSMeasure());
  FromJsonFactory().register(PeriodicMeasure());
  FromJsonFactory().register(MarkedMeasure());

  // Datum classes
}
