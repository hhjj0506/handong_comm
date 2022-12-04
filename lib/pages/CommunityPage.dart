import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/functions/AddPost.dart';
import 'package:handong_comm/pages/PostDetailPage.dart';
import 'package:intl/intl.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class DetailArgs {
  final String id;
  final String photoURL;

  DetailArgs(
    this.id,
    this.photoURL,
  );
}

const List<String> catList = <String>['전체', '자유', '운동', '인증'];

class _CommunityPageState extends State<CommunityPage> {
  String catDropdownValue = catList.first;
  @override
  Widget build(BuildContext context) {
    final CollectionReference stream =
        FirebaseFirestore.instance.collection('community');
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: catDropdownValue == '전체'
              ? stream.orderBy('createdAt', descending: true).snapshots()
              : stream
                  .where('category', isEqualTo: catDropdownValue)
                  .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Error!');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton(
                      value: catDropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      items:
                          catList.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          catDropdownValue = value!;
                        });
                      },
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddPost()));
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ),
                Expanded(
                  child: ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
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
                          ],
                        ),
                        subtitle: Text(
                          data['author'] +
                              ' | ' +
                              DateFormat.yMMMd()
                                  .add_jm()
                                  .format((data['createdAt'] ?? '' as Timestamp)
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
                                  builder: (context) => PostDetailPage(
                                        args: DetailArgs(
                                            document.id, data['photoURL']),
                                      )));
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
