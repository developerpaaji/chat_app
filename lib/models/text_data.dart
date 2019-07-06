
import 'package:flutter/material.dart';

import 'basic.dart';

class TextData extends Basic{

  static const EdgeInsets TEXT_PADDING=const EdgeInsets.all(12.0);

  final String data;
  final BoxDecoration decoration;
  final TextStyle textStyle;

  TextData({@required this.data,@required this.decoration,@required this.textStyle}):super(DateTime.now().toString());

}