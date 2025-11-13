import 'package:flutter/material.dart';
import 'package:no_poverty/services/user_api_services.dart';
import 'package:no_poverty/widgets/custom_card.dart';
import 'package:no_poverty/widgets/title1.dart';
import 'package:no_poverty/models/user_model.dart';

class DetailHelper extends StatefulWidget {
  final String userId;

  const DetailHelper({super.key, required this.userId});

  @override
  State<DetailHelper> createState() => _DetailHelperState();
}

class _DetailHelperState extends State<DetailHelper> {
  final UserApiService users = UserApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Helper")),
      body: FutureBuilder<UserModel>(
        future: users.getById(widget.userId),
        builder: (context, snapshot) {
          // === STATE LOADING ===
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // === STATE ERROR ===
          if (snapshot.hasError) {
            return Center(
              child: Text("Terjadi kesalahan: ${snapshot.error}"),
            );
          }

          // === DATA NULL / KOSONG ===
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Data helper tidak ditemukan."));
          }

          // === STATE SUKSES ===
          final data = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: CustomCard(
              padding: 16,
              childContainer: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Title1(title: "Nama: ${data.nama}"),
                  const SizedBox(height: 8),
                  Text("Nomor HP: ${data.nomorHp}"),
                  Text("Pekerjaan: ${data.pekerjaan}"),
                  Text("Lokasi: ${data.lokasi}"),
                  Text("Salary: ${data.salary}/jam"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
