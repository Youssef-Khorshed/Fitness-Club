import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:tflite/tflite.dart';

class CameraView extends StatefulWidget {
  final Function(CameraImage)? onImageAvailable;

  const CameraView({Key? key, this.onImageAvailable}) : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    final cameraDescription = _cameras.first; // Use the first camera (back camera)
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
    );
    await _controller.initialize();

    if (widget.onImageAvailable != null) {
      _controller.startImageStream(widget.onImageAvailable!);
    }

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return CameraPreview(_controller);
  }
}
class PoseDetectionScreen extends StatefulWidget {
  @override
  _PoseDetectionScreenState createState() => _PoseDetectionScreenState();
}

class _PoseDetectionScreenState extends State<PoseDetectionScreen> {
  late PoseDetector _poseDetector;
  bool isProcessing = false;
  int _repCount = 0;

  @override
  void initState() {
    super.initState();
    _poseDetector = PoseDetector(options: PoseDetectorOptions());
  }

  Future<void> _processImage(CameraImage image) async {
    if (isProcessing) return;
    isProcessing = true;

    try {
      final recognitions = await runModelOnFrame(image);
      // Process recognitions (e.g., update UI or count reps)
      print(recognitions);
    } catch (e) {
      print('Error processing image: $e');
    } finally {
      isProcessing = false;
    }
  }

  Future<List<dynamic>> runModelOnFrame(CameraImage img) async {
    final recognitions = await Tflite.runModelOnFrame(
      bytesList: img.planes.map((plane) => plane.bytes).toList(),
      imageHeight: img.height,
      imageWidth: img.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 2,
      threshold: 0.1,
      asynch: true,
    );

    // Return an empty list if recognitions is null
    return recognitions ?? [];
  }

  @override
  void dispose() {
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pose Detection Reps: $_repCount")),
      body: CameraView(onImageAvailable: _processImage),
    );
  }
}