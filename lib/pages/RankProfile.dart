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
                height: 5,
              ),
              Text(
                widget.args.name,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('자기소개 : ${widget.args.intro}'),
              const SizedBox(
                height: 10,
              ),
              Text('학부 : ${widget.args.major}'),
              Text('학번 : ${widget.args.year.toString()}'),
              Text('성별 : ${widget.args.sex}'),
              const SizedBox(
                height: 10,
              ),
              Text('스쿼트 : ${widget.args.squat.toString()}'),
              Text('벤치프레스 : ${widget.args.bench.toString()}'),
              Text('데드리프트 : ${widget.args.dead.toString()}'),
              Text('3대 총합 : ${widget.args.total.toString()}'),
            ],
          ))
        ]),
      )),
    );
  }
}
