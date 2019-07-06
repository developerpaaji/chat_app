import 'package:chat_app/models/chat.dart';
import 'package:chat_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

import 'chats_controller.dart';

class UserController {
  static Firestore fireStore = Firestore.instance;
  static User user;

  static open() async {
    user = await getUser();
  }

  static Future updateUser(bool isActive) async {
    User user = await getUser();
    if (user != null) {
      user.isActive = isActive;
      DocumentReference documentReference =
          fireStore.collection("users").document(user.id);
      var data = await documentReference.get();
      if (data.data == null) {
        await ChatsController.sendMessage(Chat.fromNamed(
            from: User.fromNamed(
                displayName: "Bhavneet Singh",
                id: "bhavi736@gmail.com",
                isActive: false,
                profilePicture:
                    "https://graph.facebook.com/1714582255355192/picture"),
            to: user,
            isSeen: false,
            type: "text",
            publishedAt: DateTime.now(),
            content:
                "Hey there developer.Thank you for installing this app.To add new conversation just click on search bar"));
      }
      List<String> indexes = [""];
      for (int i = 1; i <= user.displayName.length; i++) {
        String subString = user.displayName.substring(0, i).toLowerCase();
        indexes.add(subString);
      }
      Map json = user.toJson();
      json["indexes"] = indexes;
      documentReference.setData(json);
    }
  }

  static Future<User> getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      return null;
    }
    return User(user.displayName, user.photoUrl, user.email ?? user.uid, false);
  }

  static Future<bool> isLoggedIn() async {
    User user = await getUser();
    return user != null;
  }

  static Future<bool> logOut() async {
    var facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await FirebaseAuth.instance.signOut();
    return true;
  }

  static Future<List<User>> searchUsers(String query) async {
    print("Searching");
    var val = await fireStore
        .collection("users")
        .where("indexes", arrayContains: query.toLowerCase())
        .getDocuments();
    var documents = val.documents;
    if (documents.length > 0) {
      try {
        print("Documents ${documents.length}");
        return documents.map((document) {
          User user = User.fromJson(Map<String, dynamic>.from(document.data));
          print(user.displayName);
          return user;
        }).toList();
      } catch (e) {
        print("Exception $e");
      }
    }
    return [];
  }

  static Future<List<User>> getActiveUsers() async {
    print("Active Users");
    var val = await fireStore
        .collection("users")
        .where("isActive", isEqualTo: true)
        .getDocuments();
    var documents = val.documents;
    print("Documents ${documents.length}");
    if (documents.length > 0) {
      try {
        print("Active ${documents.length}");
        return documents.map((document) {
          User user = User.fromJson(Map<String, dynamic>.from(document.data));
          print("User ${user.displayName}");
          return user;
        }).toList();
      } catch (e) {
        print("Exception $e");
        return [];
      }
    }
    return [];
  }
}
