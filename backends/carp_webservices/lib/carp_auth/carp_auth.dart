/*
 * Copyright 2018 Copenhagen Center for Health Technology (CACHET) at the
 * Technical University of Denmark (DTU).
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

/// Contains classes for authentication to CARP.
library carp_auth;

import 'dart:async';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'oauth.dart';
part 'carp_user.dart';
part 'carp_auth.g.dart';
