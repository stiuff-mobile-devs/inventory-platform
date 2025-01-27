import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/data/models/entity_model.dart';
import 'package:inventory_platform/data/models/generic_list_item_model.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';

class PanelController extends GetxController {
  late final OrganizationModel _currentOrganization;

  final OrganizationRepository _organizationRepository =
      Get.find<OrganizationRepository>();

  late RxList<GenericListItemModel> allTabItemsGeneralized;
  late RxList<GenericListItemModel> filteredItems;

  late RxList<OrganizationModel> organizations;
  late RxList<EntityModel> entities;
  late RxList<TagModel> tags;
  late RxList<DomainModel> domains;
  late RxList<InventoryModel> inventories;
  late RxList<MemberModel> members;
  late RxList<ReaderModel> readers;

  final Rx<PagingController<int, GenericListItemModel>> pagingController =
      PagingController<int, GenericListItemModel>(firstPageKey: 0).obs;

  RxInt selectedTabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    allTabItemsGeneralized = <GenericListItemModel>[].obs;
    filteredItems = <GenericListItemModel>[].obs;

    organizations = <OrganizationModel>[].obs;
    entities = <EntityModel>[].obs;
    tags = <TagModel>[].obs;
    domains = <DomainModel>[].obs;
    inventories = <InventoryModel>[].obs;
    members = <MemberModel>[].obs;
    readers = <ReaderModel>[].obs;

    ever(selectedTabIndex, (_) => refreshItemsAndPaging());
  }

  Future<void> refreshItemsAndPaging() async {
    await refreshItems();
    pagingController.value.refresh();
  }

  void setCurrentOrganization(OrganizationModel organization) {
    _currentOrganization = organization;
  }

  OrganizationModel getCurrentOrganization() {
    return _currentOrganization;
  }

  void filterItems(String query) {
    final lowerCaseQuery = query.toLowerCase();
    filteredItems.value = allTabItemsGeneralized.where((item) {
      return item.upperHeaderField.toLowerCase().contains(lowerCaseQuery) ||
          (item.id ?? ' ').toLowerCase().contains(lowerCaseQuery);
    }).toList();
  }

  Future<void> refreshItems() async {
    inventories.value = await _organizationRepository
        .getInventoriesForOrganization(_currentOrganization.id);

    domains.value = await _organizationRepository
        .getDomainsForOrganization(_currentOrganization.id);

    tags.value = await _organizationRepository
        .getTagsForOrganization(_currentOrganization.id);

    readers.value = _organizationRepository
        .getReadersForOrganization(_currentOrganization.id);

    members.value = _organizationRepository
        .getMembersForOrganization(_currentOrganization.id);

    updateItemsBasedOnTab();
  }

  void updateItemsBasedOnTab() {
    switch (selectedTabIndex.value) {
      case 1:
        allTabItemsGeneralized.value =
            InventoryModel.turnAllIntoGenericListItemModel(inventories);
        break;
      case 2:
        allTabItemsGeneralized.value =
            DomainModel.turnAllIntoGenericListItemModel(domains);
        break;
      case 3:
        allTabItemsGeneralized.value =
            TagModel.turnAllIntoGenericListItemModel(tags);
        break;
      case 4:
        allTabItemsGeneralized.value =
            ReaderModel.turnAllIntoGenericListItemModel(readers);
        break;
      case 5:
        allTabItemsGeneralized.value =
            MemberModel.turnAllIntoGenericListItemModel(members);
        break;
      default:
        allTabItemsGeneralized.value = [];
    }

    allTabItemsGeneralized.sort((a, b) => (b.initialDate ?? DateTime.now())
        .compareTo(a.initialDate ?? DateTime.now()));
  }
}
