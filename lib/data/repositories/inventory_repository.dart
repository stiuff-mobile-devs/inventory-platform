import 'package:get/get.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'package:inventory_platform/core/debug/logger.dart';

class InventoryRepository {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>();

  Future<List<InventoryModel>> getAllInventories() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('inventories');
      Logger.info('Fetched all inventories: ${result.length} items');
      return result.map((data) => InventoryModel.fromMap(data)).toList();
    } catch (e, stackTrace) {
      Logger.error('Error fetching all inventories: $e', stackTrace);
      return [];
    }
  }

  Future<InventoryModel?> getInventoryById(String id) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'inventories',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        Logger.info('Fetched inventory with id: $id');
        return InventoryModel.fromMap(result.first);
      }
      Logger.info('No inventory found with id: $id');
      return null;
    } catch (e, stackTrace) {
      Logger.error('Error fetching inventory by id: $e', stackTrace);
      return null;
    }
  }

  Future<void> addInventory(InventoryModel inventory) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'inventories',
        inventory.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      Logger.info('Added inventory with id: ${inventory.id}');
    } catch (e, stackTrace) {
      Logger.error('Error adding inventory: $e', stackTrace);
    }
  }

  Future<void> updateInventory(InventoryModel updatedInventory) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'inventories',
        updatedInventory.toMap(),
        where: 'id = ?',
        whereArgs: [updatedInventory.id],
      );
      Logger.info('Updated inventory with id: ${updatedInventory.id}');
    } catch (e, stackTrace) {
      Logger.error('Error updating inventory: $e', stackTrace);
    }
  }

  Future<void> deleteInventory(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        'inventories',
        where: 'id = ?',
        whereArgs: [id],
      );
      Logger.info('Deleted inventory with id: $id');
    } catch (e, stackTrace) {
      Logger.error('Error deleting inventory: $e', stackTrace);
    }
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
