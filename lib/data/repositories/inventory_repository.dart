import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:uuid/uuid.dart';

class InventoryRepository {
  final List<InventoryModel> _inventories = [];

  List<InventoryModel> getAllInventories() {
    return _inventories;
  }

  InventoryModel? getInventoryById(String id) {
    return _inventories.firstWhere((inventory) => inventory.id == id);
  }

  void addInventory(InventoryModel inventory) {
    _inventories.add(inventory);
  }

  void updateInventory(InventoryModel updatedInventory) {
    final index = _inventories
        .indexWhere((inventory) => inventory.id == updatedInventory.id);
    if (index != -1) {
      _inventories[index] = updatedInventory;
    }
  }

  void deleteInventory(String id) {
    _inventories.removeWhere((inventory) => inventory.id == id);
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    String id;
    do {
      id = uuid.v4();
    } while (_inventories.any((inventory) => inventory.id == id));
    return id;
  }
}
