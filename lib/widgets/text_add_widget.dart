import 'dart:math';

import 'package:chat_app/models/basic.dart';
import 'package:chat_app/models/text_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'color_box.dart';

class TextAddWidget extends StatefulWidget {
  final Function(Basic) onSelected;

  const TextAddWidget({Key key,@required this.onSelected}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _TextAddWidgetState();
}

class _TextAddWidgetState extends State<TextAddWidget> {
  List<Color> colors = [
    Colors.redAccent,
    Color(0xffE4E4E4),
    Colors.greenAccent,
    Colors.white,
    Colors.black,
    Color(0xff222930)
  ];
  List<ColorBox> boxes = [];
  int current = 0;
  bool filled=true;
  TextAlign textAlign=TextAlign.left;
  Widget textWidget;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < colors.length; i++) {
      boxes.add(ColorBox(
          color: colors[i],
          size: 25.0,
          onTap: () {
            onTap(i);
          }));
    }
    controller.addListener(() {
      setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((val){
      focusNode.requestFocus();
    });
  }

  void onTap(int i) {
    current = i;
    setState(() {
      for (int i = 0; i < colors.length; i++) {
        if (i != current) {
          boxes.removeAt(i);
          boxes.insert(
              i,
              ColorBox(
                color: colors[i],
                size: 25.0,
                smallBorder: true,
                onTap: () {
                  onTap(i);
                },
              ));
        } else {
          boxes.removeAt(i);
          boxes.insert(
              i,
              ColorBox(
                color: colors[i],
                size: 25.0,
                smallBorder: false,
                onTap: () {
                  onTap(i);
                },
              ));
        }
      }
    });
  }
  BoxDecoration decoration;
  TextStyle style;
  FocusNode focusNode=FocusNode();
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    style=TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w700,
        color: filled?textColor:colors[current],
        fontFamily: "B612Mono");
    decoration=BoxDecoration(
      color: filled?colors[current]:Colors.transparent,
      borderRadius: BorderRadius.circular(8.0),
    );
    textWidget= Container(
      padding: TextData.TEXT_PADDING,
      constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 3 / 4,
          minWidth: 45.0),
      width: (textSize) * 21.0,
      decoration: decoration,
      child: TextField(
        focusNode: focusNode,
        controller: controller,
        maxLines: null,
        expands: false,
        cursorColor: textColor,
        textAlign: textAlign,
        decoration: InputDecoration(
          border: InputBorder.none,
        ),
        style: style,
      ),
    );
    return WillPopScope(
      onWillPop: (){
        widget.onSelected(null);
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            fit: StackFit.expand,
            alignment: Alignment.topRight,
            children: <Widget>[
              Center(
                child:
                textWidget,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(onPressed: (){
                      popBack();
                    }, child: Text("Done",style: TextStyle(color: Colors.white,fontSize: 16.0),)),
                    buildSelection(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: buildTextOutline(filled),
                    ),
                    buildAlignmentButton(textAlign)
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: Container(
            height: 60.0,
            alignment: Alignment.center,
            child: ListView.builder(
              itemBuilder: (context, index) => boxes[index],
              itemCount: boxes.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
            ),
          ),
        ),
      ),
    );
  }

  get textColor {
    var o = (((colors[current].red * 299) +
            (colors[current].green * 587).toInt() +
            ((colors[current].blue) * 114).toInt()) /
        1000);
    return (o > 125) ? Colors.black : Colors.white;
  }

  get textSize {
    int i = 0;
    if(controller.text.length==0){
      return 1;
    }
    controller.text.split("\n").forEach((val) {
      i = max(val.length, i);
    });
    return i;
  }
  void popBack(){
    if(controller.text==null||controller.text.length==0){
      widget.onSelected(null);
      return;
    }
    widget.onSelected(TextData(data: controller.text, decoration: decoration, textStyle: style));
  }
  Widget buildSelection() {
    return RaisedButton(
      onPressed: popBack,
      color: Colors.white,
      shape: CircleBorder(),
      child: Icon(
        Icons.text_fields,
        color: Colors.black,
        size: 28.0,
      ),
      padding: EdgeInsets.all(8.0),
      elevation: 1.0,
    );
  }

  Widget buildTextOutline(bool check) {
    return RaisedButton(
      elevation: 0.0,
      shape: CircleBorder(),
      color: Colors.black54,
      onPressed: (){
        setState(() {
          filled=!filled;
        });
      },
      padding: EdgeInsets.all(12.0),
      child: ImageIcon(
        AssetImage(check?"images/font_filled.png":"images/font_outline.png"),
        size: 20.0,
        color: Colors.white,
      ),
    );
  }
  List<TextAlign> aligns=[TextAlign.left,TextAlign.center,TextAlign.right];
  int currentAlign=0;
  Widget buildAlignmentButton(TextAlign align){
    Map icons={
      TextAlign.center:Icons.format_align_center,
      TextAlign.left:Icons.format_align_left,
      TextAlign.right:Icons.format_align_right,
    };
    return RaisedButton(
      elevation: 0.0,
      shape: CircleBorder(),
      color: Colors.black54,
      onPressed: (){
        setState(() {
          textAlign=aligns[(++currentAlign)%3];
        });
      },
      padding: EdgeInsets.all(12.0),
      child: Icon(
        icons[align],
        size: 20.0,
        color: Colors.white,
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    SystemChrome.restoreSystemUIOverlays();
  }
}
