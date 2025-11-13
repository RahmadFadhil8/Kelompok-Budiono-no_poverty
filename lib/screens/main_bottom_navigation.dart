import 'package:flutter/material.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/screens/chat/chat.dart';

import 'package:no_poverty/screens/chatbot/chat_bot_screen.dart';
import 'package:no_poverty/screens/home/customer/customer_home_screen.dart';
import 'package:no_poverty/screens/notifikasi/notifikasi.dart';
import 'package:no_poverty/screens/profile/profile.dart';
import 'package:no_poverty/screens/search/search_screen.dart';

class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({super.key});

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  final List<Widget> _screens = [CustomerHomeScreen(), SearchScreen(), ChatScreenPage(), NotifikasiPage(), ProfileScreen()];

  MyAnalytics analytics = MyAnalytics();

  String pageName(int index) {
    switch (index) {
      case 0:
        return "Home";
      case 1:
        return "Search";
      case 2:
        return "Chat";
      case 3:
        return "Notifikasi";
      case 4:
        return "Profile";
      default:
        return 'Unknown';
    }
  }

  int _selectedScreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedScreen],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBotScreen()),
          );
        },
        child: const Icon(Icons.smart_toy_outlined, color: Colors.white, size: 34,),
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
          analytics.userpindahPage(pageName(value));
        },
      ),
    );
  }
}
