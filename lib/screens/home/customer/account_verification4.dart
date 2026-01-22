import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:no_poverty/services/user_profile_services.dart';
import 'package:no_poverty/models/user_model_fix.dart';
import 'package:no_poverty/screens/main_bottom_navigation.dart';

class AccountVerificationStep4 extends StatefulWidget {
  final bool isPremiumSelected;

  const AccountVerificationStep4({super.key, required this.isPremiumSelected});

  @override
  State<AccountVerificationStep4> createState() =>
      _AccountVerificationStep4State();
}

class _AccountVerificationStep4State extends State<AccountVerificationStep4> {
  bool _isLoading = false;

  Future<void> _submitVerification() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;

      final data = {"verified": true};

      await UserProfileServices()
          .editUserProfile(UserModelFix.fromMap(user.uid, data));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainBottomNavigation()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal submit verifikasi: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildMainUI(),

        if (_isLoading)
          Container(
            color: Colors.black.withOpacity(0.45),
            child: const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildMainUI() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Verifikasi Akun"),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                "Step 4/4",
                style: TextStyle(fontSize: 14, color: Colors.blue),
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            LinearProgressIndicator(value: 1.0, minHeight: 6),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("100% selesai", style: TextStyle(color: Colors.grey)),
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(Icons.check_circle, size: 48, color: Colors.blue.shade700),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Review",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Verifikasi dokumen",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Review Dokumen",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildStatusItem("KTP", true),
                      _buildStatusItem("SKCK", true),

                      if (widget.isPremiumSelected)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade50,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.amber.shade300),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.verified, color: Colors.amber.shade700, size: 20),
                              const SizedBox(width: 12),
                              const Text(
                                "Background Check Premium",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const Spacer(),
                              Text(
                                "Rp 50.000",
                                style: TextStyle(color: Colors.amber.shade700, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Estimasi waktu 1-3 hari kerja untuk verifikasi lengkap.",
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Kembali"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _submitVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Submit Verifikasi", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, bool isReady) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green.shade400, size: 20),
          const SizedBox(width: 12),
          Text(title),
          const Spacer(),
          Text(
            "Ready",
            style: TextStyle(color: Colors.green.shade600, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
