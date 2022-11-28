import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/pages/CommunityPage.dart';
import 'package:handong_comm/pages/PostDetailPage.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  final Stream<QuerySnapshot> userStream = FirebaseFirestore.instance
      .collection('user')
      .orderBy('total', descending: true)
      .limit(5)
      .snapshots();
  final Stream<QuerySnapshot> postStream = FirebaseFirestore.instance
      .collection('community')
      .orderBy('likeSize', descending: true)
      .limit(5)
      .snapshots();

  var list = List<int>.generate(10, (i) => i + 1);
  var index = 0;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: postStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> postSnapshot) {
          if (postSnapshot.hasError) {
            return const Text('Error!');
          }

          if (postSnapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return StreamBuilder(
              stream: userStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> userSnapshot) {
                if (userSnapshot.hasError) {
                  return const Text('Error!');
                }

                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Icon(
                              Icons.trending_up,
                              color: Colors.white,
                            ),
                            Text(
                              "인기 있는 포스트",
                              style: TextStyle(fontSize: 24),
                            ),
                          ]),
                      Column(
                        children: [
                          Card(
                            child: ListView(
                              shrinkWrap: true,
                              children: postSnapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return ListTile(
                                  leading: data['photoURL'] != ''
                                      ? Image.network(data['photoURL'])
                                      : Image.network(
                                          'https://hhjj0506.github.io/static/646c1ae06960d741136caba28b1db3c0/27ab5/profile.webp'),
                                  title: Text(data['title']),
                                  subtitle: Text(
                                    data['author'] +
                                        ' | ' +
                                        DateFormat.yMMMd()
                                            .add_jm()
                                            .format((data['createdAt'] ??
                                                    '' as Timestamp)
                                                .toDate())
                                            .toString(),
                                    maxLines: 1,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Column(
                                    children: [
                                      const Icon(Icons.thumb_up),
                                      Text('${data['like'].length ?? ''}'),
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostDetailPage(
                                                  args: DetailArgs(document.id),
                                                )));
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.equalizer,
                              color: Colors.white,
                            ),
                            Text(
                              "학교 전체 랭킹",
                              style: TextStyle(fontSize: 24),
                            ),
                          ]),
                      Column(
                        children: [
                          Card(
                            child: ListView(
                              shrinkWrap: true,
                              children: userSnapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return ListTile(
                                  leading:
                                      Text(list[0].toString()), // 여기 랭킹 들어가야 함
                                  title: Text(data['nickname']),
                                  subtitle: Text(
                                    data['total'].toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Image.network(data['photo']),
                                  onTap: () {},
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
