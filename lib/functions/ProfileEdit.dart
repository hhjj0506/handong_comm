import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/pages/ProfilePage.dart';

List<String> majorList = <String>[
  'GLS',
  '전산전자',
  '경영경제',
  '국제어문',
  'ICT창업',
  '법학',
  '커뮤니케이션',
  '공간환경',
  '기계제어',
  '콘텐츠융합디자인',
  '생명과학',
  '상담심리사회복지',
  '창의융합',
  'AI융합'
];
List<String> sexList = <String>['M', 'F'];
List<String> yearList = <String>[
  '13',
  '14',
  '15',
  '16',
  '17',
  '18',
  '19',
  '20',
  '21',
  '22',
  '23'
];

class ProfileEdit extends StatefulWidget {
  const ProfileEdit({super.key, required this.args});

  final ProfileArgs args;

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _nameController = TextEditingController();
  final _msgController = TextEditingController();
  final _majorController = TextEditingController();
  final _sexController = TextEditingController();
  final _yearController = TextEditingController();
  String majorVal = '';
  String sexVal = '';
  String yearVal = '';

  Future<void> updateInfo() async {
    await FirebaseAuth.instance.currentUser
        ?.updateDisplayName(_nameController.text);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.args.uid)
        .update(<String, dynamic>{
      'nickname': FirebaseAuth.instance.currentUser!.displayName,
      'message': _msgController.text,
      'year': int.parse(yearVal),
      'major': majorVal,
      'sex': sexVal,
    });
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.args.name;
    _msgController.text = widget.args.message;
    _majorController.text = widget.args.major;
    _sexController.text = widget.args.sex;
    _yearController.text = widget.args.year.toString();
    majorVal = widget.args.major;
    sexVal = widget.args.sex;
    yearVal = widget.args.year.toString();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              StatefulBuilder(builder: (context, setState) {
                return Column(
                  children: [
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text('Major'),
                    DropdownButton(
                        value: majorVal,
                        items: majorList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            majorVal = value!;
                          });
                        }),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text('Sex'),
                    DropdownButton(
                        value: sexVal,
                        items: sexList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            sexVal = value!;
                          });
                        }),
                    const SizedBox(
                      height: 5.0,
                    ),
                    const Text('Class'),
                    DropdownButton(
                        value: yearVal,
                        items: yearList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem(
                              value: value, child: Text(value));
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            yearVal = value!;
                          });
                        }),
                    const SizedBox(
                      height: 5.0,
                    ),
                  ],
                );
              }),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nickname',
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _msgController,
                decoration: const InputDecoration(
                  labelText: 'Message',
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('취소')),
                  ElevatedButton(
                      onPressed: () async {
                        await updateInfo();
                        Navigator.pop(context);
                      },
                      child: const Text('완료')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
