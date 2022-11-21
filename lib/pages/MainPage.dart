import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainState();
}

class _MainState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("***님, 어서오세요"), // username displayed
          Card(
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Icon(
                        Icons.trending_up,
                        color: Colors.white,
                      ),
                      const Text(
                        "인기 있는 포스트",
                        style: TextStyle(fontSize: 24),
                      ),
                    ]),
                const Text(
                    "에타처럼 제목, 날짜, 글쓴이? 칼럼 들어가고 추천 많이 받은 포스트 5개 정도\n 포스트 누르면 해당 포스트로 이동"),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    Icons.equalizer,
                    color: Colors.white,
                  ),
                  Text(
                    "** 랭킹",
                    style: TextStyle(fontSize: 24),
                  ),
                ]),
                Text(
                    "랜덤 카테고리 (학부, 학번, 성별 등) 랭킹 나오고\n 맨 아래는 카테고리속 자신의 랭킹 하이라이트해서 보여주기"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
