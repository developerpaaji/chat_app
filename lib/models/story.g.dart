// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Story _$StoryFromJson(Map<String, dynamic> json) {
  return Story(
      json['id'] as String,
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      json['isSeen'] as bool,
      (json['data'] as List)
          ?.map((e) =>
              e == null ? null : DataType.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String));
}

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'user': instance.user,
      'id': instance.id,
      'isSeen': instance.isSeen,
      'data': instance.data,
      'publishedAt': instance.publishedAt?.toIso8601String()
    };

DataType _$DataTypeFromJson(Map<String, dynamic> json) {
  return DataType(json['link'] as String, json['type'] as String);
}

Map<String, dynamic> _$DataTypeToJson(DataType instance) =>
    <String, dynamic>{'link': instance.link, 'type': instance.type};
