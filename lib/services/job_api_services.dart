import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:no_poverty/models/job_model.dart';

class JobAPIServices {
  Future<JobModel> create(
    String userId,
    String judulPekerjaan, 
    String kategori, 
    String deskripsi, 
    String alamat, 
    String budget, 
    int jumlahHelper,
    String tanggal, 
    String waktu, 
    bool izinkanTawarMenawar
  ) async {
    try {
      var res = await http.post(
        Uri.parse('http://localhost:5000/jobs/tambahjob'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'judulPekerjaan': judulPekerjaan, 
          'kategori': kategori,
          'deskripsi': deskripsi,
          'alamat': alamat,
          'tanggal': tanggal,
          'waktu': waktu,
          'jumlahHelper': jumlahHelper,
          'budget': budget,
          'izinkanTawarMenawar': izinkanTawarMenawar,
        })
      );
      print('Response body: ${res.body}');
      final datafinal = jsonDecode(res.body);
      return JobModel.fromJson(datafinal);
    } catch (e) {
      rethrow;
    }
  }
}