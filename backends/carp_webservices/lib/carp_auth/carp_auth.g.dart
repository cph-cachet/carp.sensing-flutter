// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'carp_auth.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthToken _$OAuthTokenFromJson(Map<String, dynamic> json) => OAuthToken(
      json['access_token'] as String,
      json['refresh_token'] as String,
      json['token_type'] as String,
      json['expires_in'] as int,
      (json['scope'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$OAuthTokenToJson(OAuthToken instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'token_type': instance.tokenType,
      'scope': instance.scope,
      'expires_in': instance.expiresIn,
    };

CarpUser _$CarpUserFromJson(Map<String, dynamic> json) => CarpUser(
      username: json['username'] as String,
      id: json['id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String,
      roles: (json['roles'] as List<dynamic>).map((e) => e as String).toList(),
      token: json['token'] == null
          ? null
          : OAuthToken.fromJson(json['token'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CarpUserToJson(CarpUser instance) {
  final val = <String, dynamic>{
    'username': instance.username,
    'id': instance.id,
    'email': instance.email,
    'first_name': instance.firstName,
    'last_name': instance.lastName,
    'roles': instance.roles,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('token', instance.token);
  return val;
}
