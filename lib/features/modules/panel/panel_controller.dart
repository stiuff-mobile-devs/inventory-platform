import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/data/models/entity_model.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';

class PanelController extends GetxController {
  final _organizationRepository = Get.find<OrganizationRepository>();
  final _utilsService = UtilsService();

  final searchController = TextEditingController();

  final Rx<OrganizationModel?> _currentOrganization =
      Rx<OrganizationModel?>(null);
  final RxInt selectedTabIndex = 0.obs;
  final RxList<dynamic> listedItems = <dynamic>[].obs;

  final RxList<OrganizationModel> organizations = <OrganizationModel>[].obs;
  final RxList<EntityModel> entities = <EntityModel>[].obs;
  final RxList<TagModel> tags = <TagModel>[].obs;
  final RxList<DomainModel> domains = <DomainModel>[].obs;
  final RxList<InventoryModel> inventories = <InventoryModel>[].obs;
  final RxList<MemberModel> members = <MemberModel>[].obs;
  final RxList<ReaderModel> readers = <ReaderModel>[].obs;

  @override
  void onInit() {
    ever(selectedTabIndex, (_) => refreshPage());
    super.onInit();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void setCurrentOrganization(OrganizationModel organization) {
    _currentOrganization.value = organization;
  }

  OrganizationModel? getCurrentOrganization() => _currentOrganization.value;

  Future<void> refreshPage() async {
    await refreshItemsForTab(
        tabType: _utilsService.tabIndexToEnum(selectedTabIndex.value));
  }

  Future<void> refreshItemsForTab({TabType? tabType}) async {
    if (_currentOrganization.value == null) return;

    if (selectedTabIndex.value == 0) {
      await fetchAllData().then((data) => update());
    } else {
      final orgId = _currentOrganization.value!.id;
      final dataFetchers = {
        TabType.inventories: () => _fetchData(inventories,
            () => _organizationRepository.getInventoriesForOrganization(orgId)),
        TabType.domains: () => _fetchData(domains,
            () => _organizationRepository.getDomainsForOrganization(orgId)),
        TabType.tags: () => _fetchData(
            tags, () => _organizationRepository.getTagsForOrganization(orgId)),
        TabType.readers: () => _fetchData(readers,
            () => _organizationRepository.getReadersForOrganization(orgId)),
        // TabType.members: () => _fetchData(members, () => _organizationRepository.getMembersForOrganization(orgId)),
        TabType.entities: () => _fetchData(entities,
            () => _organizationRepository.getEntitiesForOrganization(orgId)),
      };

      if (dataFetchers.containsKey(tabType)) {
        await dataFetchers[tabType]!();
      }
    }

    updateItemsBasedOnTab(selectedTabIndex.value);
  }

  Future<void> fetchAllData() async {
    final orgId = _currentOrganization.value?.id;
    if (orgId == null) return;

    await Future.wait([
      _fetchData(inventories,
          () => _organizationRepository.getInventoriesForOrganization(orgId)),
      _fetchData(domains,
          () => _organizationRepository.getDomainsForOrganization(orgId)),
      _fetchData(
          tags, () => _organizationRepository.getTagsForOrganization(orgId)),
      _fetchData(readers,
          () => _organizationRepository.getReadersForOrganization(orgId)),
      // _fetchData(members, () => _organizationRepository.getMembersForOrganization(orgId)),
      _fetchData(entities,
          () => _organizationRepository.getEntitiesForOrganization(orgId)),
    ]);
  }

  void updateItemsBasedOnTab(int tabIndex) {
    if (searchController.text.isNotEmpty) return;

    final tabDataMap = {
      1: inventories,
      2: domains,
      3: tags,
      4: readers,
      5: members,
      6: entities,
    };

    listedItems.assignAll(tabDataMap[tabIndex] ?? []);
  }

  Future<void> _fetchData<T>(
      RxList<T> list, Future<List<T>> Function() fetcher) async {
    try {
      list.assignAll(await fetcher());
    } catch (e) {
      list.clear();
      debugPrint("Erro ao buscar dados: $e");
    }
  }
}
