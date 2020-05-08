import 'package:chat_app/controllers/json_controller.dart';
import 'package:chat_app/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story.g.dart';

@JsonSerializable()
class Story {
  User user;
  String id;
  bool isSeen;
  List<DataType> data;
  DateTime publishedAt;
  Story(
    this.id,
    this.user,
    this.isSeen,
    this.data,
    this.publishedAt,
  );

  factory Story.fromJson(Map<String, dynamic> json) =>
      _$StoryFromJson(JsonController.convertToJson(json));
  Map<String, dynamic> toJson() => _$StoryToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DataType {
  static const String IMAGE = "image";
  final String link;
  final String type;

  DataType(this.link, this.type);

  Map<String, dynamic> toJson() => _$DataTypeToJson(this);

  factory DataType.fromJson(json) => _$DataTypeFromJson(json);
}
