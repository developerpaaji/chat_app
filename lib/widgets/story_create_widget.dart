import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:chat_app/controllers/image_compresser.dart';
import 'package:chat_app/controllers/stories_controller.dart';
import 'package:chat_app/models/basic.dart';
import 'package:chat_app/models/image_data.dart';
import 'package:chat_app/models/smiley_data.dart';
import 'package:chat_app/models/text_data.dart';
import 'package:chat_app/widgets/moving_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class StoryCreateWidget extends StatefulWidget {
  final List<Basic> children;
  final Offset deleteOffset;
  final Function(StoryCreateController) onCompleted;

  const StoryCreateWidget(
      {Key key,
      @required this.children,
      @required this.deleteOffset,
      @required this.onCompleted})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StoryCreateWidgetState();
}

class _StoryCreateWidgetState extends State<StoryCreateWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((val) {
      widget.onCompleted(StoryCreateController._(this));
    });
  }

  GlobalKey _globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    print("children story ${widget.children.length}");

    return RepaintBoundary(
      key: _globalKey,
      child: Container(
        color: Colors.white12,
        child: Stack(
          fit: StackFit.expand,
          children: children,
        ),
      ),
    );
  }

  List<Widget> get children {
    List<Widget> subs = [];
    widget.children.forEach((basic) {
      Widget subChild;
      if (basic is TextData) {
        subChild = createTextWidget(basic);
      } else if (basic is ImageData) {
        subChild = createImageWidget(basic);
      } else if (basic is SmileyData) {
        subChild = createSmileyWidget(basic);
      }
      if (basic is ImageData) {
        subs.add(subChild);
      } else {
        Widget child = MovingWidget(
          child: subChild,
          deleteOffset: widget.deleteOffset,
          onRemove: () {
            setState(() {
              widget.children.remove(basic);
            });
          },
        );
        subs.add(child);
      }
    });
    return subs;
  }

  Widget createTextWidget(TextData basic) {
    return Container(
      decoration: basic.decoration,
      padding: TextData.TEXT_PADDING,
      child: Text(
        basic.data,
        style: basic.textStyle,
      ),
    );
  }

  Widget createImageWidget(ImageData basic) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.file(
          File(
            basic.imagePath,
          ),
          fit: BoxFit.fill,
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 75.0,
            sigmaY: 75.0,
          ),
          child: new Container(
              decoration:
                  new BoxDecoration(color: Colors.white.withOpacity(0.5))),
        ),
        Image.file(
          File(
            basic.imagePath,
          ),
          fit: BoxFit.fitWidth,
        ),
      ],
    );
  }

  Widget createSmileyWidget(SmileyData basic) {
    return Image.asset(
      basic.smileyPath,
      height: 100.0,
      width: 100.0,
    );
  }

  Future<bool> capturePNG() async {
    try {
      print('inside');
      RenderRepaintBoundary boundary =
          (_globalKey.currentContext.findRenderObject());

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData.buffer.asUint8List();
      final directory = await getTemporaryDirectory();
      final String dirPath = '${directory.path}/Pictures';
      final String filePath = '$dirPath/${timestamp()}.png';
      print(filePath);
      File file = File(filePath);
      await file.writeAsBytes(pngBytes);
      await StoriesController.storeImage(file.readAsBytesSync());
      return true;
    } catch (e) {
      print("False");
      print(e);
      return false;
    }
  }

  Future<File> get _imgFile async {
    final directory = await getExternalStorageDirectory();
    final String dirPath = '${directory.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.png';
    File file = File(filePath);
    file.create(recursive: true);
    print("Path ${file.path}");
    return file;
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
}

class StoryCreateController {
  _StoryCreateWidgetState _state;

  StoryCreateController._(this._state);

  Future createStory() {
    return _state.capturePNG();
  }
}
