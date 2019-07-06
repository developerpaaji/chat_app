import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget
{
  final String data;
  final Function onTap;
  final bool nextIcon;
  const RoundedButton(this.data,{Key key,@required this.onTap, this.nextIcon=false,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 18.0),
              width: MediaQuery.of(context).size.width*5/6,
              decoration: BoxDecoration(color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(32.0),shape: BoxShape.rectangle,boxShadow: [BoxShadow(color: Colors.pinkAccent.withOpacity(0.2),blurRadius: 25.0,spreadRadius: 0.2,offset: Offset(0.00, 1.0))]),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(data,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18.0),),
                  Padding(
                    padding: const EdgeInsets.only(left:8.0),
                    child: nextIcon?Icon(Icons.arrow_forward,color: Colors.white,):Container(width: 0.0,height: 0.0,),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
}