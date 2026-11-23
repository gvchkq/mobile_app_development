import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider instance = DBProvider._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final documentsDirectory =
        await getApplicationDocumentsDirectory();

    final pathDB = join(
      documentsDirectory.path,
      'calculations.db',
    );

    return await openDatabase(
      pathDB,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE calculations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        capital REAL NOT NULL,
        time REAL NOT NULL,
        rate REAL NOT NULL,
        interest REAL NOT NULL,
        total REAL NOT NULL,
        date TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertCalculation(Map<String, dynamic> data) async {
    final db = await database;

    return await db.insert(
      'calculations',
      data,
    );
  }

  Future<List<Map<String, dynamic>>> getAllCalculations() async {
    final db = await database;

    return await db.query(
      'calculations',
      orderBy: 'id DESC',
    );
  }
}