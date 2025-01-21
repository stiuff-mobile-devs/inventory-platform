import 'package:inventory_platform/data/models/material_model.dart';
import 'package:uuid/uuid.dart';

class MaterialRepository {
  final List<Material> _materials = [];

  List<Material> getAllMaterials() {
    return _materials;
  }

  Material? getMaterialById(String id) {
    return _materials.firstWhere((material) => material.id == id);
  }

  void addMaterial(Material material) {
    _materials.add(material);
  }

  void updateMaterial(Material updatedMaterial) {
    final index =
        _materials.indexWhere((material) => material.id == updatedMaterial.id);
    if (index != -1) {
      _materials[index] = updatedMaterial;
    }
  }

  void deleteMaterial(String id) {
    _materials.removeWhere((material) => material.id == id);
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    String id;
    do {
      id = uuid.v4();
    } while (_materials.any((material) => material.id == id));
    return id;
  }
}
