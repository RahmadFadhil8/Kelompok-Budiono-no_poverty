import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'firebase_options.dart';
import 'app_wrapper.dart';
import 'provider/chatbot_provider.dart';
import 'models/user_model_fix.dart';
import 'services/user_profile_services.dart';
import 'services/notification_services.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Supabase.initialize(
    url: 'https://rxrdxiluiipvixhmaxms.supabase.co',
    anonKey: 'sb_publishable_CWlG8-5CWNSQ_cRQJFU8qw_XVoufF6V',
  );

  // 🔴 INI WAJIB
  await NotificationServices.initialize(navigatorKey);

  unawaited(MobileAds.instance.initialize());

  await ChatbotProvider().initialMsgAI();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatbotProvider()),
        StreamProvider<UserModelFix?>(
          create: (_) => UserProfileServices().getUserProfile(),
          initialData: null,
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // 🔴 INI KUNCI
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      // THEME KAMU — TIDAK DIUBAH
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        primaryColor: const Color(0xFF4C8BF5),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF4C8BF5),
          secondary: Color(0xFF4C8BF5),
          onPrimary: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFFD0D7E2), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide:
                const BorderSide(color: Color(0xFF4C8BF5), width: 2),
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          labelStyle: const TextStyle(color: Color(0xFF6C7A91)),
        ),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF4C8BF5),
          selectionColor: Color(0x334C8BF5),
          selectionHandleColor: Color(0xFF4C8BF5),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF4C8BF5),
            foregroundColor: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF4C8BF5)),
            foregroundColor: const Color(0xFF4C8BF5),
          ),
        ),
        iconTheme:
            const IconThemeData(color: Color(0xFF4C8BF5)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          surfaceTintColor: Colors.white,
          elevation: 0,
        ),
      ),

      home: AppWrapper(),
    );
  }
}
