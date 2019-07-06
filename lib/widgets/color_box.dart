import 'package:flutter/material.dart';

import 'ease_in_widget.dart';

class ColorBox extends StatefulWidget {
  final double size;
  final Color color;
  final bool smallBorder;
  final Function onTap;
  const ColorBox({Key key, this.size=32.0,@required this.color, this.onTap, this.smallBorder=true}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ColorBoxState();
}

class _ColorBoxState extends State<ColorBox> {
  final double smallBorder=3.0,bigBorder=4.5;
  double border=3.0;
  @override
  void initState() {
    super.initState();
    border=widget.smallBorder?smallBorder:bigBorder;
  }
  @override
  Widget build(BuildContext context) {
    border=widget.smallBorder?smallBorder:bigBorder;
    return EaseInWidget(
      onTap: (){
        widget.onTap();
        setState(() {
          border=4.5;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(border: Border.all(color: Colors.white,width: border),shape: BoxShape.circle),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(color: widget.color,shape: BoxShape.circle),
        ),
      ),
    );
  }
}
