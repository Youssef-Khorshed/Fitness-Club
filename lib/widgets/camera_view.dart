
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';


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
    _controller.stopImageStream();
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
