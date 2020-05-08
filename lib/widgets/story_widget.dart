import 'package:chat_app/models/story.dart';
import 'package:chat_app/widgets/user_widget.dart';
import 'package:flutter/material.dart';

import 'ease_in_widget.dart';

class StoryWidget extends StatelessWidget {
  final Story story;
  final double size;
  final Function onTap;
  final bool rounded;
  final bool current;
  const StoryWidget(
      {Key key,
      @required this.story,
      @required this.size,
      @required this.onTap,
      this.rounded = true,
      this.current = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EaseInWidget(
        onTap: onTap, child: rounded ? _buildRounded() : _buildRectangle());
  }

  Widget _buildRectangle() {
    double width = 100.0;
    return Container(
      color: Color(0xffeeeeee),
      margin: EdgeInsets.only(left: 12.0),
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              story.data[0].link,
              width: width,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: width,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                UserWidget(
                  user: story.user,
                  size: 12.0,
                ),
                Expanded(
                  child: Container(
                    width: width,
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      !current
                          ? story.user.displayName.split(" ")[0]
                          : "Your Story",
                      maxLines: 2,
                      style: TextStyle(color: Colors.white, fontSize: 12.0),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRounded() {
    double diff = 6.0;
    return Container(
      margin: EdgeInsets.only(left: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: !story.isSeen
                        ? Colors.blue
                        : Color(
                            0xffeeeeee,
                          ),
                    width: 3.0)),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Container(
                  width: size - diff,
                  height: size - diff,
                  decoration: BoxDecoration(
                      color: Color(0xffeeeeeee), shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/placeholder.png',
                      image: story.user.profilePicture,
                      width: size - diff,
                      height: size - diff,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: size,
                  height: size,
                  alignment: Alignment.bottomRight,
                  child: story.user.isActive
                      ? Container(
                          width: 16.0,
                          height: 16.0,
                          alignment: Alignment.center,
                          child: Container(
                            width: 10.0,
                            height: 10.0,
                            decoration: BoxDecoration(
                                color: Colors.yellow, shape: BoxShape.circle),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                        )
                      : null,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              !current ? story.user.firstName : "Your Story",
              style: TextStyle(
                  color: !story.isSeen ? Colors.black : Colors.black38,
                  fontSize: 12.0),
            ),
          ),
        ],
      ),
    );
  }
}
