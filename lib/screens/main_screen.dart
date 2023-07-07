import 'package:flutter/material.dart';
import 'package:iiiteverything/screens/download_screen.dart';
import 'package:iiiteverything/screens/upload_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          DownloadScreen(),
          comingSoon(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF211E2E),
        onTap: (index) {
          onItemTapped(index);
        },
        iconSize: 30,
        selectedItemColor: Colors.purple[200],
        currentIndex: selectedIndex,
        elevation: 5.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.download_rounded,
            ),
            label: "Browse",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.upload_file_rounded,
            ),
            label: "Upload",
          ),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            width: 75,
            height: 75,
            decoration: BoxDecoration(
              color: const Color(0xFF302C42),
              borderRadius: BorderRadius.circular(50),
            ),
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.purple[200],
              child: Icon(
                selectedIndex == 0
                    ? Icons.search
                    : Icons.supervised_user_circle,
                color: const Color(0xFF211E2E),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
