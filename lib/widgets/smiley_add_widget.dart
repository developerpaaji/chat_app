import 'package:chat_app/models/smiley_data.dart';
import 'package:flutter/material.dart';

import 'ease_in_widget.dart';

class SmileyAddWidget extends StatefulWidget {
  final Function(SmileyData) onSelected;

  const SmileyAddWidget({Key key, @required this.onSelected}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SmileyAddWidgetState();
}

class _SmileyAddWidgetState extends State<SmileyAddWidget> {
  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  AnimationController controller;
  List<String> smilies = [
    "sticker1",
    "sticker2",
    "sticker3",
    "sticker4"
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.onSelected(null);
      },
      child: Scaffold(
        key: key,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  widget.onSelected(null);
                },
                child: Text(
                  "Done",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: Colors.white),
                ))
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0))),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return EaseInWidget(
                onTap: (){
                  widget.onSelected(SmileyData(smileyPath: "images/${smilies[index]}.png"));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "images/${smilies[index]}.png",
                  ),
                ),
              );
            },
            itemCount: smilies.length,
            shrinkWrap: true,
          ),
        ),
      ),
    );
  }
}
