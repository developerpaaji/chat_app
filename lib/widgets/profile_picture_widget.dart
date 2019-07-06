import 'package:chat_app/controllers/user_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePictureWidget extends StatefulWidget {
  final double size;

  const ProfilePictureWidget({Key key, this.size = 50.0}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  String profilePic;
  @override
  void initState() {
    super.initState();
    UserController.getUser().then((user) {
      setState(() {
        profilePic = user.profilePicture;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double size = widget.size;
    return Container(
      height: size,
      width: size,
      decoration:
          BoxDecoration(color: Color(0xffeeeeee), shape: BoxShape.circle),
      child: profilePic != null
          ? ClipRRect(
              child: FadeInImage.assetNetwork(
                placeholder: "",
                image: profilePic,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(size),
            )
          : null,
    );
  }
}
