import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:no_poverty/models/user_model_fix.dart';
import 'package:no_poverty/screens/home/customer/account_verification4.dart';
import 'package:no_poverty/services/user_profile_services.dart';
import 'package:no_poverty/utils/permission_utils.dart';

class AccountVerificationStep2 extends StatefulWidget {
  const AccountVerificationStep2({super.key});

  @override
  State<AccountVerificationStep2> createState() => _AccountVerificationStep2State();
}

class _AccountVerificationStep2State extends State<AccountVerificationStep2> {
  File? _skckImage;
  bool _isLoading = false;

  Future<void> _pickSkck() async {
    final XFile? image = await PermissionUtils.pickFromGallery();
    if (image != null) {
      setState(() => _skckImage = File(image.path));
    }
  }

  bool get _canContinue => _skckImage != null && !_isLoading;

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;

      final skckUrl = await UserProfileServices()
          .uploadUserImage(user.uid, _skckImage!);

      final data = {"skck_url": skckUrl};

      await UserProfileServices()
          .editUserProfile(UserModelFix.fromMap(user.uid, data));

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AccountVerificationStep4(isPremiumSelected: false,)),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal upload SKCK: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
              child: Text("Step 2/4",
                  style: TextStyle(fontSize: 14, color: Colors.blue)),
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
            LinearProgressIndicator(value: 0.5, minHeight: 6),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("50% selesai",
                    style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 40),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.blue.shade50,
                        child: Icon(Icons.description,
                            size: 48, color: Colors.blue.shade700),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "SKCK",
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Upload Surat Keterangan Catatan Kepolisian",
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Upload SKCK",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _isLoading ? null : _pickSkck,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.shade300, width: 2),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[50],
                      ),
                      child: _skckImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.description_outlined,
                                    size: 50, color: Colors.grey),
                                SizedBox(height: 12),
                                Text("Upload SKCK (PDF/JPG)",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(_skckImage!,
                                  fit: BoxFit.cover),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        foregroundColor: Colors.black,
                      ),
                      child: const Text("Kembali"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canContinue ? _submit : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canContinue
                            ? Colors.blue
                            : Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Lanjut",
                          style: TextStyle(color: Colors.white)),
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
}
