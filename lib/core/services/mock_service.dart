import 'package:get/get.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/data/models/entity_model.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:inventory_platform/data/models/user_model.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';

class MockService extends GetxController {
  final OrganizationRepository organizationRepository;

  MockService({
    required this.organizationRepository,
  });

  @override
  void onInit() {
    super.onInit();
    addSampleOrganizations();
    // loadOrganizationData('1');
  }

  void addSampleOrganizations() {
    organizationRepository.addAllOrganizations(
      [
        OrganizationModel(
          id: '2',
          title: "Laboratórios",
          description: 'Uma organização para testes inicialmente vazia.',
          imagePath: "assets/images/Laboratory_1920x1080.jpg",
        ),
        OrganizationModel(
          id: '1',
          title: "Embarcações",
          description: 'Uma organização de exemplo com dados fictícios.',
          imagePath: "assets/images/Warship_1920x1080.jpg",
        ),
      ],
    );
  }

  void loadOrganizationData(String orgId) {
    loadData<InventoryModel>(
        orgId, organizationRepository.appendInventoriesInOrganization);
    loadData<DomainModel>(
        orgId, organizationRepository.appendDomainsInOrganization);
    loadData<TagModel>(orgId, organizationRepository.appendTagsInOrganization);
    loadData<ReaderModel>(
        orgId, organizationRepository.appendReadersInOrganization);
    loadData<MemberModel>(
        orgId, organizationRepository.appendMembersInOrganization);
    loadData<EntityModel>(
        orgId, organizationRepository.appendEntitiesInOrganization);
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

  UserModel getSampleUser() {
    return UserModel(
      id: 'u1',
      name: 'Usuário 1',
      email: 'usuario1@exemplo.com',
    );
  }

  List<MemberModel> getMemberSampleData() {
    UserModel sampleUser = getSampleUser();
    return [
      MemberModel(
        id: 'm1',
        user: sampleUser,
        role: 'Admin',
        isActive: 1,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
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
}
