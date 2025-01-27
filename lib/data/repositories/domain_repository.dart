import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:inventory_platform/data/models/domain_model.dart';

class DomainRepository {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>();

  Future<List<DomainModel>> getAllDomains() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('domains');
      debugPrint('Fetched all domains: ${result.length} items');
      return result.map((data) => DomainModel.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error fetching all domains: $e');
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
        debugPrint('Fetched domain with id: $id');
        return DomainModel.fromMap(result.first);
      }
      debugPrint('No domain found with id: $id');
      return null;
    } catch (e) {
      debugPrint('Error fetching domain by id: $e');
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
      debugPrint('Added domain with id: ${domain.id}');
    } catch (e) {
      debugPrint('Error adding domain: $e');
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
      debugPrint('Updated domain with id: ${updatedDomain.id}');
    } catch (e) {
      debugPrint('Error updating domain: $e');
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
      debugPrint('Deleted domain with id: $id');
    } catch (e) {
      debugPrint('Error deleting domain: $e');
    }
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
