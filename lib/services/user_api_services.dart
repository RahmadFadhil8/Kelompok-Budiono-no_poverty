import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:no_poverty/models/user_model.dart';

class UserApiService {
  // GANTI INI: Emulator Android → 10.0.2.2
  // HP Fisik → ganti jadi IP komputer kamu (misal: 192.168.1.100)
  final String baseUrl = "http://10.0.2.2:5000/users";

  Future<List<UserModel>> getAll() async {
    try {
      print("GET: $baseUrl");
      final res = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(res.body);
      return data is List
          ? data.map((item) => UserModel.fromJson(item)).toList()
          : [];
    } catch (e) {
      print("Error saat ambil data user: $e");
      return [];
    }
  }

  // Register user
  Future<UserModel> registerUser({
    required String email,
    required String username,
    required String nomorHp,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/register');
    print("POST: $url");

    final body = {
      "email": email,
      "username": username,
      "nomorHp": nomorHp,
      "password": password,
      "nama": username,
    };

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode == 201) {
        final data = jsonDecode(res.body);
        return UserModel.fromJson(data['user']);
      } else {
        final data = jsonDecode(res.body);
        throw Exception(data['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      print("Error register: $e");
      throw Exception('Koneksi gagal: $e');
    }
  }

  // Get user by ID
  Future<UserModel> getByid(String id) async {
    final url = Uri.parse("$baseUrl/$id"); // PAKAI baseUrl, bukan hardcode localhost
    print("GET: $url");

    try {
      final res = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(res.body);
      print("Data user dari API: $data");
      return UserModel.fromJson(data);
    } catch (e) {
      print("Error saat ambil data user: $e");
      return UserModel(
        id: "",
        email: "",
        nomorHp: "",
        username: "",
        password: "",
        nama: "",
        fotoKTP: "",
        lokasi: "",
        pekerjaan: "",
        salary: "",
      );
    }
  }

  // Login user
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    print("POST: $url");

    final body = {
      "email": email,
      "password": password,
    };

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return UserModel.fromJson(data['user']);
      } else {
        final data = jsonDecode(res.body);
        throw Exception(data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      print("Error login: $e");
      throw Exception('Koneksi gagal: $e');
    }
  }
}