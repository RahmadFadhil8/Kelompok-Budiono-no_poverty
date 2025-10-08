
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserDatabase {
  static final UserDatabase instance = UserDatabase._init();
  static Database? _database;
  
  UserDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      email TEXT NOT NULL UNIQUE,
      nomorHP TEXT NOT NULL,
      username TEXT NOT NULL,
      password TEXT NOT NULL
    )
    ''');
  }

  Future<int> registerUser(String email, String nomorHP, String username, String password) async {
    final db = await instance.database;
    
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
      'nomorHP' : nomorHP,
      'username': username,
      'password': password,
    });
  }

  // Get user untuk login
  Future<Map<String, dynamic>?> getUser(String email, String password) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Close database
  Future close() async {
    final db = await instance.database;
    db.close();
    
    
import 'package:no_poverty/screens/auth/database_auth/database_service.dart';
import 'package:sqflite/sqlite_api.dart';

class TableUser {
  String TABLE = 'user';
  String USERNAME = 'username' ;
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
    return await db.insert(TABLE, {'username': username, 'email': email, 'nomorHp': nomorHp, 'password':password});
  } 

  //untuk baca user(login)
  Future<bool> checkUser(String input, String password, bool isEmail ) async {
    Database db = await databaseService.getDatabase();
    List<Map<String, dynamic>> result = await db.query(
      TABLE,
      where: isEmail? 'email = ? AND password =?' : 'nomorHp = ? AND password =?',
      whereArgs: [input, password],
    );
    return result.isNotEmpty;
  }
}