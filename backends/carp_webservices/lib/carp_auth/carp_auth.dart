/// Contains classes for authentication to CARP Web Services (CAWS).
library carp_auth;

import 'dart:async';
import 'package:carp_webservices/carp_services/carp_services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:oidc/oidc.dart';
import 'package:oidc_default_store/oidc_default_store.dart';

part 'oauth.dart';
part 'carp_user.dart';
part 'carp_auth.g.dart';
part 'carp_auth_base_service.dart';
part 'carp_auth_properties.dart';
part 'carp_auth_service.dart';
