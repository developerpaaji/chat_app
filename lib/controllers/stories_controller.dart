import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/models/story.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/story.dart';
import '../models/story.dart';
import '../models/story.dart';
import '../models/story.dart';

class StoriesController {
  static Future<bool> storeImage(Uint8List data) async {
    try {
      StorageReference reference =
          FirebaseStorage.instance.ref().child(DateTime.now().toString());
      StorageUploadTask uploadTask = reference.putData(data);
      StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      String imagePath = snapshot.storageMetadata.path;
      await createStory(imagePath);
      return snapshot.error == 0;
    } catch (e) {
      return false;
    }
  }

  static const String STORIES = "stories";
  static const String BASE_URl =
      "https://firebasestorage.googleapis.com/v0/b/chat-9b859.appspot.com/o/";
  static Firestore firestore = Firestore.instance;

  static Future<bool> createStory(String path) async {
    try {
      String imagePath = "$BASE_URl$path?alt=media";
      FirebaseUser authUser = await FirebaseAuth.instance.currentUser();
      List<String> names = authUser.displayName.split(" ");
      User user =
          User(authUser.displayName, authUser.photoUrl, authUser.email, false);
      Story story = Story(
        filterVal(user.id),
        user,
        false,
        [DataType(imagePath, DataType.IMAGE)],
        DateTime.now(),
      );
      CollectionReference reference =
          firestore.collection(filterVal(STORIES)).reference();
      DocumentSnapshot documentSnapshot =
          await reference.document(filterVal(user.id)).get();
      if (documentSnapshot.data == null) {
        reference.document(filterVal(user.id)).setData(story.toJson());
      } else {
        DocumentReference docReference = reference.document(filterVal(user.id));
        log(
          "Dat ${filterVal(user.id)}a",
        );
        log("Data ${Story.fromJson(documentSnapshot.data).toJson()}");
        List<DataType> data = Story.fromJson(documentSnapshot.data).data;
        log("Data ${data.length}");
        data.add(DataType(imagePath, DataType.IMAGE));
        await docReference.updateData({
          "data": data.map((val) => val.toJson()).toList(),
          "isSeen": false
        });
      }

      return true;
    } catch (e) {
      log(e, error: e);
      return false;
    }
  }

  static String filterVal(String val) {
    List<String> inCorrects = [":", "#", "\$", "[", "]", "."];
    String filtered = val;
    inCorrects.forEach((val) {
      filtered = filtered.replaceAll(val, "");
    });
    return filtered;
  }

  static Stream<List<Story>> getStories() async* {
    await for (QuerySnapshot snap
        in firestore.collection(STORIES).snapshots()) {
      List<Story> result = [];
      snap.documents.forEach((snap) async {
        try {
          Story story = Story.fromJson(Map<String, dynamic>.from(snap.data));
          result.add(story);
        } catch (e) {
          print("Baby $e");
        }
      });
      yield result;
    }
  }

  static Future<bool> updateStory(Story story, bool isSeen) async {
    try {
      firestore
          .collection(STORIES)
          .document(story.id)
          .updateData({"isSeen": isSeen});
      return true;
    } catch (e) {
      return false;
    }
  }

  static List<Story> filterStories(List<Story> stories) {
    Map<String, List<Story>> newStories = {};
    List<Story> result = [];
    stories.forEach((story) {
      if (!newStories.containsKey(story.user.id)) {
        newStories.putIfAbsent(story.user.id, () => []);
      }
      newStories[story.user.id].add(story);
    });
    newStories.forEach((val, list) {
      if (list.length == 0) {
        return;
      }
      User user = list[0].user;
      Story story = Story("", user, false, [], DateTime.now());
      stories.forEach((temp) {
        story.data.addAll(temp.data);
      });
      result.add(story);
    });
    return result;
  }
}
