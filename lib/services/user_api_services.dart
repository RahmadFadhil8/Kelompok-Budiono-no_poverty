import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:no_poverty/models/user_model.dart';

class UserApiService {
  // Emulator Android → 10.0.2.2
  // HP Fisik → Ganti dengan IP komputer kamu (misal 192.168.1.22)
  final String baseUrl = "http://10.0.2.2:5000/users";

  // ==========================================
  // GET: Semua User
  // ==========================================
  Future<List<UserModel>> getAll() async {
    final url = Uri.parse(baseUrl);
    print("GET: $url");

    try {
      final res = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return (data is List)
            ? data.map((item) => UserModel.fromJson(item)).toList()
            : [];
      } else {
        print("Gagal ambil data user: ${res.body}");
        return [];
      }
    } catch (e) {
      print("Error saat ambil data user: $e");
      return [];
    }
  }

  // ==========================================
  // POST: Register User
  // ==========================================
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

      final data = jsonDecode(res.body);

      if (res.statusCode == 201) {
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception(data['message'] ?? 'Registrasi gagal');
      }
    } catch (e) {
      print("Error register: $e");
      throw Exception('Koneksi gagal: $e');
    }
  }

  // ==========================================
  // GET: User by ID
  // ==========================================
  Future<UserModel> getById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    print("GET: $url");

    try {
      final res = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print("Data user dari API: $data");
        return UserModel.fromJson(data);
      } else {
        print("Gagal ambil user ID $id: ${res.body}");
        return _emptyUser();
      }
    } catch (e) {
      print("Error saat ambil data user: $e");
      return _emptyUser();
    }
  }

  // ==========================================
  // POST: Login User
  // ==========================================
  Future<UserModel> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    print("POST: $url");

    final body = {"email": email, "password": password};

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 15));

      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        return UserModel.fromJson(data['user']);
      } else {
        throw Exception(data['message'] ?? 'Login gagal');
      }
    } catch (e) {
      print("Error login: $e");
      throw Exception('Koneksi gagal: $e');
    }
  }

  // ==========================================
  // Helper kosong (jika API gagal)
  // ==========================================
  UserModel _emptyUser() => UserModel(
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
