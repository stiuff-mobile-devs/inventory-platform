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
  var inventoriesList = <InventoryModel>[].obs;
  var domainsList = <DomainModel>[].obs;
  var tagsList = <TagModel>[].obs;
  var readersList = <ReaderModel>[].obs;
  var membersList = <MemberModel>[].obs;
  var entitiesList = <EntityModel>[].obs;

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
    loadDomains([
      DomainModel(
        id: 'd1',
        name: "Domínio 1",
        description: "Descrição do domínio 1",
        organizationId: '0',
        status: "active",
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 1)),
        categoryId: '1',
      ),
      DomainModel(
        id: 'd2',
        name: "Domínio 2",
        description: "Descrição do domínio 2",
        organizationId: '0',
        status: "inactive",
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 5)),
        categoryId: '2',
      ),
      DomainModel(
        id: 'd3',
        name: "Domínio 3",
        description: "Descrição do domínio 3",
        organizationId: '1',
        status: "active",
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 2)),
        categoryId: '3',
      ),
      DomainModel(
        id: 'd4',
        name: "Domínio 4",
        description: "Descrição do domínio 4",
        organizationId: '1',
        status: "inactive",
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 10)),
        categoryId: '4',
      ),
    ]);
    loadTags([
      TagModel(
        id: '30E94591236D2925D9B04F80',
        serial: 'B04F80',
        lastSeen: DateTime.now().subtract(const Duration(hours: 5)),
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        materialId: 'm1',
        organizationId: '0',
      ),
      TagModel(
        id: '930416F4D73454F3DD758F6F',
        serial: '758F6F',
        lastSeen: DateTime.now().subtract(const Duration(hours: 3)),
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        materialId: 'm2',
        organizationId: '0',
      ),
      TagModel(
        id: '943603D1D7F0E9A4FC85C512',
        serial: '85C512',
        lastSeen: DateTime.now().subtract(const Duration(hours: 8)),
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        materialId: 'm3',
        organizationId: '1',
      ),
      TagModel(
        id: 'AB386234890D8EC1F0DEC134',
        serial: 'DEC134',
        lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        materialId: 'm4',
        organizationId: '1',
      ),
    ]);
    loadReaders([
      ReaderModel(
        name: 'Leitor 1',
        organizationId: '1',
        mac: '00:14:22:01:23:45',
        status: 'Ativo',
        lastSeen: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      ReaderModel(
        name: 'Leitor 2',
        organizationId: '1',
        mac: '00:14:22:01:23:46',
        status: 'Inativo',
        lastSeen: DateTime.now().subtract(const Duration(days: 1)),
      ),
      ReaderModel(
        name: 'Leitor 3',
        organizationId: '1',
        mac: '00:14:22:01:23:47',
        status: 'Ativo',
        lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ReaderModel(
        name: 'Leitor 4',
        organizationId: '1',
        mac: '00:14:22:01:23:48',
        status: 'Inativo',
        lastSeen: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ]);
    loadOrganizations([
      // Carregar organizações
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
    loadMembers([
      MemberModel(
        id: 'm1',
        name: 'Membro 1',
        email: 'membro1@exemplo.com',
        role: 'Admin',
        status: 'Ativo',
        createdAt: DateTime.now(),
        organizations: ['0', '1'],
      ),
      MemberModel(
        id: 'm2',
        name: 'Membro 2',
        email: 'membro2@exemplo.com',
        role: 'Membro',
        status: 'Ativo',
        createdAt: DateTime.now(),
        organizations: ['1'],
      ),
      MemberModel(
        id: 'm3',
        name: 'Membro 3',
        email: 'membro3@exemplo.com',
        role: 'Admin',
        status: 'Inativo',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        organizations: ['0'],
      ),
    ]);
    loadEntities([
      EntityModel(
        id: '1',
        organizationId: '1',
        name: 'Universidade Federal do Rio Grande – FURG',
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
        organizationId: '1',
        name: 'Global Asbest RP. HZ. LTD',
        type: 'Laboratories',
        attributes: {
          'address':
              'AV. REPUBLICA DO CHILE N 65 - SALA 1701, RIO DE JANEIRO, CEP20031-912 BR',
        },
        createdAt: DateTime.parse('2024-05-27T16:15:02'),
      ),
      EntityModel(
        id: '3',
        organizationId: '1',
        name: 'CESS - Universidade Federal Fluminense',
        type: 'Laboratories',
        attributes: {
          'address':
              'R. Des. Ellis Hermydio Figueira, 783 - Bloco A - Aterrado, Volta Redonda - RJ, 27213-145',
        },
        createdAt: DateTime.parse('2024-05-11T04:58:13'),
      ),
      EntityModel(
        id: '4',
        organizationId: '1',
        name: 'BV Solutions Marine & Offshore',
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
        organizationId: '1',
        name: 'Centro de Estudos Sistemas Sustentáveis (UFF)',
        type: 'IHM Companies',
        attributes: {
          'surveyor': 'Rio de Janeiro',
          'hazmatExpert': 'Vitor',
          'projectCoordinator': 'Lais',
        },
        createdAt: DateTime.parse('2024-11-05T04:57:11'),
      ),
    ]);
  }

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

  void addDomain(DomainModel item) {
    domainsList.add(item);
  }

  void loadDomains(List<DomainModel> items) {
    domainsList.value = items;
  }

  void addTag(TagModel item) {
    tagsList.add(item);
  }

  void loadTags(List<TagModel> items) {
    tagsList.value = items;
  }

  void addReader(ReaderModel item) {
    readersList.add(item);
  }

  void loadReaders(List<ReaderModel> items) {
    readersList.value = items;
  }

  void addMember(MemberModel member) {
    membersList.add(member);
  }

  void loadMembers(List<MemberModel> members) {
    membersList.value = members;
  }

  void addEntity(EntityModel entity) {
    entitiesList.add(entity);
  }

  void loadEntities(List<EntityModel> entities) {
    entitiesList.value = entities;
  }

  List<InventoryModel> getInventoriesForOrganization(String organizationId) {
    return inventoriesList
        .where((inventory) => inventory.organizationId == organizationId)
        .toList();
  }

  List<DomainModel> getDomainsForOrganization(String organizationId) {
    return domainsList
        .where((domain) => domain.organizationId == organizationId)
        .toList();
  }

  List<TagModel> getTagsForOrganization(String organizationId) {
    return tagsList
        .where((tag) => tag.organizationId == organizationId)
        .toList();
  }

  List<ReaderModel> getReadersForOrganization(String organizationId) {
    return readersList
        .where((reader) => reader.organizationId == organizationId)
        .toList();
  }

  List<MemberModel> getMembersForOrganization(String organizationId) {
    return membersList
        .where((member) => member.organizations.contains(organizationId))
        .toList();
  }

  List<EntityModel> getEntitiesForOrganization(String organizationId) {
    return entitiesList
        .where((entity) => entity.organizationId == organizationId)
        .toList();
  }
}
