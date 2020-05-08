// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Chat _$ChatFromJson(Map<String, dynamic> json) {
  return Chat(
      json['content'],
      json['from'] == null
          ? null
          : User.fromJson(json['from'] as Map<String, dynamic>),
      json['to'] == null
          ? null
          : User.fromJson(json['to'] as Map<String, dynamic>),
      json['isSeen'] as bool,
      json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String),
      json['type'] as String,
      json['groupId'] as String);
}

Map<String, dynamic> _$ChatToJson(Chat instance) => <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'from': instance.from,
      'to': instance.to,
      'isSeen': instance.isSeen,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'groupId': instance.groupId
    };
