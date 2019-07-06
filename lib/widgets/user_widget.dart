import 'package:chat_app/models/user.dart';
import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  final User user;
  final double size;
  const UserWidget({Key key, @required this.user, this.size = 26.0})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(user.profilePicture),
          radius: size,
        ),
        user.isActive
            ? Container(
                decoration:
                    BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                padding: EdgeInsets.all(2.5),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.yellow, shape: BoxShape.circle),
                  width: size / 2,
                  height: size / 2,
                ),
              )
            : Container(
                width: 0.0,
                height: 0.0,
              )
      ],
    );
  }
}
