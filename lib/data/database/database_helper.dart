import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'inventory_platform.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE readers (
      id TEXT PRIMARY KEY,
      name TEXT,
      mac TEXT,
      isActive INTEGER,
      createdAt TEXT,
      lastSeen TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE domains (
      id TEXT PRIMARY KEY,
      title TEXT,
      isActive INTEGER,
      description TEXT,
      location TEXT,
      capacity INTEGER,
      createdAt TEXT,
      lastUpdatedAt TEXT,
      attributes TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE entities (
      id TEXT PRIMARY KEY,
      name TEXT,
      domainId TEXT,
      FOREIGN KEY (domainId) REFERENCES domain_model (id)
    )
  ''');

    await db.execute('''
    CREATE TABLE inventories (
      id TEXT PRIMARY KEY,
      name TEXT,
      entityId TEXT,
      FOREIGN KEY (entityId) REFERENCES entity_model (id)
    )
  ''');

    await db.execute('''
    CREATE TABLE materials (
      id TEXT PRIMARY KEY,
      name TEXT,
      inventoryId TEXT,
      FOREIGN KEY (inventoryId) REFERENCES inventory_model (id)
    )
  ''');

    await db.execute('''
    CREATE TABLE members (
      id TEXT PRIMARY KEY,
      name TEXT,
      organizationId TEXT,
      FOREIGN KEY (organizationId) REFERENCES organization_model (id)
    )
  ''');

    await db.execute('''
    CREATE TABLE organizations (
      id TEXT PRIMARY KEY,
      name TEXT
    )
  ''');

    await db.execute('''
    CREATE TABLE tags (
      id TEXT PRIMARY KEY,
      name TEXT,
      materialId TEXT,
      FOREIGN KEY (materialId) REFERENCES material_model (id)
    )
  ''');

    await db.execute('''
    CREATE TABLE users (
      id TEXT PRIMARY KEY,
      username TEXT,
      password TEXT,
      memberId TEXT,
      FOREIGN KEY (memberId) REFERENCES member_model (id)
    )
  ''');
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    final db = await database;
    return await db.query(table);
  }

  Future<int> update(String table, Map<String, dynamic> data, String id) async {
    final db = await database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(String table, String id) async {
    final db = await database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
}
