import 'dart:math';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:model4/services/helper.dart';
import 'package:model4/services/render_data_arm_press.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

import '../services/render_data_yoga.dart';
import 'camera_view.dart';


class PoseDetectionScreenArm extends StatefulWidget {
  @override
  _PoseDetectionScreenArmState createState() => _PoseDetectionScreenArmState();
}

class _PoseDetectionScreenArmState extends State<PoseDetectionScreenArm> {
  late PoseDetector _poseDetector;
  bool isProcessing = false;
  List<dynamic>? _data;
  late Interpreter interpreter;
  int _imageHeight = 0;
  int _imageWidth = 0;
  int x = 1;

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  Future<void> _processImage(CameraImage image) async {
    if (isProcessing) return;
    isProcessing = true;
    final  interpreter =  await Helper.loadModel();
    try {
      final recognitions = await Helper.runModelOnFrame(image,interpreter);
      if (!mounted) {
        return;
      }
      setState(() {
        _data = recognitions;
        _imageHeight = image.height ;
        _imageWidth = image.width ;
      });

    } catch (e) {
      print('Error processing image: $e');
    } finally {
      isProcessing = false;
    }
  }



  @override
  void dispose() {
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("Arm Detection Movement")),
      body:
      Stack(
        children: <Widget>[
          CameraView(onImageAvailable: _processImage),
          RenderDataArmPress(
            data: _data == null ? [] : _data,
            previewH: max(_imageHeight, _imageWidth),
            previewW: min(_imageHeight, _imageWidth),
            screenH: screen.height,
            screenW: screen.width,
          ),

        ],
      ),


    );
  }
}