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
}