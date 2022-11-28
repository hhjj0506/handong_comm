import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:handong_comm/pages/CommunityPage.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, required this.args});

  final DetailArgs args;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> stream = FirebaseFirestore.instance
        .collection('community')
        .doc(widget.args.id)
        .snapshots();

    return StreamBuilder(
        stream: stream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Error!');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return Scaffold(
            body: SingleChildScrollView(
                child: Column(
              children: [Image.network(snapshot.data!['photoURL'])],
            )),
          );
        });
  }
}
