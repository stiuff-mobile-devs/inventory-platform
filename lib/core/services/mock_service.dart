import 'package:get/get.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/data/models/entity_model.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:inventory_platform/data/models/tag_model.dart';

class MockService extends GetxController {
  var organizationsList = <OrganizationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    addSampleOrganization();
    loadOrganizationData('1');
  }

  void addSampleOrganization() {
    var organization = OrganizationModel(
      id: '1',
      title: "Embarcações",
      description: 'Uma organização de exemplo com dados fictícios.',
      imagePath: "assets/images/Warship_1920x1080.jpg",
    );
    organizationsList.add(organization);
  }

  void loadOrganizationData(String orgId) {
    loadData<InventoryModel>(orgId, loadInventoriesInOrganization);
    loadData<DomainModel>(orgId, loadDomainsInOrganization);
    loadData<TagModel>(orgId, loadTagsInOrganization);
    loadData<ReaderModel>(orgId, loadReadersInOrganization);
    loadData<MemberModel>(orgId, loadMembersInOrganization);
    loadData<EntityModel>(orgId, loadEntitiesInOrganization);
  }

  void loadData<T>(String orgId, Function(List<T>, String) loadFunction) {
    loadFunction(getSampleData<T>(), orgId);
  }

  List<T> getSampleData<T>() {
    if (T == InventoryModel) return getInventorySampleData() as List<T>;
    if (T == DomainModel) return getDomainSampleData() as List<T>;
    if (T == TagModel) return getTagSampleData() as List<T>;
    if (T == ReaderModel) return getReaderSampleData() as List<T>;
    if (T == MemberModel) return getMemberSampleData() as List<T>;
    if (T == EntityModel) return getEntitySampleData() as List<T>;
    return [];
  }

  List<InventoryModel> getInventorySampleData() {
    return [
      InventoryModel(
        id: 'inv1',
        title: "Inventário 1",
        description: "Descrição do inventário 1",
        createdAt: DateTime.now().subtract(const Duration(days: 30 * 15)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 1)),
        revisionNumber: "1.0.0",
        isActive: 0,
      ),
    ];
  }

  List<DomainModel> getDomainSampleData() {
    return [
      DomainModel(
        id: 'd1',
        title: "Domínio 1",
        description: "Descrição do domínio 1",
        isActive: 1,
        createdAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
      ),
    ];
  }

  List<TagModel> getTagSampleData() {
    return [
      TagModel(
        id: '30E94591236D2925D9B04F80',
        serial: 'B04F80',
        isActive: 1,
        lastSeen: DateTime.now().subtract(const Duration(hours: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
    ];
  }

  List<ReaderModel> getReaderSampleData() {
    return [
      ReaderModel(
        name: 'Leitor 1',
        mac: '00:14:22:01:23:45',
        isActive: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];
  }

  List<MemberModel> getMemberSampleData() {
    return [
      MemberModel(
        id: 'm1',
        name: 'Membro 1',
        email: 'membro1@exemplo.com',
        role: 'Admin',
        isActive: 1,
        createdAt: DateTime.now(),
      ),
    ];
  }

  List<EntityModel> getEntitySampleData() {
    return [
      EntityModel(
        id: '1',
        title: 'Universidade Federal do Rio Grande – FURG',
        type: 'Company',
        attributes: {
          'contactName': 'Newton Pereira',
          'contactEmail': 'example@mail.com',
          'contactPhone': '+55 55 99999 9999',
          'timezone': 'America/Sao_Paulo',
          'address':
              'AVENIDA ITÁLIA, KM 08, PRÉDIO DA PROPLAD – CAMPUS CARREIROS RIO, RIO GRANDE/RS',
        },
      ),
    ];
  }

  void loadInventoriesInOrganization(List<InventoryModel> items, String orgId) {
    _loadDataInOrganization(orgId, (org) => org.inventories = items);
  }

  void loadDomainsInOrganization(List<DomainModel> items, String orgId) {
    _loadDataInOrganization(orgId, (org) => org.domains = items);
  }

  void loadTagsInOrganization(List<TagModel> items, String orgId) {
    _loadDataInOrganization(orgId, (org) => org.tags = items);
  }

  void loadReadersInOrganization(List<ReaderModel> items, String orgId) {
    _loadDataInOrganization(orgId, (org) => org.readers = items);
  }

  void loadMembersInOrganization(List<MemberModel> items, String orgId) {
    _loadDataInOrganization(orgId, (org) => org.members = items);
  }

  void loadEntitiesInOrganization(List<EntityModel> items, String orgId) {
    _loadDataInOrganization(orgId, (org) => org.entities = items);
  }

  void _loadDataInOrganization(
      String orgId, Function(OrganizationModel) setter) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == orgId);
    if (organization == null) return;
    setter(organization);
  }

  List<T> getDataForOrganization<T>(
      String orgId, List<T> Function(OrganizationModel) getter) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == orgId);
    if (organization == null) return [];
    return getter(organization);
  }

  List<InventoryModel> getInventoriesForOrganization(String orgId) {
    return getDataForOrganization(orgId, (org) => org.inventories!);
  }

  List<DomainModel> getDomainsForOrganization(String orgId) {
    return getDataForOrganization(orgId, (org) => org.domains!);
  }

  List<TagModel> getTagsForOrganization(String orgId) {
    return getDataForOrganization(orgId, (org) => org.tags!);
  }

  List<ReaderModel> getReadersForOrganization(String orgId) {
    return getDataForOrganization(orgId, (org) => org.readers!);
  }

  List<MemberModel> getMembersForOrganization(String orgId) {
    return getDataForOrganization(orgId, (org) => org.members!);
  }

  List<EntityModel> getEntitiesForOrganization(String orgId) {
    return getDataForOrganization(orgId, (org) => org.entities!);
  }
}
