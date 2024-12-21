import 'package:get/get.dart';
import 'package:inventory_platform/features/data/models/inventory_model.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';

class MockService extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadOrganizations([
      OrganizationModel(
        id: '0',
        title: "Organização 1",
        description: "Descrição do item 1",
        // imagePath: "https://via.placeholder.com/1920x1080",
      ),
      OrganizationModel(
        id: '1',
        title: "Organização 2",
        description: "Descrição do item 2",
        // imagePath: "https://via.placeholder.com/1920x1080",
      ),
    ]);
    loadInventories([
      InventoryModel(
        organizationId: '0',
        title: "Inventário 1",
        description: "Descrição do item 1",
      ),
      InventoryModel(
        organizationId: '0',
        title: "Inventário 2",
        description: "Descrição do item 2",
      ),
      InventoryModel(
        organizationId: '1',
        title: "Inventário 3",
        description: "Descrição do item 1",
      ),
      InventoryModel(
        organizationId: '1',
        title: "Inventário 4",
        description: "Descrição do item 2",
      ),
    ]);
  }

  var organizationsList = <OrganizationModel>[].obs;
  var inventoriesList = <InventoryModel>[].obs;

  void addOrganization(OrganizationModel item) {
    organizationsList.add(item);
  }

  void loadOrganizations(List<OrganizationModel> items) {
    organizationsList.value = items;
  }

  void addInventory(InventoryModel item) {
    inventoriesList.add(item);
  }

  void loadInventories(List<InventoryModel> items) {
    inventoriesList.value = items;
  }

  List<InventoryModel> getInventoriesForOrganization(String organizationId) {
    return inventoriesList
        .where((inventory) => inventory.organizationId == organizationId)
        .toList();
  }
}
