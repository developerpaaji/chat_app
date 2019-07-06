import 'package:chat_app/screens/camera_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/search_screen.dart';
import 'package:chat_app/screens/splash_screen.dart';
import 'package:chat_app/screens/main_screen.dart';
import 'package:flutter/material.dart';

import 'models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
              brightness: Brightness.light,
              color: Colors.white,
              elevation: 0.0,
              iconTheme: IconThemeData(color: Colors.black),
              actionsIconTheme: IconThemeData(color: Colors.black)),
          fontFamily: "Ubuntu",
          primarySwatch: Colors.blue,
          primaryColor: Color(0xff0084FF)),
      home: SplashScreen(),
      routes: {
        '/main': (context) => MainScreen(),
        '/camera': (context) => CameraScreen(),
        '/search':(context)=>SearchScreen(),
        '/chat': (context) => ChatScreen(
              friend: User(
                  "Bhavneet Singh",
                  "https://avatars0.githubusercontent.com/u/31070108?s=460&v=4",
                  "singhbhavneet",
                  false),
            )
      },
    );
  }
}
