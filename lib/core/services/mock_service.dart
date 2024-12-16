import 'package:get/get.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';

class MockService extends GetxController {
  @override
  void onInit() {
    super.onInit();
    loadItems([
      OrganizationModel(
        title: "Organização 1",
        description: "Descrição do item 1",
        imagePath: "https://via.placeholder.com/1920x1080",
      ),
      OrganizationModel(
        title: "Organização 2",
        description: "Descrição do item 2",
        imagePath: "https://via.placeholder.com/1920x1080",
      ),
    ]);
  }

  var organizationsList = <OrganizationModel>[].obs;

  void addItem(OrganizationModel item) {
    organizationsList.add(item);
  }

  void loadItems(List<OrganizationModel> items) {
    organizationsList.value = items;
  }
}
