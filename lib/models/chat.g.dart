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
          : User.fromJson(Map<String, dynamic>.from(json['from'])),
      json['to'] == null
          ? null
          : User.fromJson(Map<String, dynamic>.from(json['to']) ),
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
      'from': instance.from.toJson(),
      'to': instance.to.toJson(),
      'isSeen': instance.isSeen,
      'publishedAt': instance.publishedAt?.toIso8601String(),
      'groupId': instance.groupId
    };
