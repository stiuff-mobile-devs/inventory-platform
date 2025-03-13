import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:inventory_platform/data/models/entity_model.dart';
import 'package:inventory_platform/core/debug/logger.dart';

class EntityRepository {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>();

  Future<List<EntityModel>> getAllEntities() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('entities');
      Logger.info('Fetched all entities: ${result.length} items');
      return result.map((data) => EntityModel.fromMap(data)).toList();
    } catch (e, stackTrace) {
      Logger.error('Error fetching all entities: $e', stackTrace);
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
        Logger.info('Fetched entity with id: $id');
        return EntityModel.fromMap(result.first);
      }
      Logger.info('No entity found with id: $id');
      return null;
    } catch (e, stackTrace) {
      Logger.error('Error fetching entity by id: $e', stackTrace);
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
      Logger.info('Added entity with id: ${entity.id}');
    } catch (e, stackTrace) {
      Logger.error('Error adding entity: $e', stackTrace);
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
      Logger.info('Updated entity with id: ${updatedEntity.id}');
    } catch (e, stackTrace) {
      Logger.error('Error updating entity: $e', stackTrace);
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
      Logger.info('Deleted entity with id: $id');
    } catch (e, stackTrace) {
      Logger.error('Error deleting entity: $e', stackTrace);
    }
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
