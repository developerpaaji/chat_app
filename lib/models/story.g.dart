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
          : User.fromJson(Map<String, dynamic>.from(json['user']) ),
      json['isSeen'] as bool,
      (json['images'] as List)?.map((e) => e as String)?.toList(),
      json['publishedAt'] == null
          ? null
          : DateTime.parse(json['publishedAt'] as String));
}

Map<String, dynamic> _$StoryToJson(Story instance) => <String, dynamic>{
      'user': instance.user.toJson(),
      'id': instance.id,
      'isSeen': instance.isSeen,
      'images': instance.images,
      'publishedAt': instance.publishedAt?.toIso8601String()
    };
