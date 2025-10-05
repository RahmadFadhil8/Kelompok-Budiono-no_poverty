import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? database;
  static String DB_NAME = "user.db";
  static int DB_VERSION = 1;

  Future<Database> getDatabase() async {
    if (database != null) {
      return database!;
  }
  database = await initDatabase();
  return database!;
}

Future<Database> initDatabase() async {
  String dbPath = await getDatabasesPath();
  String path = join(dbPath, DB_NAME);
  return await openDatabase(
    path,
    version: DB_VERSION,
    onCreate: onCreateDatabase
    );
}
Future<void>onCreateDatabase(Database db, int version) async {
  await db.execute(
    'CREATE TABLE user (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT NOT NULL, email TEXT, nomorHp TEXT, password TEXT NOT NULL)'
  );
}
}
