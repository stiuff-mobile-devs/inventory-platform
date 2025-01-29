import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class InventoryRepository {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>();

  Future<List<InventoryModel>> getAllInventories() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('inventories');
      debugPrint('Fetched all inventories: ${result.length} items');
      return result.map((data) => InventoryModel.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error fetching all inventories: $e');
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
        debugPrint('Fetched inventory with id: $id');
        return InventoryModel.fromMap(result.first);
      }
      debugPrint('No inventory found with id: $id');
      return null;
    } catch (e) {
      debugPrint('Error fetching inventory by id: $e');
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
      debugPrint('Added inventory with id: ${inventory.id}');
    } catch (e) {
      debugPrint('Error adding inventory: $e');
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
      debugPrint('Updated inventory with id: ${updatedInventory.id}');
    } catch (e) {
      debugPrint('Error updating inventory: $e');
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
      debugPrint('Deleted inventory with id: $id');
    } catch (e) {
      debugPrint('Error deleting inventory: $e');
    }
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    return uuid.v4();
  }
}
