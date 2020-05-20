// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_auth;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuthToken _$OAuthTokenFromJson(Map<String, dynamic> json) {
  return OAuthToken(
    json['access_token'] as String,
    json['refresh_token'] as String,
    json['token_type'] as String,
    json['expires_in'] as int,
    json['scope'] as String,
  );
}

Map<String, dynamic> _$OAuthTokenToJson(OAuthToken instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('access_token', instance.accessToken);
  writeNotNull('refresh_token', instance.refreshToken);
  writeNotNull('token_type', instance.tokenType);
  writeNotNull('scope', instance.scope);
  writeNotNull('expires_in', instance.expiresIn);
  return val;
}
