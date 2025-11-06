import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:no_poverty/models/user_model.dart';

class UserAPIServices {
  Future <List<UserModel>> getAll () async{
    try {
      final res = await http.get(
        Uri.parse("http://localhost:5000/users"),
        headers: {'Content-Type': 'application/json'},
      );
      final data = jsonDecode(res.body);
      print(data);
      return data is List ? data.map((item) {return UserModel.fromJson(item);}).toList() : []; 
    } catch (e) {
      print("eror saat ambil data user: ${e}");
      return [];
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
        fotoKTP: "", 
        lokasi: "", 
        pekerjaan: "", 
        salary: ""
      );
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:5000/users/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else {
        print("Login gagal: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Terjadi kesalahan saat login: $e");
      return null;
    }
  }
}