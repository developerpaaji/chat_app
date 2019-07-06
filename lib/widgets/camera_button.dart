import 'dart:async';
import 'package:flutter/material.dart';

import 'ease_in_widget.dart';

class CameraButton extends StatefulWidget {
  final dynamic takePicture;
  const CameraButton(
      {Key key,
      @required this.takePicture,})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton>
    with TickerProviderStateMixin<CameraButton> {
  double bigSize = 72.0, smallSize = 64.0;
  double borderRadius = 72.0;
  bool camera = true;
  AnimationController _controller;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 6));
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    double size=62.0;
    return EaseInWidget(
      onTap: (){
        takePicture();
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.all(4.0),
        decoration: BoxDecoration(color: Colors.transparent,shape: BoxShape.circle,border: Border.all(color: Colors.white.withOpacity(0.9),width: 4.0)),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: Colors.white70,shape: BoxShape.circle),
        ),
      ),
    );
  }


  void takePicture(){
    widget.takePicture().then((val){
      
    });
  }

}
