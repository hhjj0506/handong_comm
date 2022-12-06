import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/pages/CommunityPage.dart';
import 'package:handong_comm/pages/LoginPage.dart';
import 'package:handong_comm/functions/ProfileEdit.dart';
import 'package:handong_comm/pages/PostDetailPage.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class ProfileArgs {
  final String uid;
  final String name;
  final String message;
  final int squat;
  final int bench;
  final int dead;
  final String major;
  final String sex;
  final int year;
  final int total;

  ProfileArgs(this.uid, this.name, this.message, this.squat, this.bench,
      this.dead, this.major, this.sex, this.year, this.total);
}

class _ProfilePageState extends State<ProfilePage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    String username = user?.displayName ?? '';
    String url = user?.photoURL ?? '';
    String name = user?.displayName ?? '';
    final Stream<DocumentSnapshot> stream = FirebaseFirestore.instance
        .collection('user')
        .doc(user!.uid)
        .snapshots();
    final Stream<QuerySnapshot> myPostStream = FirebaseFirestore.instance
        .collection('community')
        .where('uid', isEqualTo: user?.uid)
        .snapshots();
    final Stream<QuerySnapshot> commStream = FirebaseFirestore.instance
        .collectionGroup('comment')
        .where('uid', isEqualTo: user?.uid)
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

        return StreamBuilder(
            stream: myPostStream,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> postSnapshot) {
              if (postSnapshot.hasError) {
                return const Text('Error!');
              }

              if (postSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return StreamBuilder(
                  stream: commStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> commSnapshot) {
                    if (commSnapshot.hasError) {
                      return const Text('comment Error!');
                    }

                    if (commSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return Scaffold(
                      body: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      FirebaseAuth.instance.signOut();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage()));
                                    },
                                    icon: const Icon(Icons.logout)),
                                Image.network(url),
                                IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProfileEdit(
                                                    args: ProfileArgs(
                                                      snapshot.data!['uid'],
                                                      snapshot
                                                          .data!['nickname'],
                                                      snapshot.data!['message'],
                                                      snapshot.data!['squat'],
                                                      snapshot.data!['bench'],
                                                      snapshot.data!['dead'],
                                                      snapshot.data!['major'],
                                                      snapshot.data!['sex'],
                                                      snapshot.data!['year'],
                                                      snapshot.data!['total'],
                                                    ),
                                                  )));
                                    },
                                    icon: const Icon(Icons.edit)),
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              username,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      const Text(
                                        '자기소개',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text(snapshot.data!['message'] == ''
                                          ? '자기소개를 적어주세요!'
                                          : snapshot.data!['message']),
                                    ],
                                  ),
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      const Text(
                                        '개인정보',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text('이름 : ${snapshot.data!['name']}'),
                                      Text('학부 : ${snapshot.data!['major']}'),
                                      Text('학번 : ${snapshot.data!['year']}'),
                                      Text('성별 : ${snapshot.data!['sex']}'),
                                    ],
                                  ),
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      const Text(
                                        '운동 정보',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Text('스쿼트 : ${snapshot.data!['squat']}'),
                                      Text(
                                          '벤치프레스 : ${snapshot.data!['bench']}'),
                                      Text('데드리프트 : ${snapshot.data!['dead']}'),
                                      Text(
                                          '3대 총합 : ${snapshot.data!['total']}'),
                                    ],
                                  ),
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Text(
                              '내가 쓴 글',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(
                                    children: [
                                      ListView(
                                        shrinkWrap: true,
                                        children: postSnapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                          Map<String, dynamic> data = document
                                              .data()! as Map<String, dynamic>;
                                          return Padding(
                                            padding: EdgeInsets.all(0),
                                            child: ListTile(
                                              leading: AspectRatio(
                                                aspectRatio: 16 / 9,
                                                child: data['photoURL'] != ''
                                                    ? data['isVideo'] != true
                                                        ? Image.network(
                                                            data['photoURL'])
                                                        : const Icon(
                                                            Icons.play_arrow)
                                                    : Image.network(
                                                        'https://hhjj0506.github.io/static/646c1ae06960d741136caba28b1db3c0/27ab5/profile.webp'),
                                              ),
                                              title: Row(
                                                children: [
                                                  Text(data['title'] + ' '),
                                                  Text(
                                                    data['category'],
                                                    style: const TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey),
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
                                                        .format((data[
                                                                    'createdAt'] ??
                                                                '' as Timestamp)
                                                            .toDate())
                                                        .toString(),
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              ),
                                              trailing: Column(
                                                children: [
                                                  const Icon(Icons.thumb_up),
                                                  Text(
                                                      '${data['like'].length ?? ''}'),
                                                ],
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PostDetailPage(
                                                              args: DetailArgs(
                                                                  document.id,
                                                                  data[
                                                                      'photoURL']),
                                                            )));
                                              },
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            const Text(
                              '내가 쓴 댓글',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(32, 0, 32, 0),
                              child: SizedBox(
                                width: double.infinity,
                                child: Card(
                                    child: Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Column(
                                    children: [
                                      ListView(
                                        shrinkWrap: true,
                                        children: commSnapshot.data!.docs
                                            .map((DocumentSnapshot document) {
                                          Map<String, dynamic> commData =
                                              document.data()!
                                                  as Map<String, dynamic>;
                                          return Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: ListTile(
                                              leading: Text(commData['author']),
                                              title: Text(commData['desc']),
                                              subtitle: Text(
                                                DateFormat.yMMMd()
                                                    .add_jm()
                                                    .format((commData[
                                                                'createdAt'] ??
                                                            '' as Timestamp)
                                                        .toDate())
                                                    .toString(),
                                                maxLines: 1,
                                              ),
                                              trailing: user?.uid ==
                                                      commData['uid']
                                                  ? IconButton(
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'community')
                                                            .doc(document
                                                                .reference
                                                                .parent
                                                                .parent!
                                                                .id)
                                                            .collection(
                                                                'comment')
                                                            .doc(document.id)
                                                            .delete();
                                                      },
                                                    )
                                                  : const Text(''),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            });
      },
    );
  }
}
