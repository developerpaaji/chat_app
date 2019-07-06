import 'package:chat_app/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story{
  User user;
  String id;
  bool isSeen;
  List<String> images;
  DateTime publishedAt;
  Story(this.id,this.user,this.isSeen,this.images,this.publishedAt,);


  factory Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);
  Map<String, dynamic> toJson() => _$StoryToJson(this);
}