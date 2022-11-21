import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("리스트뷰 이용해서 예전에 게시판 만들었던것처럼 하기\n 카테고리 별로 보는 기능 추가"),
      ),
    );
  }
}
