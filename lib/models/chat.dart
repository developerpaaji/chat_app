import 'package:chat_app/controllers/json_controller.dart';
import 'package:chat_app/models/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'chat.g.dart';

@JsonSerializable()
class Chat {
  static const String TEXT = "text";
  String type;
  dynamic content;
  User from, to;
  bool isSeen;
  DateTime publishedAt;
  String groupId;
  Chat(this.content, this.from, this.to, this.isSeen, this.publishedAt,
      this.type, this.groupId);

  factory Chat.fromJson(Map<String, dynamic> json) =>
      _$ChatFromJson(JsonController.convertToJson(json));
  factory Chat.fromNamed(
          {String content,
          User from,
          User to,
          bool isSeen,
          DateTime publishedAt,
          String type = TEXT}) =>
      Chat(content, from, to, isSeen, publishedAt, type, "");

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$ChatToJson`.
  Map<String, dynamic> toJson() => _$ChatToJson(this);
}
