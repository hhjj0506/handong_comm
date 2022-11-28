import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

List<String> categoryList = <String>['자유', '운동', '인증'];

class _AddPostState extends State<AddPost> {
  final ImagePicker _picker = ImagePicker();
  late XFile? image;
  String imagePath = '';
  String photoURL = '';
  String fileName = '';
  final _titleController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  final storageRef = FirebaseStorage.instance.ref();
  File file = File('');
  String categoryVal = categoryList.first;

  Future getImageFromGallery() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = image!.path;
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
    });
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
                  : Image.file(File(imagePath)),
              IconButton(
                  onPressed: () {
                    getImageFromGallery();
                  },
                  icon: const Icon(Icons.photo_camera)),
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
