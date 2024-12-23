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
        title: "Laboratórios",
        description: "Descrição do item 1",
        // imagePath: "https://via.placeholder.com/1920x1080",
        imagePath: "assets/images/Laboratory_1920x1080.jpg",
      ),
      OrganizationModel(
        id: '1',
        title: "Embarcações",
        description: "Descrição do item 2",
        // imagePath: "https://via.placeholder.com/1920x1080",
        imagePath: "assets/images/Warship_1920x1080.jpg",
      ),
    ]);
    loadInventories([
      InventoryModel(
        id: 'inv1',
        title: "Inventário 1",
        description: "Descrição do inventário 1",
        organizationId: '1',
        openedAt: DateTime.now().subtract(const Duration(days: 30 * 15)),
        closedAt: null,
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 1)),
        revisionNumber: 1,
        status: "open",
      ),
      InventoryModel(
        id: 'inv2',
        title: "Inventário 2",
        description: "Descrição do inventário 2",
        organizationId: '1',
        openedAt: DateTime.now().subtract(const Duration(days: 30 * 7)),
        closedAt: DateTime.now().subtract(const Duration(days: 5)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 5)),
        revisionNumber: 2,
        status: "finalized",
      ),
      InventoryModel(
        id: 'inv3',
        title: "Inventário 3",
        description: "Descrição do inventário 3",
        organizationId: '1',
        openedAt: DateTime.now().subtract(const Duration(days: 30 * 4)),
        closedAt: null,
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 2)),
        revisionNumber: 1,
        status: "open",
      ),
      InventoryModel(
        id: 'inv4',
        title: "Inventário 4",
        description: "Descrição do inventário 4",
        organizationId: '1',
        openedAt: DateTime.now().subtract(const Duration(days: 30 * 2)),
        closedAt: DateTime.now().subtract(const Duration(days: 10)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        revisionNumber: 3,
        status: "finalized",
      ),
      InventoryModel(
        id: 'inv5',
        title: "Inventário 5",
        description: "Descrição do inventário 5",
        organizationId: '1',
        openedAt: DateTime.now().subtract(const Duration(days: 30)),
        closedAt: DateTime.now().subtract(const Duration(days: 10)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        revisionNumber: 2,
        status: "finalized",
      ),
      InventoryModel(
        id: 'inv6',
        title: "Inventário 6",
        description: "Descrição do inventário 6",
        organizationId: '1',
        openedAt: DateTime.now().subtract(const Duration(days: 21)),
        closedAt: DateTime.now().subtract(const Duration(days: 10)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        revisionNumber: 2,
        status: "finalized",
      ),
      InventoryModel(
        id: 'inv7',
        title: "Inventário 7",
        description: "Descrição do inventário 7",
        organizationId: '1',
        openedAt: DateTime.now().subtract(const Duration(days: 15)),
        closedAt: DateTime.now().subtract(const Duration(days: 10)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        revisionNumber: 2,
        status: "finalized",
      ),
      InventoryModel(
        id: 'inv8',
        title: "Inventário 8",
        description: "Descrição do inventário 8",
        organizationId: '1',
        openedAt: DateTime.now().subtract(const Duration(days: 6)),
        closedAt: DateTime.now().subtract(const Duration(days: 10)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        revisionNumber: 2,
        status: "finalized",
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
