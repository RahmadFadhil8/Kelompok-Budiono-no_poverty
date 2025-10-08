import 'package:no_poverty/screens/auth/database_auth/database_service.dart';
import 'package:sqflite/sqlite_api.dart';

class TableUser {
  String TABLE = 'user';
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

  //untuk baca user(login)
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
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if (existingUser.isNotEmpty) {
      throw Exception('Email sudah terdaftar!');
    }

    return await db.insert('users', {
      'email': email,
      'nomorHP': nomorHP,
      'username': username,
      'password': password,
    });
  }
}
