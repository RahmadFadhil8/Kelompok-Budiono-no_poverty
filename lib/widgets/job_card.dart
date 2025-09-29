import 'package:flutter/material.dart';

// ini sementara dulu

class JobCard extends StatelessWidget {
  const JobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris atas: Judul + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Pembersihan Rumah",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Active",
                    style: TextStyle(color: Colors.green, fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Lokasi & Tanggal
            Row(
              children: const [
                Icon(Icons.location_on, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text("Surabaya",
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                SizedBox(width: 16),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text("2024-01-15",
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),

            const SizedBox(height: 16),

            // Gaji & Jumlah pelamar + Tombol Detail
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Text(
                      "Rp 150.000",
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.people, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text("8 pelamar",
                        style: TextStyle(fontSize: 13, color: Colors.grey)),
                  ],
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  onPressed: () {},
                  child: const Text("Detail"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
