import 'package:chat_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

class DiscoverScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Feature is not available yet",
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(top:8.0),
              child: Text(
                "Contribute to app github repository",
                style: TextStyle(fontSize: 16.0,),
              ),
            ),
            RoundedButton("Contribute",onTap: (){},nextIcon: true,)
          ],
        ),
      ),
    );
  }
}
