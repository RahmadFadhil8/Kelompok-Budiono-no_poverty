import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:no_poverty/models/user_model.dart';

class UserApiService {
  final String baseUrl = "http://localhost:5000/users"; // ganti sesuai IP/device

  Future <List<UserModel>> getAll () async {
    try {
      final res = await http.get(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'}
      );
      final data = jsonDecode(res.body);
      return data is List ? data.map((item) {return UserModel.fromJson(item);}).toList() : [];
    } catch (e) {
      print("error saat ambil data user: ${e}");
      return [];
    }
  }
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

  Future <UserModel> getByid (String id) async{
    try {
      final res = await http.get(
        Uri.parse("http://localhost:5000/users/${id}"),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(res.body);
      print("Data user dari API: $data");
      return UserModel.fromJson(data); 
    } catch (e) {
      print("eror saat ambil data user: ${e}");
      return UserModel(
        id: "", 
        email: "", 
        nomorHp: "", 
        username: "", 
        password: "", 
        nama: "", 
        lokasi: "", 
        pekerjaan: "", 
        salary: ""
      );
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
