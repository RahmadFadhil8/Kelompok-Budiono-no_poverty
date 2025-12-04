import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:no_poverty/Analytics/analytics_helper.dart';
import 'package:no_poverty/screens/chat/chat.dart';
import 'package:no_poverty/screens/chatbot/chat_bot_screen.dart';
import 'package:no_poverty/screens/home/customer/customer_home_screen.dart';
import 'package:no_poverty/screens/home/work/work_home_screen.dart';
import 'package:no_poverty/screens/notifikasi/notifikasi.dart';
import 'package:no_poverty/screens/profile/profile.dart';
import 'package:no_poverty/screens/search/search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainBottomNavigation extends StatefulWidget {
  const MainBottomNavigation({super.key});

  @override
  State<MainBottomNavigation> createState() => _MainBottomNavigationState();
}

class _MainBottomNavigationState extends State<MainBottomNavigation> {
  final List<Widget> _screens = [
    CustomerHomeScreen(),
    SearchScreen(),
    ChatScreenPage(),
    NotifikasiPage(),
    ProfileScreen(),
  ];

  final List<Widget> _screensWorkMode = [
    WorkHomeScreen(),
    SearchScreen(),
    ChatScreenPage(),
    NotifikasiPage(),
    ProfileScreen(),
  ];

  SharedPreferences? prefs;
  bool isWorkMode = false;
  int _selectedScreen = 0;

  final MyAnalytics analytics = MyAnalytics();

  @override
  void initState() {
    super.initState();
    _initPrefs().then((_) {
      analytics.startTracking(screenName(_selectedScreen));
    });
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final storedMode = prefs?.getBool("isWorkMode") ?? false;
    setState(() {
      isWorkMode = storedMode;
    });
  }

  String screenName(int index) {
    switch (index) {
      case 0:
        return "Home Screen";
      case 1:
        return "Search Screen";
      case 2:
        return "Chat Screen";
      case 3:
        return "Notifikasi Screen";
      case 4:
        return "Profile Screen";
      default:
        return 'Unknown';
    }
  }

  @override
  void dispose() {
    analytics.endTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (prefs == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar:
          _selectedScreen == 0
              ? AppBar(
                title: Row(
                  children: [
                    AnimatedToggleSwitch<bool>.dual(
                      current: isWorkMode,
                      first: false,
                      second: true,
                      spacing: 50,
                      style: const ToggleStyle(
                        borderColor: Color.fromARGB(31, 155, 155, 155),
                      ),
                      borderWidth: 5.0,
                      height: 55,
                      onChanged: (value) async {
                        setState(() => isWorkMode = value);
                        await prefs!.setBool("isWorkMode", value);
                        await analytics.changeMode(value);
                      },
                      styleBuilder:
                          (value) => ToggleStyle(
                            indicatorColor: value ? Colors.green : Colors.blue,
                          ),
                      iconBuilder:
                          (value) =>
                              value
                                  ? const Icon(
                                    Icons.engineering,
                                    color: Colors.white,
                                    size: 32,
                                  )
                                  : const Icon(
                                    Icons.business_center,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                      textBuilder:
                          (value) =>
                              value
                                  ? const Center(child: Text('Work'))
                                  : const Center(child: Text('Hire')),
                    ),
                  ],
                ),
                backgroundColor: Colors.white,
                actions: [
                  IconButton(
                    onPressed: () {
                      analytics.clikcbutton("notifikasi");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotifikasiPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Colors.black,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      analytics.clikcbutton("Settings");
                    },
                    icon: const Icon(Icons.settings, color: Colors.black),
                  ),
                ],
              )
              : null,
      body:
          isWorkMode
              ? _screensWorkMode[_selectedScreen]
              : _screens[_selectedScreen],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ChatBotScreen()),
          );
        },
        child: const Icon(
          Icons.smart_toy_outlined,
          color: Colors.white,
          size: 34,
        ),
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
            label: "Notifikasi",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedScreen,
        onTap: (value) async {
          await analytics.endTracking();
          setState(() => _selectedScreen = value);
          analytics.startTracking(screenName(value));
          analytics.userpindahPage(screenName(value));
        },
      ),
    );
  }
}
