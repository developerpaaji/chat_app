import 'package:chat_app/controllers/json_controller.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  String displayName;
  String profilePicture;
  String id;
  bool isActive;

  User(this.displayName, this.profilePicture, this.id, this.isActive);

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(JsonController.convertToJson(json));

  factory User.fromNamed(
          {String displayName,
          String profilePicture,
          String id,
          bool isActive}) =>
      User(displayName, profilePicture, id, isActive);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  String get firstName => displayName.split(" ")[0];
}
