import 'package:uuid/uuid.dart';
import 'package:inventory_platform/data/models/entity_model.dart';

class EntityRepository {
  final List<EntityModel> _entities = [];

  List<EntityModel> getAllEntities() {
    return _entities;
  }

  EntityModel? getEntityById(String id) {
    return _entities.firstWhere((entity) => entity.id == id);
  }

  void addEntity(EntityModel entity) {
    _entities.add(entity);
  }

  void updateEntity(EntityModel updatedEntity) {
    final index =
        _entities.indexWhere((entity) => entity.id == updatedEntity.id);
    if (index != -1) {
      _entities[index] = updatedEntity;
    }
  }

  void deleteEntity(String id) {
    _entities.removeWhere((entity) => entity.id == id);
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    String id;
    do {
      id = uuid.v4();
    } while (_entities.any((entity) => entity.id == id));
    return id;
  }
}
