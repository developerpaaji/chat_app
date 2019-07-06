import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as Im;
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
import 'package:flutter_native_image/flutter_native_image.dart';

class ImageCompressor{

  static Future<Uint8List> compressImage(File file) async {
    try{
      File compressedFile = await FlutterNativeImage.compressImage(file.path,
          quality: 75, percentage: 50);
      print("Size ${compressedFile.statSync().size}");
      return compressedFile.readAsBytesSync();
    }
    catch(e){
      print("Excpetion $e");

      return null;
    }
  }
}