import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';

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
    try {
      String path = join(await getDatabasesPath(), 'inventory_platform.db');
      debugPrint('Initializing database at path: $path');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      debugPrint('Error initializing database: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      debugPrint('Creating tables in the database');
      await db.execute('''
      CREATE TABLE readers (
        mac TEXT PRIMARY KEY,
        name TEXT,
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
        title TEXT,
        description TEXT,
        isActive INTEGER,
        openedAt TEXT,
        lastUpdatedAt TEXT,
        revisionNumber TEXT
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
        isActive INTEGER,
        lastSeen TEXT,
        createdAt TEXT
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
    } catch (e) {
      debugPrint('Error creating tables: $e');
      rethrow;
    }
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      debugPrint('Inserting into $table: $data');
      await db.insert(table, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      debugPrint('Error inserting into $table: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    try {
      final db = await database;
      debugPrint('Querying all rows from $table');
      return await db.query(table);
    } catch (e) {
      debugPrint('Error querying all rows from $table: $e');
      rethrow;
    }
  }

  Future<int> update(String table, Map<String, dynamic> data, String id) async {
    try {
      final db = await database;
      debugPrint('Updating $table with id $id: $data');
      return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error updating $table with id $id: $e');
      rethrow;
    }
  }

  Future<int> delete(String table, String id) async {
    try {
      final db = await database;
      debugPrint('Deleting from $table with id $id');
      return await db.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      debugPrint('Error deleting from $table with id $id: $e');
      rethrow;
    }
  }
}
