import 'package:no_poverty/Database/database_Service.dart';
import 'package:no_poverty/models/job_model.dart';
import 'package:sqflite/sqflite.dart';

class JobDatabase {
  String TABLE = 'jobs';

  DatabaseService databaseService = DatabaseService();

  Future<List<JobModel>> getJobs() async {
    try {
      Database db = await databaseService.getDatabase();
      var res = await db.rawQuery('''
    SELECT 
      jobs.id,
      jobs.title,
      jobs.description,
      jobs.salary,
      jobs.location,
      jobs.date,
      jobs.userId,
      users.username
    FROM jobs
    JOIN users ON jobs.userId = users.id
  ''');
      final List<JobModel> datas =
          res.map((e) {
            return JobModel.fromJson(e);
          }).toList();
      return datas;
    } catch (e) {
      rethrow;
    }
  }
}
