import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  User? user = FirebaseAuth.instance.currentUser;
  final _descController = TextEditingController();

  Future updateLike(String id) async {
    return await FirebaseFirestore.instance
        .collection('community')
        .doc(id)
        .update(<String, dynamic>{
      'like': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      'likeSize': FieldValue.increment(1),
    });
  }

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
    const contains = SnackBar(
      content: Text('이미 추천하셨습니다.'),
    );
    const firstClick = SnackBar(
      content: Text('이 글을 추천하셨습니다.'),
    );
    final Stream<DocumentSnapshot> stream = FirebaseFirestore.instance
        .collection('community')
        .doc(widget.args.id)
        .snapshots();
    final Stream<QuerySnapshot> commStream = FirebaseFirestore.instance
        .collection('community')
        .doc(widget.args.id)
        .collection('comment')
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

          return snapshot.data!.exists
              ? StreamBuilder(
                  stream: commStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> commSnapshot) {
                    if (commSnapshot.hasError) {
                      return const Text('Error!');
                    }

                    if (commSnapshot.connectionState ==
                        ConnectionState.waiting) {
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
                              user!.uid == snapshot.data!['uid']
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                              Icons.mode_edit_outline)))
                                  : const Text(''),
                              user!.uid == snapshot.data!['uid']
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            FirebaseFirestore.instance
                                                .collection('community')
                                                .doc(widget.args.id)
                                                .delete();
                                          },
                                          icon: const Icon(Icons.delete)))
                                  : const Text(''),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(snapshot.data!['author'] +
                              ' | ' +
                              DateFormat.yMMMd()
                                  .format((snapshot.data!['createdAt'] ??
                                          '' as Timestamp)
                                      .toDate())
                                  .toString()),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(
                            height: 2,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          snapshot.data!['photoURL'] != ""
                              ? Image.network(snapshot.data!['photoURL'])
                              : const Text(''),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(snapshot.data!['desc']),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    if (snapshot.data!['like'].contains(
                                        FirebaseAuth
                                            .instance.currentUser!.uid)) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(contains);
                                    } else {
                                      updateLike(widget.args.id);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(firstClick);
                                    }
                                  },
                                  icon: const Icon(Icons.thumb_up)),
                              Text('${snapshot.data?['like'].length ?? ''}'),
                            ],
                          ),
                          const Divider(
                            height: 2,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            '댓글',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          TextField(
                            controller: _descController,
                            decoration: const InputDecoration(
                              labelText: '댓글',
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                await addComment(widget.args.id);
                              },
                              child: const Text('완료')),
                          ListView(
                            shrinkWrap: true,
                            children: commSnapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data()! as Map<String, dynamic>;
                              return ListTile(
                                leading: Text(data['author']),
                                title: Text(data['desc']),
                                subtitle: Text(
                                  DateFormat.yMMMd()
                                      .add_jm()
                                      .format(
                                          (data['createdAt'] ?? '' as Timestamp)
                                              .toDate())
                                      .toString(),
                                ),
                                trailing: user!.uid == data['uid']
                                    ? IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('community')
                                              .doc(widget.args.id)
                                              .collection('comment')
                                              .doc(document.id)
                                              .delete();
                                        },
                                      )
                                    : const Text(''),
                              );
                            }).toList(),
                          ),
                        ],
                      ))),
                    );
                  },
                )
              : Scaffold(
                  appBar: AppBar(),
                );
        });
  }
}
