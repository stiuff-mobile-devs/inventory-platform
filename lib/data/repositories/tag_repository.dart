import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:sqflite/sqflite.dart';

class TagRepository {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>();

  Future<List<TagModel>> getAllTags() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('tags');
      debugPrint('Fetched all tags: ${result.length} items');
      return result.map((data) => TagModel.fromMap(data)).toList();
    } catch (e) {
      debugPrint('Error fetching all tags: $e');
      return [];
    }
  }

  Future<TagModel?> getTagById(String id) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.query(
        'tags',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (result.isNotEmpty) {
        debugPrint('Fetched tag with id: $id');
        return TagModel.fromMap(result.first);
      }
      debugPrint('No tag found with id: $id');
      return null;
    } catch (e) {
      debugPrint('Error fetching tag by id: $e');
      return null;
    }
  }

  Future<void> addTag(TagModel tag) async {
    try {
      final db = await _dbHelper.database;
      await db.insert(
        'tags',
        tag.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      debugPrint('Added tag with id: ${tag.id}');
    } catch (e) {
      debugPrint('Error adding tag: $e');
    }
  }

  Future<void> updateTag(TagModel updatedTag) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'tag',
        updatedTag.toMap(),
        where: 'id = ?',
        whereArgs: [updatedTag.id],
      );
      debugPrint('Updated tag with id: ${updatedTag.id}');
    } catch (e) {
      debugPrint('Error updating tag: $e');
    }
  }

  Future<void> deleteTag(String id) async {
    try {
      final db = await _dbHelper.database;
      await db.delete(
        'tags',
        where: 'id = ?',
        whereArgs: [id],
      );
      debugPrint('Deleted tag with id: $id');
    } catch (e) {
      debugPrint('Error deleting tag: $e');
    }
  }
}
