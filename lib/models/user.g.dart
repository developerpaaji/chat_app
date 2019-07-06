// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(json['displayName'] as String, json['profilePicture'] as String,
      json['id'] as String, json['isActive'] as bool);
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'displayName': instance.displayName,
      'profilePicture': instance.profilePicture,
      'id': instance.id,
      'isActive': instance.isActive
    };
