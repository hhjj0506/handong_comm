import 'package:flutter/material.dart';
import 'package:handong_comm/pages/ProfilePage.dart';

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
  final _totalController = TextEditingController();

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
    _totalController.text = widget.args.total.toString();
    String majorVal = widget.args.major;
    String sexVal = widget.args.sex;
    String yearVal = widget.args.year.toString();

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
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
              TextField(
                readOnly: true,
                controller: _totalController,
                decoration: const InputDecoration(
                  labelText: 'Total Weight',
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              DropdownButton(
                  value: majorVal,
                  items:
                      majorList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    _majorController.text = value!;
                  }),
              const SizedBox(
                height: 5.0,
              ),
              DropdownButton(
                  value: sexVal,
                  items: sexList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    _sexController.text = value!;
                  }),
              const SizedBox(
                height: 5.0,
              ),
              DropdownButton(
                  value: _yearController.text,
                  items: yearList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem(value: value, child: Text(value));
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _yearController.text = value!;
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
