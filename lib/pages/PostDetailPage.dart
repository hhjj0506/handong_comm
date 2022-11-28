import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/pages/CommunityPage.dart';
import 'package:intl/intl.dart';

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
                child: SafeArea(
                    child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios)),
                    Text(
                      snapshot.data!['title'],
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(snapshot.data!['author'] +
                    ' | ' +
                    DateFormat.yMMMd()
                        .format((snapshot.data!['createdAt'] ?? '' as Timestamp)
                            .toDate())
                        .toString()),
                const SizedBox(
                  height: 10,
                ),
                Image.network(snapshot.data!['photoURL']),
                const SizedBox(
                  height: 10,
                ),
                Text(snapshot.data!['desc']),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  '댓글',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ))),
          );
        });
  }
}
