import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

List<String> categoryList = <String>['자유', '운동', '인증'];
List<String> sportsList = <String>['total', 'squat', 'dead', 'bench'];

class _AddPostState extends State<AddPost> {
  final ImagePicker _picker = ImagePicker();
  late XFile? video;
  late XFile? image;
  String imagePath = '';
  String photoURL = '';
  String fileName = '';
  bool isVideo = false;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _squatController = TextEditingController();
  final _deadController = TextEditingController();
  final _benchController = TextEditingController();
  final storageRef = FirebaseStorage.instance.ref();
  File file = File('');
  String categoryVal = categoryList.first;
  String sportVal = sportsList.first;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

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

  Future<DocumentReference> addPhotoAndInfo() async {
    await uploadFile();

    return await FirebaseFirestore.instance
        .collection('community')
        .add(<String, dynamic>{
      'title': _titleController.text,
      'author': FirebaseAuth.instance.currentUser!.displayName,
      'desc': _descController.text,
      'createdAt': FieldValue.serverTimestamp(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'photoURL': imagePath != '' ? photoURL : '',
      'like': [],
      'likeSize': 0,
      'dislike': [],
      'category': categoryVal,
      'isVideo': isVideo,
      'squat': int.parse(_squatController.text),
      'dead': int.parse(_deadController.text),
      'bench': int.parse(_benchController.text),
      'sports': sportVal,
    });
  }

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.file(File(imagePath));

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              imagePath == ''
                  ? const Text('선택된 사진 없음')
                  : isVideo != true
                      ? Image.file(File(imagePath))
                      : Column(
                          children: [
                            FutureBuilder(
                              future: _initializeVideoPlayerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  // If the VideoPlayerController has finished initialization, use
                                  // the data it provides to limit the aspect ratio of the video.
                                  return AspectRatio(
                                      aspectRatio:
                                          _controller.value.aspectRatio,
                                      // Use the VideoPlayer widget to display the video.
                                      child: VideoPlayer(_controller));
                                } else {
                                  // If the VideoPlayerController is still initializing, show a
                                  // loading spinner.
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
                        ),
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
              DropdownButton(
                  value: categoryVal,
                  items: categoryList
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    categoryVal = value!;
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
                              MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('취소')),
                  ElevatedButton(
                      onPressed: () async {
                        await addPhotoAndInfo();
                        Navigator.pop(context);
                      },
                      child: const Text('완료')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
