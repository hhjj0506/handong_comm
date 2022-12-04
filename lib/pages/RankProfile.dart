import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:handong_comm/pages/MainPage.dart';

class RankProfile extends StatefulWidget {
  const RankProfile({super.key, required this.args});

  final UserArgs args;

  @override
  State<RankProfile> createState() => _RankProfileState();
}

class _RankProfileState extends State<RankProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Column(children: [
          const SizedBox(
            height: 10,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios)),
          ),
          Center(
              child: Column(
            children: [
              Image.network(widget.args.photo),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.args.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
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
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(widget.args.intro),
                      ],
                    ),
                  )),
                ),
              ),
              const SizedBox(
                height: 10,
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
                          '학부',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(widget.args.major),
                        const SizedBox(
                          height: 3,
                        ),
                        const Text(
                          '학번',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(widget.args.year.toString()),
                        const SizedBox(
                          height: 3,
                        ),
                        const Text(
                          '성별',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(widget.args.sex),
                      ],
                    ),
                  )),
                ),
              ),
              const SizedBox(
                height: 10,
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
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text('스쿼트 : ${widget.args.squat.toString()}'),
                        Text('벤치프레스 : ${widget.args.bench.toString()}'),
                        Text('데드리프트 : ${widget.args.dead.toString()}'),
                        Text('3대 총합 : ${widget.args.total.toString()}'),
                      ],
                    ),
                  )),
                ),
              ),
            ],
          ))
        ]),
      )),
    );
  }
}
