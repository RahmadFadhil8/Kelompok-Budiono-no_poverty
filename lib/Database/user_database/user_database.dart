import 'package:no_poverty/models/user_model.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:no_poverty/Database/database_Service.dart';

class TableUser {
  String TABLE = 'users';
  String USERNAME = 'username';
  String EMAIL = 'email';
  String PHONE = 'nomorHp';
  String PASSWORD = 'password';

  DatabaseService databaseService = DatabaseService();

  Future<int> insertUser({
    required String username,
    required String email,
    required String nomorHp,
    required String password,
  }) async {
    Database db = await databaseService.getDatabase();
    return await db.insert(TABLE, {
      'username': username,
      'email': email,
      'nomorHp': nomorHp,
      'password': password,
    });
  }

  Future<bool> checkUser(String input, String password, bool isEmail) async {
    Database db = await databaseService.getDatabase();
    List<Map<String, dynamic>> result = await db.query(
      TABLE,
      where:
          isEmail ? 'email = ? AND password =?' : 'nomorHp = ? AND password =?',
      whereArgs: [input, password],
    );
    return result.isNotEmpty;
  }

  Future<int> registerUser(
    String email,
    String nomorHP,
    String username,
    String password,
  ) async {
    Database db = await databaseService.getDatabase();

    final existingUser = await db.query(
      TABLE,
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUser.isNotEmpty) {
      throw Exception('Email sudah terdaftar!');
    }

    return await db.insert('users', {
      'email': email,
      'nomorHp': nomorHP,
      'username': username,
      'password': password,
    });
  }

  Future<UserModel> getCurrentUser(int id) async {
    try {
      Database db = await databaseService.getDatabase();
      var res = await db.query(TABLE, where: 'id = ?', whereArgs: [id]);
      return UserModel.fromJson(res[0]);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getUsers() async {
    try {
      Database db = await databaseService.getDatabase();
      var res = await db.query(TABLE);
      final List<UserModel> datas =
          res.map((e) {
            return UserModel.fromJson(e);
          }).toList();
      return datas;
    } catch (e) {
      rethrow;
    }
  }
}
