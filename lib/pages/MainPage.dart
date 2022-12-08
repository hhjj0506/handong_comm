import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/pages/CommunityPage.dart';
import 'package:handong_comm/pages/PostDetailPage.dart';
import 'package:handong_comm/pages/RankProfile.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainState();
}

class UserArgs {
  final String id;
  final String name;
  final String major;
  final int year;
  final String sex;
  final String intro;
  final String photo;
  final int squat;
  final int bench;
  final int dead;
  final int total;

  UserArgs(this.id, this.name, this.major, this.year, this.sex, this.intro,
      this.photo, this.squat, this.bench, this.dead, this.total);
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
  int i = 0;
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return StreamBuilder(
              stream: userStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> userSnapshot) {
                if (userSnapshot.hasError) {
                  return const Text('Error!');
                }

                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
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
                            Text('  '),
                            Text(
                              "인기 있는 포스트",
                              style: TextStyle(fontSize: 24),
                            ),
                          ]),
                      const SizedBox(
                        height: 5,
                      ),
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
                                  leading: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: data['photoURL'] != ''
                                        ? data['isVideo'] != true
                                            ? Image.network(data['photoURL'])
                                            : const Icon(Icons.play_arrow)
                                        : Image.network(
                                            'https://hhjj0506.github.io/static/646c1ae06960d741136caba28b1db3c0/27ab5/profile.webp'),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(data['title'] + ' '),
                                      Text(
                                        data['category'],
                                        style: const TextStyle(
                                            fontSize: 10, color: Colors.grey),
                                      ),
                                      data['category'] == '인증' &&
                                              data['likeSize'] >= 10
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.blue,
                                              size: 15,
                                            )
                                          : const Text(''),
                                    ],
                                  ),
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
                                                  args: DetailArgs(document.id,
                                                      data['photoURL']),
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
                            Text('  '),
                            Text(
                              "학교 전체 랭킹",
                              style: TextStyle(fontSize: 24),
                            ),
                          ]),
                      const SizedBox(
                        height: 5,
                      ),
                      Column(
                        children: [
                          Card(
                            child: ListView(
                              shrinkWrap: true,
                              children: userSnapshot.data!.docs
                                  .map((DocumentSnapshot document) {
                                userSnapshot.data!.size <= i ? i = 0 : '';
                                Map<String, dynamic> data =
                                    document.data()! as Map<String, dynamic>;
                                return ListTile(
                                  leading: Text(
                                    list[i++].toString(),
                                    style: const TextStyle(fontSize: 20),
                                  ), // 여기 랭킹 들어가야 함
                                  title: Text(data['nickname']),
                                  subtitle: Text(
                                    data['total'].toString(),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  trailing: Image.network(data['photo']),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RankProfile(
                                                  args: UserArgs(
                                                      document.id,
                                                      data['nickname'],
                                                      data['major'],
                                                      data['year'],
                                                      data['sex'],
                                                      data['message'],
                                                      data['photo'],
                                                      data['squat'],
                                                      data['bench'],
                                                      data['dead'],
                                                      data['total']),
                                                )));
                                  },
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
