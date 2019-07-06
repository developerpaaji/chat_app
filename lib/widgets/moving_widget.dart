import 'package:flutter/material.dart';

class MovingWidget extends StatefulWidget {
  final Widget child;
  final Offset deleteOffset;
  final Function() onRemove;
  const MovingWidget({Key key,@required this.child,@required this.deleteOffset,@required this.onRemove}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _MovingWidgetState();

}

class _MovingWidgetState extends State<MovingWidget> {
  Offset globalPosition;
  double opacity=1.0;
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    if(globalPosition==null){
      globalPosition=Offset(MediaQuery.of(context).size.width/2, MediaQuery.of(context).size.height/2);
    }
    return AnimatedPositioned(
      duration: Duration(milliseconds: 100),
      top: globalPosition.dy,
      left: globalPosition.dx,
      child: GestureDetector(
        onPanEnd: (details){
          if(isRemovable){
            widget.onRemove();
          }
        },
        onPanUpdate: (DragUpdateDetails details){
          if(isRemovable){
            print("Delete");
            setState(() {
              opacity=0.4;
            });
          }
          else if(opacity!=1.0){
            setState(() {
              opacity=1.0;
            });
          }
          setState(() {
            print(details.globalPosition);
            globalPosition=details.globalPosition;
          });
        },
        child: Opacity(opacity: opacity,child: widget.child),
      ),
    );
  }
   bool get isRemovable{
      return (globalPosition-widget.deleteOffset).distance<20.0;
   }
}