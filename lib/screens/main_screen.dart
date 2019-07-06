import 'dart:io';

import 'package:chat_app/controllers/user_controller.dart';
import 'package:chat_app/screens/people_screen.dart';
import 'package:chat_app/widgets/ease_in_widget.dart';
import 'package:chat_app/widgets/profile_picture_widget.dart';
import 'package:chat_app/widgets/search_widget.dart';
import 'package:flutter/material.dart';

import 'chats_screen.dart';
import 'discover_screen.dart';

class MainScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  ScrollController controller;
  double elevation = 0.0;
  List<Widget>screens=[];
  List<String>titles=[
    "Chats","People","Discover"
  ];
  @override
  void initState() {
    super.initState();
    UserController.open();
    screens.add(ChatsScreen());
    screens.add(PeopleScreen());
    screens.add(DiscoverScreen());
    controller = ScrollController();
    controller.addListener(() {
      if (controller.offset > 0.0) {
        setState(() {
          elevation = 2.5;
        });
      } else {
        setState(() {
          elevation = 0.0;
        });
      }
    });
  }
  int current=0;
  @override
  Widget build(BuildContext context) {
    print("$current");
    return WillPopScope(
      onWillPop: (){
        showDialog(context: context,builder: (context)=>AlertDialog(
          title: Text("Do you want to logout"),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).popUntil(ModalRoute.withName('/main'));
            }, child: Text("Cancel")),
            FlatButton(onPressed: (){
              exit(0);
            }, child: Text("Ok"))
          ],
        ));
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Scaffold(
            appBar: AppBar(
              elevation: elevation,
              textTheme: TextTheme(
                  title: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black)),
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: (){
                        showModalBottomSheet(context: context,builder: (context)=>ListTile(
                          leading:Icon(Icons.input),
                          title: Text("Logout"),
                          trailing: Icon(Icons.chevron_right),
                          onTap: ()async{
                            await UserController.logOut();
                            Navigator.of(context).pop();
                            Navigator.of(context).popAndPushNamed('/');
                          },
                        ));
                      },
                      child: ProfilePictureWidget(
                        size: 40.0,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Text(titles[current]),
                  ),
                ],
              ),
              actions: <Widget>[
                EaseInWidget(
                  onTap: (){
                    Navigator.of(context).pushNamed('/camera');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffeeeeee),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.camera_alt,
                      size: 20.0,
                    ),
                  ),
                ),
                Container(
                  width: 16.0,
                ),
                EaseInWidget(
                  onTap: (){
                    Navigator.of(context).pushNamed('/search');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffeeeeee),
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.edit,
                      size: 20.0,
                    ),
                  ),
                ),
                Container(
                  width: 18.0,
                ),
              ],
              bottom: PreferredSize(
                  child: Container(
                    height: 5.0,
                  ),
                  preferredSize: Size(MediaQuery.of(context).size.width, 5.0)),
            ),
            body: SingleChildScrollView(
              controller: controller,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SearchWidget(),
                  screens[current]
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: BottomNavigationBar(
              elevation: 0.0,
              iconSize: 30.0,
              showUnselectedLabels: false,
              showSelectedLabels: false,
              unselectedItemColor: Colors.black54,
              backgroundColor: Colors.white,
              selectedItemColor: Colors.black,
              currentIndex: current,
              onTap: (index){
                setState(() {
                  current=index;
                });
              },
              items: [
                Option(title: "Chats",iconData: Icons.message),
                Option(title: "People",iconData: Icons.group),
                Option(title: "Explore",iconData: Icons.explore),
              ].map((item)=>BottomNavigationBarItem(icon: Icon(item.iconData),title: Text(item.title))).toList(),
            ),
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    super.dispose();
    UserController.updateUser(false);
  }
}

class Option{
  final String title;
  final IconData iconData;

  Option({this.title, this.iconData});
}