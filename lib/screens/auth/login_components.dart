import 'package:flutter/material.dart';
import 'package:no_poverty/screens/auth/register.dart';
import 'package:no_poverty/screens/main_bottom_navigation.dart';
import 'package:no_poverty/services/auth_services.dart';
import 'package:no_poverty/services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      leading: Icon(Icons.storefront, size: 70, color: Colors.white),
      title: Text(
        "JobWaroeng",
        style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "Temukan Pekerjaan Harianmu",
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
    );
  }
}

class AuthToggleButton extends StatelessWidget {
  final bool isLoginSelected;

  const AuthToggleButton({super.key, required this.isLoginSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 4),
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
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
  child: GestureDetector(
    key: const Key('auth_toggle_register'),
    onTap: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const RegisterScreen()),
      );
    },
    child: const Center(
      child: Text(
        "Daftar",
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
    ),
  ),
),

        ],
      ),
    );
  }
}

class SocialLoginButtons extends StatelessWidget {
  final AuthServices authServices;
  final Function(bool) onLoading;

  const SocialLoginButtons({
    super.key,
    required this.authServices,
    required this.onLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(
          context,
          iconUrl: 'https://cdn-icons-png.flaticon.com/128/281/281764.png',
          onTap: () async {
            try {
              final result = await authServices.signInWithGoogle();
              NotificationServices.showProfileReminderNotification();
              
              if (result == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Login dibatalkan")),
                );
                return;
              }

              final isNew = result.additionalUserInfo?.isNewUser ?? false;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isNew ? "Akun baru berhasil dibuat!" : "Berhasil login!"),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainBottomNavigation()),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Login gagal: $e"), backgroundColor: Colors.red),
              );
            }
          },
        ),
        const SizedBox(width: 10),
        
        _socialButton(
          context,
          iconUrl: 'https://github.githubassets.com/assets/GitHub-Mark-ea2971cee799.png',
          onTap: () async {
            onLoading(true);
            try {
              await authServices.signInWithGitHub();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Login GitHub berhasil!"), backgroundColor: Colors.green),
              );
              
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', true);
              
              if (context.mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MainBottomNavigation()),
                );
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Login GitHub gagal: $e"), backgroundColor: Colors.red),
              );
            } finally {
              onLoading(false);
            }
          },
        ),
      ],
    );
  }

  Widget _socialButton(BuildContext context, {required String iconUrl, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD6EBEE),
        borderRadius: BorderRadius.circular(10),
      ),
      child: IconButton(
        icon: Image.network(iconUrl, width: 25, height: 25),
        onPressed: onTap,
      ),
    );
  }
}