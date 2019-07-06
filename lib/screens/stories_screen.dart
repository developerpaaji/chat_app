import 'package:chat_app/controllers/stories_controller.dart';
import 'package:chat_app/models/story.dart';
import 'package:chat_app/screens/story_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StoriesScreen extends StatefulWidget {
  final List<Story> stories;
  final int initalPage;
  const StoriesScreen({Key key, @required this.stories, this.initalPage = 0})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  PageController controller;
  @override
  void initState() {
    super.initState();
    controller = PageController(
      initialPage: widget.initalPage,
    );
    SystemChrome.setEnabledSystemUIOverlays([]);
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        Navigator.of(context).popUntil(ModalRoute.withName('/main'));
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: PageView.builder(
          controller: controller,
          itemBuilder: (context, index) => StoryScreen(
            onCompleted: () {
              if(index==widget.stories.length-1){
                Navigator.of(context).popUntil(ModalRoute.withName('/main'));
              }
              print("Next Page");
              controller.animateToPage(index+1, duration: Duration(seconds: 1), curve: Curves.easeInCubic);
            },
            story: widget.stories[index],
          ),
          itemCount: widget.stories.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top,SystemUiOverlay.bottom]);
    super.dispose();
  }
}
