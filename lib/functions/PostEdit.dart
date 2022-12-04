import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:handong_comm/pages/PostDetailPage.dart';
import 'package:image_picker/image_picker.dart';

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
  final storageRef = FirebaseStorage.instance.ref();
  File file = File('');
  String categoryVal = '';

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

  Future updatePost(String id) async {
    await uploadFile();

    return await FirebaseFirestore.instance
        .collection('community')
        .doc(id)
        .update(<String, dynamic>{
      'title': _titleController.text,
      'desc': _descController.text,
      'photoURL': imagePath != '' ? photoURL : prevPhoto,
      'category': categoryVal,
    });
  }

  @override
  Widget build(BuildContext context) {
    prevPhoto = widget.args.photoURL;
    _titleController.text = widget.args.title;
    _descController.text = widget.args.desc;
    categoryVal = widget.args.category;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              imagePath == ''
                  ? prevPhoto != ''
                      ? Image.network(widget.args.photoURL)
                      : const Text('선택된 사진이 없습니다.')
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
                        await updatePost(widget.args.id);
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
