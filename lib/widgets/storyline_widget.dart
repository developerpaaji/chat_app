import 'package:flutter/material.dart';

class StorylineWidget extends StatefulWidget {
  final AnimationController controller;
  final bool completed;
  const StorylineWidget({Key key,@required this.controller,this.completed=false}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _StorylineWidgetState();

}
class _StorylineWidgetState extends State<StorylineWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0),
      child: LayoutBuilder(
        builder: (context,constraints){
          double width=constraints.maxWidth;
          double height=2.0;
          return widget.controller!=null?AnimatedBuilder(
            animation: widget.controller,
            builder: (context,child)=>Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white54,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                ),
                Container(
                  height: height,
                  width: widget.controller!=null?width*widget.controller.value:width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                )
              ],
            ),
            child: Container(width: 0.0,height: 0.0,),
          ):Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: widget.completed?Colors.white:Colors.white24,
              borderRadius: BorderRadius.circular(3.0),
            ),
          );
        },
      ),
    );
  }

}