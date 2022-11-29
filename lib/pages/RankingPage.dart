import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/pages/MainPage.dart';
import 'package:handong_comm/pages/RankProfile.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final Stream<QuerySnapshot> userStream = FirebaseFirestore.instance
      .collection('user')
      .orderBy('total', descending: true)
      .snapshots();

  var list = List<int>.generate(10, (i) => i + 1);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: userStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
          if (userSnapshot.hasError) {
            return const Text('Error!');
          }

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return SingleChildScrollView(
            child: Column(children: [
              const Text(
                "랭킹",
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(
                height: 10,
              ),
              ListView(
                shrinkWrap: true,
                children:
                    userSnapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    leading: Text(list[0].toString()), // 여기 랭킹 들어가야 함
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
            ]),
          );
        });
  }
}
