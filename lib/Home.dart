import 'package:flutter/material.dart';
import 'package:handong_comm/pages/CommunityPage.dart';
import 'package:handong_comm/pages/MainPage.dart';
import 'package:handong_comm/pages/ProfilePage.dart';
import 'package:handong_comm/pages/RankingPage.dart';
import 'package:handong_comm/pose_detection/pose_detector_view.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MainState();
}

class _MainState extends State<Home> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: PageView(
        controller: _pageController,
        children: const <Widget>[
          MainPage(),
          CommunityPage(),
          RankingPage(),
          PoseDetectorView(),
          ProfilePage(),
        ],
        onPageChanged: (page) {
          setState(() {
            _selectedIndex = page;
          });
        },
      )),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.white,
            ),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.forum,
              color: Colors.white,
            ),
            label: '게시판',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.equalizer,
              color: Colors.white,
            ),
            label: '랭킹',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.fitness_center,
              color: Colors.white,
            ),
            label: '자세 인식',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
              color: Colors.white,
            ),
            label: '프로필',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
      ),
    );
  }
}
