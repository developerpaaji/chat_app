import 'package:chat_app/controllers/chats_controller.dart';
import 'package:chat_app/controllers/user_controller.dart';
import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/widgets/chat_input_widget.dart';
import 'package:chat_app/widgets/chat_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/services.dart';

class ChatScreen extends StatefulWidget {
  final User friend;

  ChatScreen({
    Key key,
    @required this.friend,
  }) : super(key: key);

  @override
  State createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ScrollController scrollController = ScrollController();
  final GlobalKey _key = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Chat> chats = [];
  User currentUser;
  bool isHeader = true;

  @override
  void initState() {
    super.initState();
    initUser();
    WidgetsBinding.instance.addPostFrameCallback((val) {
     scrollController.addListener((){
       final RenderBox renderBox=_key.currentContext.findRenderObject();
       final size=renderBox.size;
       double height=size.height*2/3;
       if (scrollController.hasClients)
//        scrollController.animateTo(scrollController.position.maxScrollExtent,
//            duration: Duration(milliseconds: 100), curve: Curves.easeIn);

       if (scrollController.offset >= height ) {
         if (mounted) {
           setState(() {
             isHeader = false;
           });
         }
       } else if (!isHeader) {
         if (mounted) {
           setState(() {
             isHeader = true;
           });
         }
       }
     });

    });
  }

  void initUser() async {
    currentUser = await UserController.getUser();
    if (mounted) {
      setState(() => 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 1.0,
        automaticallyImplyLeading: false,
//        leading:
// IconButton(
//          icon: Icon(Icons.arrow_back),
//          onPressed: () {
//            Navigator.of(context).pop();
//          },
//          color: Theme.of(context).primaryColor,
//        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Theme.of(context).primaryColor,
            ),
            isHeader?Container(width: 0.0,):Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    widget.friend.profilePicture,
                  ),
                  radius: 14.0,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.00),
                  child: Text(
                    widget.friend.displayName,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.normal),
                  ),
                )
              ],
            )
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () {},
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            icon: Icon(Icons.videocam),
            onPressed: () {},
            color: Theme.of(context).primaryColor,
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Info"),
                    value: "Info",
                  )
                ],
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
      body: currentUser == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                Flexible(child: buildChats()),
                ChatInputWidget(
                  onSubmitted: (val) {
                    if(currentUser.id==widget.friend.id){
                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("You can not send message to you")));
                      return;
                    }
                    Chat chat = Chat.fromNamed(
                        from: currentUser,
                        to: widget.friend,
                        content: val,
                        isSeen: false,
                        publishedAt: DateTime.now());
                    ChatsController.sendMessage(chat);
                    scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn);
                    setState(() {
                      chats.add(chat);
                    });
                  },
                )
              ],
            ),
    );
  }

  Widget buildHeader() {
    return Container(
      key: _key,
      padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(125.0),
            child: Image.network(
              widget.friend.profilePicture,
              height: 125.0,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              widget.friend.displayName,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              "${widget.friend.id}",
              style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildChats() {
    return StreamBuilder(
        stream: ChatsController.listenChat(currentUser, widget.friend),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          List<Chat> chats = snapshot.data;
          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              if (index == 0) {
                return buildHeader();
              }
              return ChatWidget(
                chat: chats[index - 1],
                isReceived: currentUser.id != chats[index - 1].from.id,
                showUser: (index == 1) ||
                    (index >= 2 &&
                        !(chats[index - 1].from.id ==
                            chats[index - 2].from.id)),
              );
            },
            itemCount: chats.length + 1,
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
