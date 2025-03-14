import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/models/item_model.dart';

class ItemRepository {
  Future<List<ItemModel>> getAllItemsByOrganization(List<InventoryModel> inventories, String orgId) async {
    List<ItemModel> list = [];
    //'eyCtyST3VVkp3HJ67s8S'
    for (var inv in inventories) {
      CollectionReference collection = FirebaseFirestore.instance
          .collection('departments')
          .doc(orgId)
          .collection('inventories')
          .doc(inv.id)
          .collection('items');

      QuerySnapshot querySnapshot = await collection.get();

      List<ItemModel> items = querySnapshot.docs.map((doc) {
        return ItemModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      list = list + items;
    }
    return list;
  }
}