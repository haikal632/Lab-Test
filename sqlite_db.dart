import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteDB {
  static const String _dbName = 'bitp3453_bmi';

  Database? _db;

  SQLiteDB._();
  static final SQLiteDB _instance = SQLiteDB._();

  factory SQLiteDB() {
    return _instance;
  }

  Future<Database> get database async {
    if (_db != null) {
      return _db!;
    }
    String path = join(await getDatabasesPath(), _dbName);
    _db = await openDatabase(path, version: 1, onCreate: (createdDb, version) async {
      for (String tableSql in SQLiteDB.tableSQLStrings) {
        await createdDb.execute(tableSql);
      }
    });
    return _db!;
  }

  static List<String> tableSQLStrings = [
    '''
    CREATE TABLE IF NOT EXISTS expense (
    id INTEGER PRIMARY KEY AUTOINCREMENT, 
    username TEXT,
    weight REAL,
    height REAL,
    gender INTEGER,
    bmi_status TEXT)
    '''
  ];

  Future<int> insert(String tableName, Map<String, dynamic> row) async {
    try {
      Database db = await _instance.database;
      return await db.insert(tableName, row);
    } catch (e) {
      print("Error inserting data: $e");
      return -1; // Return -1 to indicate an error
    }
  }

  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    try {
      Database db = await _instance.database;
      return await db.query(tableName);
    } catch (e) {
      print("Error querying data: $e");
      return [];
    }
  }

  Future<int> update(String tableName, String idColumn, Map<String, dynamic> row) async {
    try {
      Database db = await _instance.database;
      dynamic id = row[idColumn];
      return await db.update(tableName, row, where: '$idColumn = ?', whereArgs: [id]);
    } catch (e) {
      print("Error updating data: $e");
      return -1;
    }
  }

  Future<int> delete(String tableName, String idColumn, dynamic idValue) async {
    try {
      Database db = await _instance.database;
      return await db.delete(tableName, where: '$idColumn = ?', whereArgs: [idValue]);
    } catch (e) {
      print("Error deleting data: $e");
      return -1;
    }
  }
}