import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/pages/PostDetailPage.dart';

class AddComment extends StatefulWidget {
  const AddComment({super.key, required this.args});

  final CommentArgs args;

  @override
  State<AddComment> createState() => _AddCommentState();
}

class _AddCommentState extends State<AddComment> {
  final _descController = TextEditingController();

  Future<DocumentReference> addComment(String id) async {
    return await FirebaseFirestore.instance
        .collection('community')
        .doc(id)
        .collection('comment')
        .add(<String, dynamic>{
      'author': FirebaseAuth.instance.currentUser!.displayName,
      'desc': _descController.text,
      'createdAt': FieldValue.serverTimestamp(),
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'like': [],
      'dislike': [],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            '댓글 작성',
            style: TextStyle(fontSize: 21),
          ),
          TextField(
            controller: _descController,
            decoration: const InputDecoration(
              labelText: '댓글',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red)),
                child: const Text('취소'),
              ),
              ElevatedButton(
                  onPressed: () async {
                    await addComment(widget.args.id);
                    Navigator.pop(context);
                  },
                  child: const Text('완료'))
            ],
          )
        ]),
      ),
    );
  }
}
