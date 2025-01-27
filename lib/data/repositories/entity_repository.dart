import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:inventory_platform/data/models/entity_model.dart';

class EntityRepository {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>();

  Future<List<EntityModel>> getAllEntities() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('entities');
      debugPrint('Fetched all entities: ${result.length} items');
      return result.map((data) => EntityModel.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error fetching all entities: $e');
      return [];
    }
  }

  Future<EntityModel?> getEntityById(String id) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'entities',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        debugPrint('Fetched entity with id: $id');
        return EntityModel.fromMap(result.first);
      }
      debugPrint('No entity found with id: $id');
      return null;
    } catch (e) {
      debugPrint('Error fetching entity by id: $e');
      return null;
    }
  }

  Future<void> addEntity(EntityModel entity) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'entities',
        entity.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Added entity with id: ${entity.id}');
    } catch (e) {
      debugPrint('Error adding entity: $e');
    }
  }

  Future<void> updateEntity(EntityModel updatedEntity) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'entities',
        updatedEntity.toMap(),
        where: 'id = ?',
        whereArgs: [updatedEntity.id],
      );
      debugPrint('Updated entity with id: ${updatedEntity.id}');
    } catch (e) {
      debugPrint('Error updating entity: $e');
    }
  }

  Future<void> deleteEntity(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        'entities',
        where: 'id = ?',
        whereArgs: [id],
      );
      debugPrint('Deleted entity with id: $id');
    } catch (e) {
      debugPrint('Error deleting entity: $e');
    }
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
