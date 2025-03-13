import 'package:get/get.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/core/debug/logger.dart';

class DomainRepository {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>();

  Future<List<DomainModel>> getAllDomains() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('domains');
      Logger.info('Fetched all domains: ${result.length} items');
      return result.map((data) => DomainModel.fromMap(data)).toList();
    } catch (e, stackTrace) {
      Logger.error('Error fetching all domains: $e', stackTrace);
      return [];
    }
  }

  Future<DomainModel?> getDomainById(String id) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'domains',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        Logger.info('Fetched domain with id: $id');
        return DomainModel.fromMap(result.first);
      }
      Logger.info('No domain found with id: $id');
      return null;
    } catch (e, stackTrace) {
      Logger.error('Error fetching domain by id: $e', stackTrace);
      return null;
    }
  }

  Future<void> addDomain(DomainModel domain) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'domains',
        domain.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      Logger.info('Added domain with id: ${domain.id}');
    } catch (e, stackTrace) {
      Logger.error('Error adding domain: $e', stackTrace);
    }
  }

  Future<void> updateDomain(DomainModel updatedDomain) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'domains',
        updatedDomain.toMap(),
        where: 'id = ?',
        whereArgs: [updatedDomain.id],
      );
      Logger.info('Updated domain with id: ${updatedDomain.id}');
    } catch (e, stackTrace) {
      Logger.error('Error updating domain: $e', stackTrace);
    }
  }

  Future<void> deleteDomain(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        'domains',
        where: 'id = ?',
        whereArgs: [id],
      );
      Logger.info('Deleted domain with id: $id');
    } catch (e, stackTrace) {
      Logger.error('Error deleting domain: $e', stackTrace);
    }
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
