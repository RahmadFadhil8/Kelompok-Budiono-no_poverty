import 'package:flutter/material.dart';
import 'package:no_poverty/app_wrapper.dart';
import 'package:no_poverty/provider/chatbot_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(ChangeNotifierProvider(
  create: (_) => ChatbotProvider(),
  child: const MyApp(),
));

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          brightness: Brightness.light,
          primary: Colors.white,
          onPrimary: Colors.black,
          background: Colors.white,
          onBackground: Colors.black,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
          titleLarge: TextStyle(color: Colors.black),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: 
          AppWrapper(),
    );
  }
}
