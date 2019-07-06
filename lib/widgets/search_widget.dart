import 'package:flutter/material.dart';

class SearchWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.of(context).pushNamed('/search');
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Color(0xffeeeeee),borderRadius: BorderRadius.circular(25.0)),
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.search,size: 22.0,color: Colors.blueGrey),
            ),
            Padding(
              padding: const EdgeInsets.only(left:4.0),
              child: Text("Search",style: TextStyle(fontSize: 16.0,color: Colors.blueGrey,fontWeight: FontWeight.w500),),
            )
          ],
        ),
      ),
    );
  }

}