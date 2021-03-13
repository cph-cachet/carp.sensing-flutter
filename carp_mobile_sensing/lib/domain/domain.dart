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

import 'package:carp_mobile_sensing/carp_core/carp_core.dart';

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

/// Register all the fromJson functions for the deployment domain classes.
void registerFromJsonFunctions() {
  // info('Register all the fromJson function for the CAMS domain classes.');

  FromJsonFactory().register(CAMSStudyProtocol());
  FromJsonFactory().register(ProtocolOwner());
  FromJsonFactory().register(DataEndPoint());
  // FromJsonFactory().register(FileDataEndPoint());

  FromJsonFactory().register(AutomaticTask());
  FromJsonFactory().register(AppTask(type: 'ignored'));

  FromJsonFactory().register(CAMSTrigger());
  FromJsonFactory().register(ImmediateTrigger());
  FromJsonFactory().register(DelayedTrigger());
  FromJsonFactory().register(PeriodicTrigger(period: null));
  FromJsonFactory().register(DateTimeTrigger(schedule: null));
  FromJsonFactory().register(Time());
  FromJsonFactory().register(RecurrentScheduledTrigger(type: null, time: null));
  FromJsonFactory().register(SamplingEventTrigger(measureType: null));
  FromJsonFactory()
      .register(ConditionalSamplingEventTrigger(measureType: null));
  // FromJsonFactory().register(DataType('', ''));
  FromJsonFactory().register(CAMSMeasure());
  FromJsonFactory().register(PeriodicMeasure());
  FromJsonFactory().register(MarkedMeasure());
}
