import 'dart:io';

import 'package:meta/meta.dart';

enum CameraFileType{
  Image,
  Video
}

class CameraFile{
  final CameraFileType type;
  final File file;

  CameraFile({@required this.type,@required this.file });
}