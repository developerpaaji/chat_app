import 'dart:math';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/widgets/user_widget.dart';
import 'package:flutter/material.dart';

import 'ease_in_widget.dart';

class WaveUserWidget extends StatefulWidget {
  final User user;

  const WaveUserWidget({Key key, @required this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _WaveUserWidgetState();
}

class _WaveUserWidgetState extends State<WaveUserWidget> with TickerProviderStateMixin<WaveUserWidget>{
  bool isWaved=false;
  AnimationController controller;
  Animation bounceAnimation;
  @override
  void initState() {
    super.initState();
    controller=AnimationController(vsync: this,duration: Duration(milliseconds: 400));
    bounceAnimation=CurvedAnimation(parent: controller, curve: Curves.bounceIn);
  }
  @override
  Widget build(BuildContext context) {
    Color color=isWaved?Color(0xff3b5998):Colors.black;
    return ListTile(
      leading: UserWidget(
        user: widget.user,
        size: 18.0,
      ),
      title: Text(
        widget.user.displayName,
        style: TextStyle(fontSize: 14.0),
      ),
      trailing: EaseInWidget(
        onTap: (){
          isWaved=true;
          controller.animateTo(0.5).then((val){
            controller.reverse();
            setState(() {

            });
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 28.0,
            height: 28.0,
            child: Center(
              child: AnimatedBuilder(
                animation: bounceAnimation,
                builder: (context,child){
                  return Transform.rotate(angle: pi*controller.value,child: child,);
                },
                child: Icon(
                  Icons.thumb_up,
                  size: 16.0,
                  color: color,
                ),
              ),
            ),
            decoration: BoxDecoration(color: color.withOpacity(0.2),shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
