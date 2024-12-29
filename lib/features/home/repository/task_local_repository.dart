import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_app/model/task_model.dart';

class TaskLocalRepository {
  String tableName = "tasks";

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "tasks.db");
    return openDatabase(path, version: 2,
        onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < newVersion) {
        await db.execute(
            'ALTER TABLE $tableName AND COLUMN isSynced INTEGER NOT NULL');
      }
    }, onCreate: (db, version) {
      return db.execute('''
          CREATE TABLE $tableName(
           id TEXT PRIMARY KEY,
           title TEXT NOT NULL,
           description TEXT NOT NULL,
           uid TEXT NOT NULL,
           hexColor TEXT NOT NULL,
           dueAt TEXT NOT NULL,
           createdAt TEXT NOT NULL,
           updatedAt TEXT NOT NULL,
           isSynced INTEGER NOT NULL
          )
          ''');
    });
  }

  Future<void> insertTask(TaskModel tasks) async {
    final db = await database;
    await db.delete(tableName, where: 'id = ?', whereArgs: [tasks.id]);
    db.insert(tableName, tasks.toMap());
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();

    for (final task in tasks) {
      batch.insert(tableName, task.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final result = await db.query(tableName);

    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];

      for (final elem in result) {
        tasks.add(TaskModel.fromMap(elem));
      }

      return tasks;
    }

    return [];
  }

  Future<List<TaskModel>> getUnsyncedTasks() async {
    final db = await database;
    final result =
        await db.query(tableName, where: 'isSynced=?', whereArgs: [0]);

    if (result.isNotEmpty) {
      List<TaskModel> tasks = [];

      for (final elem in result) {
        tasks.add(TaskModel.fromMap(elem));
      }

      return tasks;
    }

    return [];
  }
}
