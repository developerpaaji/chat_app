import 'dart:io';
import 'package:chat_app/screens/story_create_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ThumbnailWidget extends StatefulWidget {
  final double size;
  final String imagePath;

  const ThumbnailWidget(
      {Key key,
      @required this.imagePath,
      this.size = 32.0})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _ThumbnailWidgetState();
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> {
  String thumb;
  @override
  void initState() {
    super.initState();

  }
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(image==null){
      return;
    }
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StoryCreateScreen(imagePath: image.path,)));
  }
  @override
  Widget build(BuildContext context) {
    thumb=widget.imagePath;
     return GestureDetector(
       onTap: getImage,
       child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.white, width: 1.5),
              borderRadius: BorderRadius.circular(8.0)),
          child: thumb != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.file(
                    File(thumb),
                    fit: BoxFit.cover,
                    width: 75.0,
                    height: 75.0,
                  ),
                )
              : null),
     );
  }
}
