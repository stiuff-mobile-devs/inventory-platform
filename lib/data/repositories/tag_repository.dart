import 'package:get/get.dart';
import 'package:inventory_platform/data/database/database_helper.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:inventory_platform/core/debug/logger.dart';

class TagRepository {
  final DatabaseHelper _dbHelper = Get.find<DatabaseHelper>();

  Future<List<TagModel>> getAllTags() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.query('tags');
      Logger.info('Fetched all tags: ${result.length} items');
      return result.map((data) => TagModel.fromMap(data)).toList();
    } catch (e, stackTrace) {
      Logger.error('Error fetching all tags: $e', stackTrace);
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
        Logger.info('Fetched tag with id: $id');
        return TagModel.fromMap(result.first);
      }
      Logger.info('No tag found with id: $id');
      return null;
    } catch (e, stackTrace) {
      Logger.error('Error fetching tag by id: $e', stackTrace);
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
      Logger.info('Added tag with id: ${tag.id}');
    } catch (e, stackTrace) {
      Logger.error('Error adding tag: $e', stackTrace);
    }
  }

  Future<void> updateTag(TagModel updatedTag) async {
    try {
      final db = await _dbHelper.database;
      await db.update(
        'tags',
        updatedTag.toMap(),
        where: 'id = ?',
        whereArgs: [updatedTag.id],
      );
      Logger.info('Updated tag with id: ${updatedTag.id}');
    } catch (e, stackTrace) {
      Logger.error('Error updating tag: $e', stackTrace);
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
      Logger.info('Deleted tag with id: $id');
    } catch (e, stackTrace) {
      Logger.error('Error deleting tag: $e', stackTrace);
    }
  }
}
