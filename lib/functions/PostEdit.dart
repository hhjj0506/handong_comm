import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:handong_comm/pages/PostDetailPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class PostEdit extends StatefulWidget {
  const PostEdit({super.key, required this.args});

  final PostArgs args;

  @override
  State<PostEdit> createState() => _PostEditState();
}

List<String> categoryList = <String>['자유', '운동', '인증'];

class _PostEditState extends State<PostEdit> {
  final ImagePicker _picker = ImagePicker();
  late XFile? image;
  String imagePath = '';
  String prevPhoto = '';
  String photoURL = '';
  String fileName = '';
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _squatController = TextEditingController();
  final _deadController = TextEditingController();
  final _benchController = TextEditingController();
  final storageRef = FirebaseStorage.instance.ref();
  File file = File('');
  String categoryVal = '';
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  late XFile? video;
  bool isVideo = false;

  Future getImageFromGallery() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = image!.path;
      isVideo = false;
    });
  }

  Future getVideoFromGallery() async {
    video = await _picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      imagePath = video!.path;
      isVideo = true;
      _controller = VideoPlayerController.file(File(imagePath));
      _initializeVideoPlayerFuture = _controller.initialize();
    });
  }

  Future uploadFile() async {
    if (imagePath != '') {
      file = File(imagePath);
      fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final upload = storageRef.child('images/$fileName').putFile(file);
      await upload.whenComplete(() async {
        print('image uploaded');
      }).catchError((onError) {
        print(onError);
      });
      photoURL = await upload.snapshot.ref.getDownloadURL();
      print(photoURL);
    }
  }

  Future updatePost(String id) async {
    await uploadFile();

    return await FirebaseFirestore.instance
        .collection('community')
        .doc(id)
        .update(<String, dynamic>{
      'title': _titleController.text,
      'desc': _descController.text,
      'photoURL': imagePath != '' ? photoURL : prevPhoto,
      'squat': int.parse(_squatController.text),
      'dead': int.parse(_deadController.text),
      'bench': int.parse(_benchController.text),
      'category': categoryVal,
      'isVideo': isVideo,
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(imagePath));
    _initializeVideoPlayerFuture = _controller.initialize();
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    prevPhoto = widget.args.photoURL;
    _titleController.text = widget.args.title;
    _descController.text = widget.args.desc;
    _deadController.text = widget.args.dead.toString();
    _benchController.text = widget.args.bench.toString();
    _squatController.text = widget.args.squat.toString();
    categoryVal = widget.args.category;
    isVideo = widget.args.isVideo;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              imagePath == ''
                  ? prevPhoto != ''
                      ? isVideo != true
                          ? Image.network(widget.args.photoURL)
                          : Column(
                              children: [
                                FutureBuilder(
                                  future: _initializeVideoPlayerFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return AspectRatio(
                                          aspectRatio:
                                              _controller.value.aspectRatio,
                                          child: VideoPlayer(_controller));
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Wrap the play or pause in a call to `setState`. This ensures the
                                    // correct icon is shown.
                                    setState(() {
                                      // If the video is playing, pause it.
                                      if (_controller.value.isPlaying) {
                                        _controller.pause();
                                      } else {
                                        // If the video is paused, play it.
                                        _controller.play();
                                      }
                                    });
                                  },
                                  // Display the correct icon depending on the state of the player.
                                  child: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                  ),
                                ),
                              ],
                            )
                      : const Text('선택된 사진이 없습니다.')
                  : Image.file(File(imagePath)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        getImageFromGallery();
                      },
                      icon: const Icon(Icons.photo_camera)),
                  IconButton(
                      onPressed: () {
                        getVideoFromGallery();
                      },
                      icon: const Icon(Icons.video_call)),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),
              const Text('Category'),
              StatefulBuilder(builder: (context, setState) {
                return Column(
                  children: [
                    DropdownButton(
                        value: categoryVal,
                        items: categoryList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            categoryVal = value!;
                          });
                        }),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: '제목',
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: _descController,
                      decoration: const InputDecoration(
                        labelText: '내용',
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      readOnly: categoryVal == '인증' ? false : true,
                      controller: _squatController,
                      decoration: const InputDecoration(
                        labelText: '스쿼트 무게',
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      readOnly: categoryVal == '인증' ? false : true,
                      controller: _deadController,
                      decoration: const InputDecoration(
                        labelText: '데드리프트 무게',
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      readOnly: categoryVal == '인증' ? false : true,
                      controller: _benchController,
                      decoration: const InputDecoration(
                        labelText: '벤치프레스 무게',
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red)),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('취소')),
                        ElevatedButton(
                            onPressed: () async {
                              await updatePost(widget.args.id);
                              Navigator.pop(context);
                            },
                            child: const Text('완료')),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
