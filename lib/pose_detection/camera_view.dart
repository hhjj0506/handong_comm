import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';

enum ScreenMode { liveFeed, gallery }

class CameraView extends StatefulWidget {
  const CameraView({
    Key? key,
    required this.title,
    required this.customPaint,
    this.text,
    required this.onImage,
    this.onScreenModeChanged,
  }) : super(key: key);

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage, double width, double height) onImage;
  final Function(ScreenMode mode)? onScreenModeChanged;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  File? _image;
  String? _path;
  ImagePicker? _imagePicker;
  double zoomLevel = 0.0, minZoomLevel = 0.0, maxZoomLevel = 0.0;

  @override
  void initState() {
    super.initState();

    _imagePicker = ImagePicker();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _galleryBody(),
    );
  }

  Widget _galleryBody() {
    return ListView(shrinkWrap: true, children: [
      _image != null
          ? const SizedBox(
              height: 100,
            )
          : const SizedBox(
              height: 150,
            ),
      Center(
        child: Column(children: const [
          SizedBox(
            height: 10,
          ),
          Text(
            '자세 인식',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '자신이 운동하고 있는 사진을 선택하면 자세를 보여줍니다.',
            style: TextStyle(fontSize: 16),
          ),
        ]),
      ),
      _image != null
          ? SizedBox(
              height: 400,
              width: 400,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.file(_image!),
                  if (widget.customPaint != null) widget.customPaint!,
                ],
              ),
            )
          : const Icon(
              Icons.image,
              size: 200,
            ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton(
          onPressed: () => _getImage(ImageSource.gallery),
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.grey[900]!)),
          child: const Text(
            '사진 선택',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ]);
  }

  Future _getImage(ImageSource source) async {
    setState(() {
      _image = null;
      _path = null;
    });
    final pickedFile = await _imagePicker?.pickImage(source: source);
    if (pickedFile != null) {
      _processPickedFile(pickedFile);
    }
    setState(() {});
  }

  Future _processPickedFile(XFile? pickedFile) async {
    final path = pickedFile?.path;
    late double height;
    late double width;
    if (path == null) {
      return;
    }
    setState(() {
      _image = File(path);
    });

    final size = ImageSizeGetter.getSize(FileInput(File(path)));

    if (size.needRotate) {
      width = size.height.toDouble();
      height = size.width.toDouble();
    } else {
      width = size.width.toDouble();
      height = size.height.toDouble();
    }

    _path = path;
    final inputImage = InputImage.fromFilePath(path);
    widget.onImage(inputImage, width, height);
  }
}
