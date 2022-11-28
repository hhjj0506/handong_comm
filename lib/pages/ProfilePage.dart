import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/pages/LoginPage.dart';
import 'package:handong_comm/functions/ProfileEdit.dart';

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
                                  builder: (context) => const LoginPage()));
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
                                          snapshot.data!['nickname'],
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
                Card(
                  child: Column(
                    children: [
                      const Text(
                        '자기소개',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(snapshot.data!['message'] == ''
                          ? '자기소개를 적어주세요!'
                          : snapshot.data!['message']),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Card(
                  child: Column(
                    children: [
                      const Text(
                        '개인정보',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('이름 : ${snapshot.data!['name']}'),
                      Text('학부 : ${snapshot.data!['major']}'),
                      Text('학번 : ${snapshot.data!['year']}'),
                      Text('성별 : ${snapshot.data!['sex']}'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Card(
                  child: Column(
                    children: [
                      const Text(
                        '운동 정보',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text('스쿼트 : ${snapshot.data!['squat']}'),
                      Text('벤치프레스 : ${snapshot.data!['bench']}'),
                      Text('데드리프트 : ${snapshot.data!['dead']}'),
                      Text('3대 총합 : ${snapshot.data!['total']}'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                const Text(
                  '내가 쓴글',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Text(
                  '내가 쓴 댓글',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
