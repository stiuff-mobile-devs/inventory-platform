import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:inventory_platform/core/debug/logger.dart';

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
      if (kIsWeb) {
        databaseFactory = databaseFactoryFfiWeb;
      }
      String path = join(await getDatabasesPath(), 'inventory_platform.db');
      Logger.info('Database path: $path');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e, stackTrace) {
      Logger.error('Error initializing database: $e', stackTrace);
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      Logger.info('Creating tables in the database');
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
        type TEXT,
        createdAt TEXT,
        attributes TEXT
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
    } catch (e, stackTrace) {
      Logger.error('Error creating tables: $e', stackTrace);
      rethrow;
    }
  }

  Future<void> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      Logger.info('Inserting into $table: $data');
      await db.insert(table, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e, stackTrace) {
      Logger.error('Error inserting into $table: $e', stackTrace);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    try {
      final db = await database;
      Logger.info('Querying all rows from $table');
      return await db.query(table);
    } catch (e, stackTrace) {
      Logger.error('Error querying all rows from $table: $e', stackTrace);
      rethrow;
    }
  }

  Future<int> update(String table, Map<String, dynamic> data, String id) async {
    try {
      final db = await database;
      Logger.info('Updating $table with id $id: $data');
      return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
    } catch (e, stackTrace) {
      Logger.error('Error updating $table with id $id: $e', stackTrace);
      rethrow;
    }
  }

  Future<int> delete(String table, String id) async {
    try {
      final db = await database;
      Logger.info('Deleting from $table with id $id');
      return await db.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch (e, stackTrace) {
      Logger.error('Error deleting from $table with id $id: $e', stackTrace);
      rethrow;
    }
  }
}
