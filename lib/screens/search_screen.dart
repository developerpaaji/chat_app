import 'package:chat_app/controllers/user_controller.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/user_widget.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        actionsIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        title: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
              border: InputBorder.none, hintText: "Search here"),
          style: TextStyle(fontSize: 18.0),
          onSubmitted: (query) {
            UserController.searchUsers(query);
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(isTyping ? Icons.clear : Icons.mic),
              onPressed: () {
                if (isTyping) {
                  controller.text = '';
                }
              })
        ],
      ),
      body: FutureBuilder(
          future: UserController.searchUsers(controller.text),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            List<User> users = snapshot.data;
            print("Resi;t ${users.length}");
            return ListView.builder(
              itemBuilder: (context, index) => ListTile(
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatScreen(friend: users[index],)));
                },
                leading: UserWidget(
                  size: 18.0,
                  user: users[index],
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
                title: Text(users[index].displayName,style: TextStyle(fontWeight: FontWeight.w700),),
              ),
              itemCount: users.length,
              shrinkWrap: true,
            );
          }),
    );
  }

  bool get isTyping => controller.text.length != 0;
}
