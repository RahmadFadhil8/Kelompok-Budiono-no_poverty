import 'dart:async';

import 'package:flutter/material.dart';
import 'package:no_poverty/screens/auth/database_auth/user_database.dart';
import 'package:no_poverty/screens/auth/register.dart';
import 'package:no_poverty/screens/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool EmailSelected = true;

  final StreamController<bool> _loginController = StreamController<bool>.broadcast();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState(){
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    if (isLoggedIn) {
      _loginController.add(true);
    }
  }
  
  Future<void> loginUser() async {
    TableUser tableUser = TableUser();
    String input = _userController.text.trim();
    String password = _passwordController.text;
    bool isEmail = EmailSelected;

    if (input.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email/Telepone dan password tidak boleh kosong!")),
      );
      return;
    }
    bool success = await tableUser.checkUser(input, password, isEmail);
  
    if(success) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('userInput', input);
      await prefs.setBool('isEmail', isEmail);

      _loginController.add(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login gagal, Periksa kembali Email/Telepon dan Password")));
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _loginController.stream,
      initialData: false,
      builder: (context, snapshot) {
        bool isLoggedIn = snapshot.data ?? false;

        if (isLoggedIn) {
          return const Home();
        }
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF001B48), Color(0xFF018ABE)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ListTile(
                      leading: const Icon(
                        Icons.storefront,
                        size: 70,
                        color: Colors.white,
                      ),
                      title: Text(
                        "JobWaroeng",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "Temukan Pekerjaan Harianmu",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      width: 250,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(300),
                            blurRadius: 4,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF018ABE),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {},
                              child: Container(
                                alignment: Alignment.center,
                                child: const Text(
                                  "Daftar",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: 400,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha(300),
                            blurRadius: 4,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 45,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD6EBEE),
                              borderRadius: BorderRadius.circular(18),
                              boxShadow:
                                  EmailSelected
                                      ? [
                                        BoxShadow(
                                          color: Colors.black.withAlpha(300),
                                          blurRadius: 3,
                                        ),
                                      ]
                                      : null,
                            ),

                            //tombol Email dan telepon
                            child: Row(
                              children: [
                                // email
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        EmailSelected = true;
                                        _userController.clear();
                                        _passwordController.clear();
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            EmailSelected
                                                ? Colors.white
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow:
                                            EmailSelected
                                                ? [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(300),
                                                    blurRadius: 3,
                                                  ),
                                                ]
                                                : null,
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.email_outlined, size: 15),
                                          SizedBox(width: 10),
                                          Text("Email"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                //telepone
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        EmailSelected = false;
                                         _userController.clear();
                                        _passwordController.clear();
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color:
                                            !EmailSelected
                                                ? Colors.white
                                                : Colors.transparent,
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow:
                                            !EmailSelected
                                                ? [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withAlpha(300),
                                                    blurRadius: 3,
                                                  ),
                                                ]
                                                : null,
                                      ),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.email_outlined, size: 15),
                                          SizedBox(width: 10),
                                          Text("Telepon"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              TextField(
                                controller: _userController,
                                decoration: InputDecoration(
                                  hintText:
                                      EmailSelected ? "Email" : "Telepone",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),
                              TextField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 18),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(320, 50),
                                  backgroundColor: Color(0xFF02457A),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                onPressed: () {
                                  loginUser();
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(child: Divider(thickness: 1)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Text("atau"),
                                  ),
                                  Expanded(child: Divider(thickness: 1)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD6EBEE),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        final snackbar = SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(
                                                Icons.notifications_active,
                                                color: const Color.fromARGB(
                                                  255,
                                                  75,
                                                  74,
                                                  74,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Sign up for Google coming soon!",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Color(0xFFD6EBEE),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(snackbar);
                                      },
                                      icon: Image.network(
                                        'https://cdn-icons-png.flaticon.com/128/281/281764.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD6EBEE),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        final snackbar = SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(
                                                Icons.notifications_active,
                                                color: const Color.fromARGB(
                                                  255,
                                                  75,
                                                  74,
                                                  74,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Sign up for Facebook coming soon!",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Color(0xFFD6EBEE),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(snackbar);
                                      },
                                      icon: Image.network(
                                        'https://cdn-icons-png.flaticon.com/128/5968/5968764.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFD6EBEE),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        final snackbar = SnackBar(
                                          content: Row(
                                            children: [
                                              Icon(
                                                Icons.notifications_active,
                                                color: const Color.fromARGB(
                                                  255,
                                                  75,
                                                  74,
                                                  74,
                                                ),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Sign up for Apple coming soon!",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Color(0xFFD6EBEE),
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 10,
                                          ),
                                        );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(snackbar);
                                      },
                                      icon: Image.network(
                                        'https://cdn-icons-png.flaticon.com/128/0/747.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
