import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '게시판',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '랭킹',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '프로필',
        ),
      ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      backgroundColor: Colors.black,
    );
  }
}
