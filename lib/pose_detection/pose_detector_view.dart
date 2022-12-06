import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import 'package:handong_comm/pose_detection/pose_painter.dart';

import 'camera_view.dart';

class PoseDetectorView extends StatefulWidget {
  const PoseDetectorView({super.key});

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  final PoseDetector _poseDetector =
      PoseDetector(options: PoseDetectorOptions());
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void dispose() async {
    _canProcess = false;
    _poseDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Pose Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage, width, height) {
        processImage(inputImage, width, height);
      },
    );
  }

  Future<void> processImage(
      InputImage inputImage, double width, double height) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final poses = await _poseDetector.processImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter(poses, inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      _text = 'Poses found: ${poses.length}\n\n';
      final painter = PosePainter(
          poses, Size(width, height), InputImageRotation.rotation0deg);
      _customPaint = CustomPaint(painter: painter);
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
