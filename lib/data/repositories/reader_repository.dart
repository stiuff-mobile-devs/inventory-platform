import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:sqflite/sqflite.dart';

class ReaderRepository {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>();

  Future<List<ReaderModel>> getAllReaders() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('readers');
      debugPrint('Fetched all readers: ${result.length} items');
      return result.map((data) => ReaderModel.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error fetching all readers: $e');
      return [];
    }
  }

  Future<ReaderModel?> getReaderById(String mac) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'readers',
        where: 'mac = ?',
        whereArgs: [mac],
      );
      if (result.isNotEmpty) {
        debugPrint('Fetched reader with mac: $mac');
        return ReaderModel.fromMap(result.first);
      }
      debugPrint('No reader found with mac: $mac');
      return null;
    } catch (e) {
      debugPrint('Error fetching reader by mac: $e');
      return null;
    }
  }

  Future<void> addReader(ReaderModel reader) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'readers',
        reader.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Added reader with mac: ${reader.mac}');
    } catch (e) {
      debugPrint('Error adding reader: $e');
    }
  }

  Future<void> updateReader(ReaderModel updatedReader) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'readers',
        updatedReader.toMap(),
        where: 'mac = ?',
        whereArgs: [updatedReader.mac],
      );
      debugPrint('Updated reader with mac: ${updatedReader.mac}');
    } catch (e) {
      debugPrint('Error updating reader: $e');
    }
  }

  Future<void> deleteReader(String mac) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        'readers',
        where: 'mac = ?',
        whereArgs: [mac],
      );
      debugPrint('Deleted reader with mac: $mac');
    } catch (e) {
      debugPrint('Error deleting reader: $e');
    }
  }
}
