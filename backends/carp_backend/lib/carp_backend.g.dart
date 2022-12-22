// GENERATED CODE - DO NOT MODIFY BY HAND

part of carp_backend;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CarpDataEndPoint _$CarpDataEndPointFromJson(Map<String, dynamic> json) =>
    CarpDataEndPoint(
      uploadMethod: $enumDecodeNullable(
              _$CarpUploadMethodEnumMap, json['uploadMethod']) ??
          CarpUploadMethod.DATA_STREAM,
      name: json['name'] as String? ?? 'CARP Web Services',
      uri: json['uri'] as String?,
      clientId: json['clientId'] as String?,
      clientSecret: json['clientSecret'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      deleteWhenUploaded: json['deleteWhenUploaded'] as bool? ?? true,
      dataFormat: json['dataFormat'] as String? ?? NameSpace.CARP,
    )
      ..$type = json['__type'] as String?
      ..type = json['type'] as String;

Map<String, dynamic> _$CarpDataEndPointToJson(CarpDataEndPoint instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('__type', instance.$type);
  val['type'] = instance.type;
  val['dataFormat'] = instance.dataFormat;
  val['uploadMethod'] = _$CarpUploadMethodEnumMap[instance.uploadMethod]!;
  val['name'] = instance.name;
  writeNotNull('uri', instance.uri);
  writeNotNull('clientId', instance.clientId);
  writeNotNull('clientSecret', instance.clientSecret);
  writeNotNull('email', instance.email);
  writeNotNull('password', instance.password);
  val['deleteWhenUploaded'] = instance.deleteWhenUploaded;
  return val;
}

const _$CarpUploadMethodEnumMap = {
  CarpUploadMethod.DATA_STREAM: 'DATA_STREAM',
  CarpUploadMethod.DATA_POINT: 'DATA_POINT',
  CarpUploadMethod.FILE: 'FILE',
};

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      id: json['id'] as String?,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.announcement,
      title: json['title'] as String?,
      subTitle: json['subTitle'] as String?,
      message: json['message'] as String?,
      url: json['url'] as String?,
      imagePath: json['imagePath'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': _$MessageTypeEnumMap[instance.type]!,
    'timestamp': instance.timestamp.toIso8601String(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('title', instance.title);
  writeNotNull('subTitle', instance.subTitle);
  writeNotNull('message', instance.message);
  writeNotNull('url', instance.url);
  writeNotNull('imagePath', instance.imagePath);
  return val;
}

const _$MessageTypeEnumMap = {
  MessageType.announcement: 'announcement',
  MessageType.article: 'article',
  MessageType.news: 'news',
};
