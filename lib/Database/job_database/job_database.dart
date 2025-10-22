import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:no_poverty/models/job_model.dart';

class JobDatabase {
  final String baseUrl = "http://localhost:5000";

  // GET semua jobs
  Future<List<JobModel>> getJobs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jobs'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => JobModel.fromJson(e)).toList();
      } else {
        throw Exception('Gagal mengambil data jobs: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // POST job baru
  Future<JobModel> addJob(JobModel job) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/jobs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(job.toJson()), // gunakan toJson()
      );

      if (response.statusCode == 201) {
        return JobModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Gagal menambahkan job: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
