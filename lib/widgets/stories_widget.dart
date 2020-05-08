import 'package:chat_app/controllers/stories_controller.dart';
import 'package:chat_app/models/story.dart';
import 'package:chat_app/screens/stories_screen.dart';
import 'package:chat_app/widgets/story_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_story_button.dart';

class StoriesWidget extends StatefulWidget {
  final bool rounded;
  const StoriesWidget({Key key, this.rounded = false}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _StoriesWidgetState();
}

class _StoriesWidgetState extends State<StoriesWidget> {
  FirebaseUser user;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    this.user = await FirebaseAuth.instance.currentUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.rounded ? 81.0 : 140.0,
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      alignment: Alignment.center,
      child: user == null
          ? CircularProgressIndicator()
          : StreamBuilder<List<Story>>(
              stream: StoriesController.getStories(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Row(
                    children: <Widget>[
                      AddStoryButton(
                        rounded: widget.rounded,
                        size: 52.0,
                      ),
                      Expanded(
                          child: Center(child: CircularProgressIndicator())),
                    ],
                  );
                }
                List<Story> stories = snapshot.data;
                stories = stories
                    .where((val) =>
                        val != null && val.data != null && val.data.length != 0)
                    .toList();
                return ListView.builder(
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return AddStoryButton(
                        rounded: widget.rounded,
                        size: 52.0,
                      );
                    }
                    return StoryWidget(
                      size: 52.0,
                      rounded: widget.rounded,
                      current: stories[index - 1].user.id == user.email,
                      story: stories[index - 1],
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StoriesScreen(
                                  stories: stories,
                                  initalPage: index - 1,
                                )));
                      },
                    );
                  },
                  itemCount: stories.length + 1,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                );
              },
            ),
    );
  }
}
