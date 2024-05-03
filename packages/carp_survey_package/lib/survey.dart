/*
 * Copyright 2020-2023 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// A library for collecting survey from the [Research Package](https://pub.dev/packages/research_package):
///  * survey
library survey;

import 'package:json_annotation/json_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

import 'package:carp_serializable/carp_serializable.dart';
import 'package:carp_core/carp_core.dart';
import 'package:carp_mobile_sensing/carp_mobile_sensing.dart';
import 'package:research_package/research_package.dart';
import 'package:cognition_package/cognition_package.dart';

part 'survey.g.dart';
part 'survey_domain.dart';
part 'survey_package.dart';
part 'survey_ui.dart';
part 'who5.dart';
part 'survey_user_task.dart';
