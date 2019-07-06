import 'package:flutter/material.dart';

import 'ease_in_widget.dart';

class AddStoryButton extends StatelessWidget {
  final double size;
  final bool rounded;
  const AddStoryButton({Key key, this.size=32.0, this.rounded=true}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return EaseInWidget(onTap: (){
      Navigator.of(context).pushNamed('/camera');
    },child: rounded?_buildRounded():_buildRectangleButton());
  }
  Widget _buildRectangleButton(){
    double width=100.0;
    return Container(
      decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(4.0)),
      margin: EdgeInsets.only(left: 12.0),
      child: Stack(
        children: <Widget>[
          Container(
            width: width,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(Icons.add_circle,color: Colors.black,),
                Expanded(
                  child: Container(
                    width: width,

                    alignment: Alignment.bottomLeft,
                    child: Text('Add to your story',maxLines: 2,style: TextStyle(color: Colors.black,fontSize: 12.0),),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget _buildRounded(){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Color(0xffeeeeee),shape: BoxShape.circle),
          child: Icon(Icons.add,color: Colors.black,size:size*2.5/4,),
        ),
        Padding(
          padding: const EdgeInsets.only(top:6.0),
          child: Text("Add Story",style: TextStyle(color: Colors.black38,fontSize: 12.0),),
        ),
      ],
    );
  }
}