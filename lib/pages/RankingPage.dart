import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:handong_comm/pages/MainPage.dart';
import 'package:handong_comm/pages/RankProfile.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

List<String> majorList = <String>[
  '전공',
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
List<String> sexList = <String>['성별', 'M', 'F'];
List<String> yearList = <String>[
  '학번',
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
List<String> liftList = <String>['총합', '스쿼트', '데드리프트', '벤치프레스'];

class _RankingPageState extends State<RankingPage> {
  String majorValue = majorList.first;
  String sexValue = sexList.first;
  String yearValue = yearList.first;
  String liftValue = liftList.first;
  String liftOrder = 'total';
  int i = 0;

  late Stream<QuerySnapshot> userStream;

  var list = List<int>.generate(10, (i) => i + 1);
  @override
  Widget build(BuildContext context) {
    // 모두 선택이 되었을 때

    if (majorValue != '전공' && sexValue != '성별' && yearValue != '학번') {
      userStream = FirebaseFirestore.instance
          .collection('user')
          .where('major', isEqualTo: majorValue)
          .where('sex', isEqualTo: sexValue)
          .where('year', isEqualTo: int.parse(yearValue))
          .orderBy(liftOrder, descending: true)
          .snapshots();
    } else if (majorValue != '전공' && sexValue != '성별') {
      // 전공과 성별이 선택 되었을 때
      userStream = FirebaseFirestore.instance
          .collection('user')
          .where('major', isEqualTo: majorValue)
          .where('sex', isEqualTo: sexValue)
          .orderBy(liftOrder, descending: true)
          .snapshots();
    } else if (sexValue != '성별' && yearValue != '학번') {
      // 성별과 학번이 선택 되었을 때
      userStream = FirebaseFirestore.instance
          .collection('user')
          .where('sex', isEqualTo: sexValue)
          .where('year', isEqualTo: int.parse(yearValue))
          .orderBy(liftOrder, descending: true)
          .snapshots();
    } else if (majorValue != '전공' && yearValue != '학번') {
      // 전공과 학번이 선택 되었을 때
      userStream = FirebaseFirestore.instance
          .collection('user')
          .where('major', isEqualTo: majorValue)
          .where('year', isEqualTo: int.parse(yearValue))
          .orderBy(liftOrder, descending: true)
          .snapshots();
    } else if (majorValue != '전공') {
      // 전공만 선택 되었을 때
      userStream = FirebaseFirestore.instance
          .collection('user')
          .where('major', isEqualTo: majorValue)
          .orderBy(liftOrder, descending: true)
          .snapshots();
    } else if (sexValue != '성별') {
      // 성별만 선택 되었을 때
      userStream = FirebaseFirestore.instance
          .collection('user')
          .where('sex', isEqualTo: sexValue)
          .orderBy(liftOrder, descending: true)
          .snapshots();
    } else if (yearValue != '학번') {
      // 학번만 선택 되었을 때
      userStream = FirebaseFirestore.instance
          .collection('user')
          .where('year', isEqualTo: int.parse(yearValue))
          .orderBy(liftOrder, descending: true)
          .snapshots();
    } else {
      // 모두가 선택이 되지 않았을 때
      userStream = FirebaseFirestore.instance
          .collection('user')
          .orderBy(liftOrder, descending: true)
          .snapshots();
    }

    return StreamBuilder(
        stream: userStream,
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> userSnapshot) {
          if (userSnapshot.hasError) {
            return const Text('Error!');
          }

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            child: Column(children: [
              const Text(
                "랭킹",
                style: TextStyle(fontSize: 24),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  DropdownButton(
                    value: majorValue,
                    icon: const Icon(Icons.arrow_downward),
                    items:
                        majorList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        majorValue = value!;
                      });
                    },
                  ),
                  DropdownButton(
                    value: sexValue,
                    icon: const Icon(Icons.arrow_downward),
                    items:
                        sexList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        sexValue = value!;
                      });
                    },
                  ),
                  DropdownButton(
                    value: yearValue,
                    icon: const Icon(Icons.arrow_downward),
                    items:
                        yearList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        yearValue = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    value: liftValue,
                    icon: const Icon(Icons.arrow_downward),
                    items:
                        liftList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        if (value == '총합') {
                          liftOrder = 'total';
                        } else if (value == '스쿼트') {
                          liftOrder = 'squat';
                        } else if (value == '데드리프트') {
                          liftOrder = 'dead';
                        } else if (value == '벤치프레스') {
                          liftOrder = 'squat';
                        }
                        liftValue = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ListView(
                shrinkWrap: true,
                children:
                    userSnapshot.data!.docs.map((DocumentSnapshot document) {
                  userSnapshot.data!.size <= i ? i = 0 : '';
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    leading: Text(
                      list[i++].toString(),
                      style: const TextStyle(fontSize: 20),
                    ), // 여기 랭킹 들어가야 함
                    title: Text(data['nickname']),
                    subtitle: Text(data[liftOrder].toString()),
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
