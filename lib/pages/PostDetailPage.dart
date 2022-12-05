import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/functions/PostEdit.dart';
import 'package:handong_comm/pages/CommunityPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key, required this.args});

  final DetailArgs args;

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class PostArgs {
  final String title;
  final String category;
  final String desc;
  final String photoURL;
  final String id;

  PostArgs(this.title, this.category, this.desc, this.photoURL, this.id);
}

class _PostDetailPageState extends State<PostDetailPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final _descController = TextEditingController();
  late XFile? video;
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  Future updateLike(String id) async {
    return await FirebaseFirestore.instance
        .collection('community')
        .doc(id)
        .update(<String, dynamic>{
      'like': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid]),
      'likeSize': FieldValue.increment(1),
    });
  }

  Future updateUserWeight(String id, int squat, int bench, int dead) async {
    return await FirebaseFirestore.instance
        .collection('user')
        .doc(id)
        .update(<String, dynamic>{
      'squat': squat,
      'bench': bench,
      'dead': dead,
      'total': squat + dead + bench,
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
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(widget.args.photoURL);

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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!['category'] == '인증' &&
              snapshot.data!['likeSize'] >= 10) {
            updateUserWeight(snapshot.data!['uid'], snapshot.data!['squat'],
                snapshot.data!['bench'], snapshot.data!['dead']);
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
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Scaffold(
                      body: SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.all(8),
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
                                          icon:
                                              const Icon(Icons.arrow_back_ios)),
                                      Row(
                                        children: [
                                          Text(
                                            snapshot.data!['title'],
                                            style: const TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          snapshot.data!['category'] == '인증' &&
                                                  snapshot.data!['likeSize'] >=
                                                      10
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.blue,
                                                  size: 25,
                                                )
                                              : const Text(''),
                                        ],
                                      ),
                                      user!.uid == snapshot.data!['uid']
                                          ? Align(
                                              alignment: Alignment.centerRight,
                                              child: IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    PostEdit(
                                                                      args: PostArgs(
                                                                          snapshot.data![
                                                                              'title'],
                                                                          snapshot.data![
                                                                              'category'],
                                                                          snapshot.data![
                                                                              'desc'],
                                                                          snapshot.data![
                                                                              'photoURL'],
                                                                          widget
                                                                              .args
                                                                              .id),
                                                                    )));
                                                  },
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
                                                  icon:
                                                      const Icon(Icons.delete)))
                                          : const Text(''),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(snapshot.data!['author'] +
                                      ' | ' +
                                      DateFormat.yMMMd()
                                          .format(
                                              (snapshot.data!['createdAt'] ??
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
                                      ? snapshot.data!['isVideo'] != true
                                          ? Image.network(
                                              snapshot.data!['photoURL'])
                                          : Column(
                                              children: [
                                                FutureBuilder(
                                                  future:
                                                      _initializeVideoPlayerFuture,
                                                  builder: (context, snapshot) {
                                                    if (snapshot
                                                            .connectionState ==
                                                        ConnectionState.done) {
                                                      // If the VideoPlayerController has finished initialization, use
                                                      // the data it provides to limit the aspect ratio of the video.
                                                      return AspectRatio(
                                                          aspectRatio:
                                                              _controller.value
                                                                  .aspectRatio,
                                                          // Use the VideoPlayer widget to display the video.
                                                          child: VideoPlayer(
                                                              _controller));
                                                    } else {
                                                      // If the VideoPlayerController is still initializing, show a
                                                      // loading spinner.
                                                      return const Center(
                                                        child:
                                                            CircularProgressIndicator(),
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
                                                      if (_controller
                                                          .value.isPlaying) {
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
                                      : const Text(''),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(snapshot.data!['desc']),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  snapshot.data!['category'] == '인증'
                                      ? Column(
                                          children: [
                                            Text(
                                              '스쿼트 - ${snapshot.data!['squat']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              '데드리프트 - ${snapshot.data!['dead']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              '벤치프레스 - ${snapshot.data!['bench']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            Text(
                                              '총합 - ${snapshot.data!['squat'] + snapshot.data!['bench'] + snapshot.data!['dead']}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            )
                                          ],
                                        )
                                      : const Text(''),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            if (snapshot.data!['like'].contains(
                                                FirebaseAuth.instance
                                                    .currentUser!.uid)) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(contains);
                                            } else {
                                              updateLike(widget.args.id);
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(firstClick);
                                            }
                                          },
                                          icon: const Icon(Icons.thumb_up)),
                                      Text(
                                          '${snapshot.data?['like'].length ?? ''}'),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
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
                                      Map<String, dynamic> data = document
                                          .data()! as Map<String, dynamic>;
                                      return ListTile(
                                        leading: Text(data['author']),
                                        title: Text(data['desc']),
                                        subtitle: Text(
                                          DateFormat.yMMMd()
                                              .add_jm()
                                              .format((data['createdAt'] ??
                                                      '' as Timestamp)
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
                              )))),
                    );
                  },
                )
              : Scaffold(
                  appBar: AppBar(),
                );
        });
  }
}
