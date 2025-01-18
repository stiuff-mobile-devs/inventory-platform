import 'package:get/get.dart';
import 'package:inventory_platform/features/data/models/domain_model.dart';
import 'package:inventory_platform/features/data/models/entity_model.dart';
import 'package:inventory_platform/features/data/models/inventory_model.dart';
import 'package:inventory_platform/features/data/models/member_model.dart';
import 'package:inventory_platform/features/data/models/organization_model.dart';
import 'package:inventory_platform/features/data/models/reader_model.dart';
import 'package:inventory_platform/features/data/models/tag_model.dart';

class MockService extends GetxController {
  var organizationsList = <OrganizationModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrganizations([
      OrganizationModel(
        id: '0',
        title: "Laboratórios",
        description: "Descrição do item 1",
        imagePath: "assets/images/Laboratory_1920x1080.jpg",
      ),
      OrganizationModel(
        id: '1',
        title: "Embarcações",
        description: "Descrição do item 2",
        imagePath: "assets/images/Warship_1920x1080.jpg",
      ),
    ]);
    loadInventoriesInOrganization([
      InventoryModel(
        id: 'inv1',
        title: "Inventário 1",
        description: "Descrição do inventário 1",
        createdAt: DateTime.now().subtract(const Duration(days: 30 * 15)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 1)),
        revisionNumber: "1.0.0",
        isActive: 0,
      ),
      InventoryModel(
        id: 'inv2',
        title: "Inventário 2",
        description: "Descrição do inventário 2",
        createdAt: DateTime.now().subtract(const Duration(days: 30 * 7)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 5)),
        revisionNumber: "2.0.0",
        isActive: 1,
      ),
      InventoryModel(
        id: 'inv3',
        title: "Inventário 3",
        description: "Descrição do inventário 3",
        createdAt: DateTime.now().subtract(const Duration(days: 30 * 4)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 2)),
        revisionNumber: "1.0.0",
        isActive: 1,
      ),
      InventoryModel(
        id: 'inv4',
        title: "Inventário 4",
        description: "Descrição do inventário 4",
        createdAt: DateTime.now().subtract(const Duration(days: 30 * 2)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        revisionNumber: "3.0.0",
        isActive: 0,
      ),
      InventoryModel(
        id: 'inv5',
        title: "Inventário 5",
        description: "Descrição do inventário 5",
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        revisionNumber: "2.0.0",
        isActive: 0,
      ),
      InventoryModel(
        id: 'inv6',
        title: "Inventário 6",
        description: "Descrição do inventário 6",
        createdAt: DateTime.now().subtract(const Duration(days: 21)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        revisionNumber: "2.0.0",
        isActive: 0,
      ),
      InventoryModel(
        id: 'inv7',
        title: "Inventário 7",
        description: "Descrição do inventário 7",
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        revisionNumber: "2.0.0",
        isActive: 0,
      ),
      InventoryModel(
        id: 'inv8',
        title: "Inventário 8",
        description: "Descrição do inventário 8",
        createdAt: DateTime.now().subtract(const Duration(days: 6)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        revisionNumber: "2.0.0",
        isActive: 0,
      ),
    ], '1');
    loadDomainsInOrganization([
      DomainModel(
        id: 'd1',
        title: "Domínio 1",
        description: "Descrição do domínio 1",
        isActive: 1,
        createdAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
      ),
      DomainModel(
        id: 'd2',
        title: "Domínio 2",
        description: "Descrição do domínio 2",
        isActive: 0,
        createdAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
      ),
      DomainModel(
        id: 'd3',
        title: "Domínio 3",
        description: "Descrição do domínio 3",
        isActive: 1,
        createdAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
      ),
      DomainModel(
        id: 'd4',
        title: "Domínio 4",
        description: "Descrição do domínio 4",
        isActive: 0,
        createdAt: DateTime.now(),
        lastUpdatedAt: DateTime.now(),
      ),
    ], '1');
    loadTagsInOrganization([
      TagModel(
        id: '30E94591236D2925D9B04F80',
        serial: 'B04F80',
        isActive: 1,
        lastSeen: DateTime.now().subtract(const Duration(hours: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      TagModel(
        id: '930416F4D73454F3DD758F6F',
        serial: '758F6F',
        isActive: 1,
        lastSeen: DateTime.now().subtract(const Duration(hours: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      TagModel(
        id: '943603D1D7F0E9A4FC85C512',
        serial: '85C512',
        isActive: 1,
        lastSeen: DateTime.now().subtract(const Duration(hours: 8)),
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      TagModel(
        id: 'AB386234890D8EC1F0DEC134',
        serial: 'DEC134',
        isActive: 1,
        lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ], '1');
    loadReadersInOrganization([
      ReaderModel(
        name: 'Leitor 1',
        mac: '00:14:22:01:23:45',
        isActive: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ReaderModel(
        name: 'Leitor 2',
        mac: '00:14:22:01:23:46',
        isActive: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        lastSeen: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ReaderModel(
        name: 'Leitor 3',
        mac: '00:14:22:01:23:47',
        isActive: 1,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ReaderModel(
        name: 'Leitor 4',
        mac: '00:14:22:01:23:48',
        isActive: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        lastSeen: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ], '1');
    loadMembersInOrganization([
      MemberModel(
        id: 'm1',
        name: 'Membro 1',
        email: 'membro1@exemplo.com',
        role: 'Admin',
        isActive: 1,
        createdAt: DateTime.now(),
      ),
      MemberModel(
        id: 'm2',
        name: 'Membro 2',
        email: 'membro2@exemplo.com',
        role: 'Membro',
        isActive: 1,
        createdAt: DateTime.now(),
      ),
      MemberModel(
        id: 'm3',
        name: 'Membro 3',
        email: 'membro3@exemplo.com',
        role: 'Admin',
        isActive: 0,
        createdAt: DateTime.now(),
      ),
    ], '1');
    loadEntitiesInOrganization([
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
      EntityModel(
        id: '2',
        title: 'Global Asbest RP. HZ. LTD',
        type: 'Laboratories',
        attributes: {
          'address':
              'AV. REPUBLICA DO CHILE N 65 - SALA 1701, RIO DE JANEIRO, CEP20031-912 BR',
        },
        createdAt: DateTime.parse('2024-05-27T16:15:02'),
      ),
      EntityModel(
        id: '3',
        title: 'CESS - Universidade Federal Fluminense',
        type: 'Laboratories',
        attributes: {
          'address':
              'R. Des. Ellis Hermydio Figueira, 783 - Bloco A - Aterrado, Volta Redonda - RJ, 27213-145',
        },
        createdAt: DateTime.parse('2024-05-11T04:58:13'),
      ),
      EntityModel(
        id: '4',
        title: 'BV Solutions Marine & Offshore',
        type: 'IHM Companies',
        attributes: {
          'surveyor': 'Rio de Janeiro',
          'hazmatExpert': 'Roberto Yamaki',
          'projectCoordinator': 'Marcos Glad',
        },
        createdAt: DateTime.parse('2024-05-28T09:18:10'),
      ),
      EntityModel(
        id: '5',
        title: 'Centro de Estudos Sistemas Sustentáveis (UFF)',
        type: 'IHM Companies',
        attributes: {
          'surveyor': 'Rio de Janeiro',
          'hazmatExpert': 'Vitor',
          'projectCoordinator': 'Lais',
        },
        createdAt: DateTime.parse('2024-11-05T04:57:11'),
      ),
    ], '1');
  }

  void loadOrganizations(List<OrganizationModel> items) {
    organizationsList.value = items;
  }

  void loadInventoriesInOrganization(List<InventoryModel> items, String orgId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == orgId);
    if (organization == null) return;
    organization.inventories = items;
  }

  void loadDomainsInOrganization(List<DomainModel> items, String orgId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == orgId);
    if (organization == null) return;
    organization.domains = items;
  }

  void loadTagsInOrganization(List<TagModel> items, String orgId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == orgId);
    if (organization == null) return;
    organization.tags = items;
  }

  void loadReadersInOrganization(List<ReaderModel> items, String orgId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == orgId);
    if (organization == null) return;
    organization.readers = items;
  }

  void loadMembersInOrganization(List<MemberModel> items, String orgId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == orgId);
    if (organization == null) return;
    organization.members = items;
  }

  void loadEntitiesInOrganization(List<EntityModel> items, String orgId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == orgId);
    if (organization == null) return;
    organization.entities = items;
  }

  List<InventoryModel> getInventoriesForOrganization(String organizationId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == organizationId);
    if (organization == null) [];
    return organization!.inventories!.toList();
  }

  List<DomainModel> getDomainsForOrganization(String organizationId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == organizationId);
    if (organization == null) [];
    return organization!.domains!.toList();
  }

  List<TagModel> getTagsForOrganization(String organizationId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == organizationId);
    if (organization == null) [];
    return organization!.tags!.toList();
  }

  List<ReaderModel> getReadersForOrganization(String organizationId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == organizationId);
    if (organization == null) [];
    return organization!.readers!.toList();
  }

  List<MemberModel> getMembersForOrganization(String organizationId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == organizationId);
    if (organization == null) [];
    return organization!.members!.toList();
  }

  List<EntityModel> getEntitiesForOrganization(String organizationId) {
    OrganizationModel? organization = organizationsList
        .firstWhereOrNull((organization) => organization.id == organizationId);
    if (organization == null) [];
    return organization!.entities!.toList();
  }
}
