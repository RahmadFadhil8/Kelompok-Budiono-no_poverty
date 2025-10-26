import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:no_poverty/models/user_model.dart';

class UserApiService {
  final String baseUrl = "http://localhost:5000/users"; // ganti sesuai IP/device

  // 🔹 Register user
  Future<UserModel> registerUser({
    required String email,
    required String username,
    required String nomorHp,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');

    final body = {
      "email": email,
      "username": username,
      "nomorHp": nomorHp,
      "password": password,
      "nama": username, // backend butuh nama
    };

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode == 201) {
      final data = jsonDecode(res.body);
      return UserModel.fromJson(data['user']);
    } else {
      final data = jsonDecode(res.body);
      throw Exception(data['message'] ?? 'Registrasi gagal');
    }
  }

  // 🔹 Login user
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final body = {
      "email": email,
      "password": password,
    };

    final res = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return UserModel.fromJson(data['user']);
    } else {
      final data = jsonDecode(res.body);
      throw Exception(data['message'] ?? 'Login gagal');
    }
  }
}
