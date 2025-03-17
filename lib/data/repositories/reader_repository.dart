import 'package:get/get.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:inventory_platform/core/debug/logger.dart';

class ReaderRepository {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>();

  Future<List<ReaderModel>> getAllReaders() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('readers');
      Logger.info('Fetched all readers: ${result.length} items');
      return result.map((data) => ReaderModel.fromMap(data)).toList();
    } catch (e, stackTrace) {
      Logger.error('Error fetching all readers: $e', stackTrace);
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
        Logger.info('Fetched reader with mac: $mac');
        return ReaderModel.fromMap(result.first);
      }
      Logger.info('No reader found with mac: $mac');
      return null;
    } catch (e, stackTrace) {
      Logger.error('Error fetching reader by mac: $e', stackTrace);
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
      Logger.info('Added reader with mac: ${reader.mac}');
    } catch (e, stackTrace) {
      Logger.error('Error adding reader: $e', stackTrace);
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
      Logger.info('Updated reader with mac: ${updatedReader.mac}');
    } catch (e, stackTrace) {
      Logger.error('Error updating reader: $e', stackTrace);
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
      Logger.info('Deleted reader with mac: $mac');
    } catch (e, stackTrace) {
      Logger.error('Error deleting reader: $e', stackTrace);
    }
  }
}
