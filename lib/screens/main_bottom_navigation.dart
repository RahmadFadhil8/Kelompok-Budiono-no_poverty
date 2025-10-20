import 'package:flutter/material.dart';
import 'package:no_poverty/screens/home/home_screen.dart';
import 'package:no_poverty/screens/search/search_screen.dart';

class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({super.key});

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  final List<Widget> _screens = [HomeScreen(), SearchScreen()];
  int _selectedScreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreen],
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.chat),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "notifikasi",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedScreen,
        onTap: (value) {
          setState(() {
            _selectedScreen = value;
          });
        },
      ),
    );
  }
}
