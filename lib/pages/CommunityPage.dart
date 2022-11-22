import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/pages/AddPost.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

const List<String> list = <String>['ASC', 'DESC'];

class _CommunityPageState extends State<CommunityPage> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> stream =
        FirebaseFirestore.instance.collection('community').snapshots();
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: stream,
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
                  children: [
                    DropdownButton(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
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
                ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return ListTile();
                  }).toList(),
                ),
              ],
            );
          }),
    );
  }
}
