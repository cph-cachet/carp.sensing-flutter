// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthToken _$OAuthTokenFromJson(Map<String, dynamic> json) => OAuthToken(
      json['access_token'] as String,
      json['refresh_token'] as String,
      json['token_type'] as String,
      DateTime.parse(json['expires_at'] as String),
      (json['scope'] as List<dynamic>).map((e) => e as String).toList(),
      json['id_token'] as String,
    )..expiresIn = (json['expires_in'] as num?)?.toInt();

Map<String, dynamic> _$OAuthTokenToJson(OAuthToken instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'id_token': instance.idToken,
      'scope': instance.scope,
      'expires_at': instance.expiresAt.toIso8601String(),
      if (instance.expiresIn case final value?) 'expires_in': value,
    };

CarpUser _$CarpUserFromJson(Map<String, dynamic> json) => CarpUser(
      username: json['username'] as String,
      id: json['id'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      roles: json['roles'] as List<dynamic>? ?? const [],
      token: json['token'] == null
          ? null
          : OAuthToken.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CarpUserToJson(CarpUser instance) => <String, dynamic>{
      'username': instance.username,
      'id': instance.id,
      if (instance.email case final value?) 'email': value,
      if (instance.firstName case final value?) 'first_name': value,
      if (instance.lastName case final value?) 'last_name': value,
      'roles': instance.roles,
      if (instance.token?.toJson() case final value?) 'token': value,
    };
