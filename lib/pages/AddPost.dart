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
      'author': int.parse(_priceController.text),
      'desc': _descController.text,
      'createdAt': FieldValue.serverTimestamp(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'photoURL': photoURL,
      'like': [],
      'category': '',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
