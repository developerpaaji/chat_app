
import 'package:meta/meta.dart';

import 'basic.dart';

class ImageData extends Basic{
  final String imagePath;

  ImageData({@required this.imagePath}) : super(DateTime.now().toString());
}