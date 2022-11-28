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
  final _benchController = TextEditingController();
  final _squatController = TextEditingController();
  final _deadController = TextEditingController();
  final _msgController = TextEditingController();
  final _majorController = TextEditingController();
  final _sexController = TextEditingController();
  final _yearController = TextEditingController();
  String majorVal = majorList.first;
  String sexVal = sexList.first;
  String yearVal = yearList.first;

  Future<void> updateInfo() async {
    await FirebaseAuth.instance.currentUser
        ?.updateDisplayName(_nameController.text);
    await FirebaseFirestore.instance
        .collection('user')
        .doc(widget.args.uid)
        .update(<String, dynamic>{
      'message': _msgController.text,
      'dead': int.parse(_deadController.text),
      'bench': int.parse(_benchController.text),
      'squat': int.parse(_squatController.text),
      'total': int.parse(_squatController.text) +
          int.parse(_benchController.text) +
          int.parse(_deadController.text),
      'year': int.parse(yearVal),
      'major': majorVal,
      'sex': sexVal,
    });
  }

  @override
  Widget build(BuildContext context) {
    _nameController.text = widget.args.name;
    _benchController.text = widget.args.bench.toString();
    _squatController.text = widget.args.squat.toString();
    _deadController.text = widget.args.dead.toString();
    _msgController.text = widget.args.message;
    _majorController.text = widget.args.major;
    _sexController.text = widget.args.sex;
    _yearController.text = widget.args.year.toString();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 5.0,
              ),
              const Text('Major'),
              DropdownButton(
                  value: majorVal,
                  items:
                      majorList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    majorVal = value!;
                  }),
              const SizedBox(
                height: 5.0,
              ),
              const Text('Sex'),
              DropdownButton(
                  value: sexVal,
                  items: sexList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    sexVal = value!;
                  }),
              const SizedBox(
                height: 5.0,
              ),
              const Text('Class'),
              DropdownButton(
                  value: yearVal,
                  items: yearList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      yearVal = value!;
                    });
                  }),
              const SizedBox(
                height: 5.0,
              ),
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
              TextField(
                controller: _benchController,
                decoration: const InputDecoration(
                  labelText: 'Bench Press Weight',
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _squatController,
                decoration: const InputDecoration(
                  labelText: 'Squat Weight',
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              TextField(
                controller: _deadController,
                decoration: const InputDecoration(
                  labelText: 'Deadlift Weight',
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
