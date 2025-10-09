import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? database;
  static String DB_NAME = "job_waroeng.db";
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
      onCreate: onCreateDatabase,
    );
  }

  Future<void> onCreateDatabase(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users (id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT NOT NULL, email TEXT, nomorHp TEXT, password TEXT NOT NULL)',
    );
    await db.execute(
      'CREATE TABLE jobs (id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER,title TEXT NOT NULL, description TEXT, salary TEXT, location TEXT, date TEXT,isDone INTEGER NOT NULL)',
    );

    await db.insert('users', {
      'username': 'andi123',
      'email': 'andi@gmail.com',
      'nomorHp': '081234567890',
      'password': 'passAndi',
    });
    await db.insert('users', {
      'username': 'budi99',
      'email': 'budi@yahoo.com',
      'nomorHp': '082345678901',
      'password': 'passBudi',
    });
    await db.insert('users', {
      'username': 'citra01',
      'email': 'citra01@gmail.com',
      'nomorHp': '083456789012',
      'password': 'passCitra',
    });
    await db.insert('users', {
      'username': 'dimasx',
      'email': 'dimasx@outlook.com',
      'nomorHp': '084567890123',
      'password': 'passDimas',
    });
    await db.insert('users', {
      'username': 'elina_dev',
      'email': 'elina.dev@gmail.com',
      'nomorHp': '085678901234',
      'password': 'passElina',
    });

    await db.insert('jobs', {
      'userId': 1,
      'title': 'Kasir Minimarket',
      'description': 'Melayani pelanggan dan mencatat transaksi harian.',
      'salary': '2500000',
      'location': 'Jakarta',
      'date': '2025-10-01',
      'isDone': 0,
    });

    await db.insert('jobs', {
      'userId': 1,
      'title': 'Barista Kopi',
      'description': 'Membuat dan menyajikan minuman kopi.',
      'salary': '3000000',
      'location': 'Bandung',
      'date': '2025-09-28',
      'isDone': 0,
    });

    await db.insert('jobs', {
      'userId': 2,
      'title': 'Staff Gudang',
      'description': 'Mengatur keluar masuk barang di gudang.',
      'salary': '2800000',
      'location': 'Surabaya',
      'date': '2025-09-25',
      'isDone': 1,
    });

    await db.insert('jobs', {
      'userId': 3,
      'title': 'Kurir Motor',
      'description': 'Mengantarkan paket ke pelanggan area kota.',
      'salary': '2700000',
      'location': 'Semarang',
      'date': '2025-10-02',
      'isDone': 0,
    });

    await db.insert('jobs', {
      'userId': 2,
      'title': 'Admin Sosial Media',
      'description': 'Mengelola konten dan interaksi akun bisnis.',
      'salary': '3500000',
      'location': 'Jakarta',
      'date': '2025-09-30',
      'isDone': 1,
    });

    await db.insert('jobs', {
      'userId': 4,
      'title': 'Desainer Grafis',
      'description': 'Membuat desain banner dan materi promosi.',
      'salary': '4000000',
      'location': 'Yogyakarta',
      'date': '2025-09-29',
      'isDone': 0,
    });

    await db.insert('jobs', {
      'userId': 5,
      'title': 'Operator Produksi',
      'description': 'Mengoperasikan mesin produksi pabrik.',
      'salary': '3200000',
      'location': 'Bekasi',
      'date': '2025-09-27',
      'isDone': 1,
    });

    await db.insert('jobs', {
      'userId': 3,
      'title': 'Cleaning Service',
      'description': 'Membersihkan area kantor dan fasilitas umum.',
      'salary': '2500000',
      'location': 'Bogor',
      'date': '2025-09-26',
      'isDone': 0,
    });

    await db.insert('jobs', {
      'userId': 5,
      'title': 'Penjaga Toko',
      'description': 'Menjaga toko dan melayani pembeli.',
      'salary': '2600000',
      'location': 'Depok',
      'date': '2025-09-28',
      'isDone': 0,
    });

    await db.insert('jobs', {
      'userId': 2,
      'title': 'Driver Mobil',
      'description': 'Mengemudi untuk mengantar barang ke pelanggan.',
      'salary': '3500000',
      'location': 'Tangerang',
      'date': '2025-09-30',
      'isDone': 1,
    });
  }
}
