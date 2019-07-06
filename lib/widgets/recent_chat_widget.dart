import 'package:chat_app/controllers/user_controller.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/user_widget.dart';
import 'package:flutter/material.dart';

class RecentChatWidget extends StatefulWidget {
  final Chat chat;

  const RecentChatWidget({Key key, this.chat}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecentChatWidgetState();

}

class _RecentChatWidgetState extends State<RecentChatWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ChatScreen(friend: friend,)));
      },
      leading: UserWidget(user: friend,),
      title: Text(friend.displayName,style: TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text(widget.chat.content,maxLines: 1,overflow: TextOverflow.ellipsis,),
    );
  }

  User get friend=>widget.chat.from.id==UserController.user.id?widget.chat.to:widget.chat.from;
}