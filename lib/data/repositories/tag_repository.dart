import 'package:inventory_platform/data/models/tag_model.dart';

class TagRepository {
  final List<TagModel> _tags = [];

  List<TagModel> getAllTags() {
    return _tags;
  }

  TagModel? getTagById(String id) {
    return _tags.firstWhere((tag) => tag.id == id);
  }

  void addTag(TagModel tag) {
    _tags.add(tag);
  }

  void updateTag(TagModel updatedTag) {
    final index = _tags.indexWhere((tag) => tag.id == updatedTag.id);
    if (index != -1) {
      _tags[index] = updatedTag;
    }
  }

  void deleteTag(String id) {
    _tags.removeWhere((tag) => tag.id == id);
  }
}
