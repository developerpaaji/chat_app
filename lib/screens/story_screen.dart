import 'package:chat_app/controllers/stories_controller.dart';
import 'package:chat_app/models/story.dart';
import 'package:chat_app/widgets/story_image_widget.dart';
import 'package:chat_app/widgets/storyline_widget.dart';
import 'package:flutter/material.dart';

class StoryScreen extends StatefulWidget {
  final Story story;
  final Function onCompleted;

  const StoryScreen({Key key, @required this.story, @required this.onCompleted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with TickerProviderStateMixin<StoryScreen> {
  AnimationController controller;
  List<StorylineWidget> storyLines = [];
  int current = 0;
  bool isLoaded = true;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    controller.forward(from: 0.0);
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (current == widget.story.data.length - 1) {
          widget.onCompleted();
          return;
        }
        if (current < widget.story.data.length - 1) {
          current++;
          if (isLoaded) controller.forward(from: 0.0);
        }
        buildStoryLines();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      buildStoryLines();
    });
  }

  void buildStoryLines() {
    storyLines.clear();
    for (int i = 0; i < widget.story.data.length; i++) {
      storyLines.add(StorylineWidget(
        controller: current == i ? controller : null,
        completed: i < current,
      ));
    }
    setState(() {});
    if (current == widget.story.data.length - 1) {
      StoriesController.updateStory(widget.story, true);
    }
  }

  double lastValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPress: () {
          lastValue = controller.value;
          controller.stop(canceled: false);
        },
        onLongPressEnd: (val) {
          controller.forward(from: lastValue);
          lastValue = 0.0;
        },
        child: Stack(
          children: <Widget>[
            StoryImageWidget(
              onLoaded: (val) {
                this.isLoaded = val;
                if (val) {
                  controller.forward(from: 0.0);
                } else {
                  controller.value = 0.0;
                }
              },
              image: widget.story.data[current].link,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    child: Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height,
                    ),
                    onTap: () {
                      jumpToPrevious();
                    },
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      jumpToNext();
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: storyLines
                              .map((child) => Expanded(
                                    child: child,
                                  ))
                              .toList(),
                        ),
                      ),
                      ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(Icons.arrow_back),
                                color: Colors.white,
                                onPressed: () {
                                  print("Popped");
                                  Navigator.of(context)
                                      .popUntil(ModalRoute.withName('/main'));
                                }),
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                widget.story.user.profilePicture,
                              ),
                              radius: 18.0,
                            ),
                          ],
                        ),
                        title: Text(widget.story.user.displayName,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500)),
                        subtitle: Text(
                          widget.story.publishedAt.toString().split(" ")[0],
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12.0,
                              fontWeight: FontWeight.w500),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {},
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                  storyReplyOptions()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget storyReplyOptions() {
    return Container(
      height: 45.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              color: Colors.black26,
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(25.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            width: MediaQuery.of(context).size.width * 2.5 / 4,
            alignment: Alignment.centerLeft,
            child: Text(
              "Send Message",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "😂",
                style: TextStyle(fontSize: 22.0),
              )),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "😀",
                style: TextStyle(fontSize: 22.0),
              )),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "😍",
                style: TextStyle(fontSize: 22.0),
              )),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "😘",
                style: TextStyle(fontSize: 22.0),
              )),
            ),
          ),
        ],
      ),
    );
  }

  void jumpToPrevious() {
    if (current > 0) {
      print("Prev");
      current--;
      buildStoryLines();
    }
  }

  void jumpToNext() {
    print("Next");
    controller.value = 1.0;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
