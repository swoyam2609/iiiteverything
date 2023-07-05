import 'package:flutter/material.dart';
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
          //TODO:- Make the donload screen
          Center(child: Text("Download Screen")),

          //TODO:- Make the upload screen
          comingSoon(),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF211E2E),
          onTap: (index) {
            onItemTapped(index);
          },
          selectedItemColor: Colors.green,
          currentIndex: selectedIndex,
          elevation: 3.0,
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
      ),
    );
  }
}
