import 'dart:math';

import 'package:flutter/material.dart';

class SwitchIcon extends StatefulWidget {
  final double size;
  final Function onTap; 
  const SwitchIcon({Key key, this.size = 28.0,@required this.onTap}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SwitchIconState();
}

class _SwitchIconState extends State<SwitchIcon>
    with TickerProviderStateMixin<SwitchIcon> {
  AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: InkWell(
          onTap: () {
            widget.onTap();
            if(controller.value==0.0){
              controller.forward();
            }
            else{
              controller.reverse();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.switch_camera,
              color: Colors.white,
              size: 28.0,
            ),
          )),
      builder: (context, child) {
        return Transform.rotate(
          angle:  pi * controller.value,
          child: child,
        );
      },
    );
  }
}
