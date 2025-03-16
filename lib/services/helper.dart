
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Helper{

static  List<int> yuv420ToRgb(CameraImage img) {
    List<int> rgbImage = [];
    for (var plane in img.planes) {
      rgbImage.addAll(plane.bytes);
    }
    return rgbImage;
  }

static  Future<List<List<int>> > runModelOnFrame(CameraImage img,Interpreter interpreter) async {
    int imageHeight = img.height;
    int imageWidth = img.width;

    List<int> imageBytes = yuv420ToRgb(img);

    Float32List input = Float32List.fromList(imageBytes.map((e) => e / 255.0).toList());

    var output = List.generate(1, (index) => List.filled(2, 0));

    interpreter.run(input, output);
  return output;
    //print('Model Output: $output');
  }


  static  Future<Interpreter> loadModel() async {
    return await Interpreter.fromAsset('assets/posenet_mv1_075_float_from_checkpoints.tflite');
  }


}