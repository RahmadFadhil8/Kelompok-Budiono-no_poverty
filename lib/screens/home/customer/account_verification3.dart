import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'account_verification4.dart'; // ← SUDAH TERHUBUNG KE STEP 4

class AccountVerificationStep3 extends StatefulWidget {
  const AccountVerificationStep3({super.key});

  @override
  State<AccountVerificationStep3> createState() => _AccountVerificationStep3State();
}

class _AccountVerificationStep3State extends State<AccountVerificationStep3> {
  File? _stnkImage;
  bool _isPremiumChecked = false;

  final ImagePicker picker = ImagePicker();

  Future<void> _pickStnk() async {
    final status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Izin akses galeri diperlukan")),
      );
      return;
    }

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _stnkImage = File(image.path));
    }
  }

  bool get _canContinue => true;

  @override
  Widget build(BuildContext context) {
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
                "Step 3/4",
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
            LinearProgressIndicator(value: 0.75, minHeight: 6),
            const SizedBox(height: 8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("75% selesai", style: TextStyle(color: Colors.grey)),
              ),
            ),
            const SizedBox(height: 40),

            // Card Utama
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
                        child: Icon(Icons.verified_user, size: 48, color: Colors.blue.shade700),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Dokumen Tambahan",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Bukti kendaraan & background check",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Bukti Kendaraan (Opsional)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Bukti Kendaraan (Opsional)",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Upload STNK jika Anda memiliki kendaraan untuk job transport",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _pickStnk,
                        child: Container(
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300, width: 2),
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.grey[50],
                          ),
                          child: _stnkImage == null
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.upload, size: 40, color: Colors.grey),
                                    SizedBox(height: 12),
                                    Text(
                                      "Upload STNK (Opsional)",
                                      style: TextStyle(color: Colors.grey, fontSize: 15),
                                    ),
                                  ],
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(_stnkImage!, fit: BoxFit.cover),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Background Check Premium
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Background Check Premium",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Verifikasi tambahan untuk meningkatkan kepercayaan customer (Biaya: Rp 50.000)",
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _isPremiumChecked = !_isPremiumChecked;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _isPremiumChecked ? Colors.blue.shade50 : Colors.white,
                            side: BorderSide(
                              color: _isPremiumChecked ? Colors.blue : Colors.grey.shade400,
                              width: 2,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          child: Text(
                            _isPremiumChecked ? "Dipilih" : "Pilih Background Check",
                            style: TextStyle(
                              color: _isPremiumChecked ? Colors.blue : Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Tombol Kembali & Lanjut
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
                        foregroundColor: Colors.black, // WARNA HITAM SESUAI PERMINTAAN
                      ),
                      child: const Text("Kembali"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _canContinue
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AccountVerificationStep4(
                                    isPremiumSelected: _isPremiumChecked, // ← KIRIM STATUS KE STEP 4
                                  ),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: const Text("Lanjut", style: TextStyle(color: Colors.white, fontSize: 16)),
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