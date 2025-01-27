import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/data/models/entity_model.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:inventory_platform/data/repositories/domain_repository.dart';
import 'package:inventory_platform/data/repositories/entity_repository.dart';
import 'package:inventory_platform/data/repositories/inventory_repository.dart';
import 'package:inventory_platform/data/repositories/member_repository.dart';
import 'package:inventory_platform/data/repositories/reader_repository.dart';
import 'package:inventory_platform/data/repositories/tag_repository.dart';
import 'package:uuid/uuid.dart';

class OrganizationRepository {
  final List<OrganizationModel> _organizations = [];

  final DomainRepository _domainRepository = Get.find<DomainRepository>();
  final EntityRepository _entityRepository = Get.find<EntityRepository>();
  final InventoryRepository _inventoryRepository =
      Get.find<InventoryRepository>();
  final MemberRepository _memberRepository = Get.find<MemberRepository>();
  final ReaderRepository _readerRepository = Get.find<ReaderRepository>();
  final TagRepository _tagRepository = Get.find<TagRepository>();

  List<OrganizationModel> getAllOrganizations() {
    return _organizations;
  }

  OrganizationModel? getOrganizationById(String id) {
    return _organizations.firstWhere((organization) => organization.id == id);
  }

  void addOrganization(OrganizationModel organization) {
    _organizations.add(organization);
  }

  void addAllOrganizations(List<OrganizationModel> organizations) {
    _organizations.addAll(organizations);
  }

  void updateOrganization(OrganizationModel updatedOrganization) {
    final index = _organizations.indexWhere(
        (organization) => organization.id == updatedOrganization.id);
    if (index != -1) {
      _organizations[index] = updatedOrganization;
    }
  }

  void deleteOrganization(String id) {
    _organizations.removeWhere((organization) => organization.id == id);
  }

  List<T> _getDataForOrganization<T>(
      String orgId, List<T> Function(OrganizationModel) getter) {
    OrganizationModel? organization =
        _organizations.firstWhere((organization) => organization.id == orgId);
    return getter(organization);
  }

  Future<List<InventoryModel>> getInventoriesForOrganization(
      String orgId) async {
    OrganizationModel? organization =
        _organizations.firstWhere((organization) => organization.id == orgId);
    List<InventoryModel> allInventories =
        await _inventoryRepository.getAllInventories();

    return allInventories;

    // Preciso implementar persistência em Organization antes

    // return allInventories
    //     .where((inventory) =>
    //         organization.inventories?.contains(inventory.id) ?? false)
    //     .toList();
  }

  Future<List<DomainModel>> getDomainsForOrganization(String orgId) async {
    OrganizationModel? organization =
        _organizations.firstWhere((organization) => organization.id == orgId);
    List<DomainModel> allDomains = await _domainRepository.getAllDomains();

    return allDomains;

    // return _getDataForOrganization(
    //   orgId,
    //   (org) => _domainRepository
    //       .getAllDomains()
    //       .where((domain) => org.domains?.contains(domain.id) ?? false)
    //       .toList(),
    // );
  }

  List<TagModel> getTagsForOrganization(String orgId) {
    return _getDataForOrganization(
      orgId,
      (org) => _tagRepository
          .getAllTags()
          .where((tag) => org.tags?.contains(tag.id) ?? false)
          .toList(),
    );
  }

  List<ReaderModel> getReadersForOrganization(String orgId) {
    return _getDataForOrganization(
      orgId,
      (org) => _readerRepository
          .getAllReaders()
          .where((reader) => org.readers?.contains(reader.mac) ?? false)
          .toList(),
    );
  }

  List<MemberModel> getMembersForOrganization(String orgId) {
    return _getDataForOrganization(
      orgId,
      (org) => _memberRepository
          .getAllMembers()
          .where((member) => org.members?.contains(member.id) ?? false)
          .toList(),
    );
  }

  List<EntityModel> getEntitiesForOrganization(String orgId) {
    return _getDataForOrganization(
      orgId,
      (org) => _entityRepository
          .getAllEntities()
          .where((entity) => org.entities?.contains(entity.id) ?? false)
          .toList(),
    );
  }

  void _loadDataInOrganization(
      String orgId, Function(OrganizationModel) method) {
    OrganizationModel? organization =
        _organizations.firstWhere((organization) => organization.id == orgId);
    method(organization);
  }

  String getItemId<T>(T item) {
    switch (T) {
      case const (InventoryModel):
        return (item as InventoryModel).id;
      case const (DomainModel):
        return (item as DomainModel).id;
      case const (TagModel):
        return (item as TagModel).id;
      case const (ReaderModel):
        return (item as ReaderModel).mac;
      case const (MemberModel):
        return (item as MemberModel).id;
      case const (EntityModel):
        return (item as EntityModel).id;
      default:
        throw ArgumentError('Unsupported type: $T');
    }
  }

  void _setItemsInOrganization<T>(
      List<T> items,
      String orgId,
      List<T> Function() getAllItems,
      void Function(T) addItem,
      void Function(String) deleteItem,
      List<String>? Function(OrganizationModel) getOrgItems,
      void Function(OrganizationModel, List<String>) setOrgItems) {
    _loadDataInOrganization(orgId, (org) {
      T targetedItem;
      while (getAllItems()
          .where((item) => getOrgItems(org)?.contains(getItemId(item)) ?? false)
          .isNotEmpty) {
        targetedItem = getAllItems().firstWhere(
            (item) => getOrgItems(org)?.contains(getItemId(item)) ?? false);
        deleteItem(getItemId(targetedItem));
      }
      setOrgItems(org, []);
      for (T item in items) {
        addItem(item);
        getOrgItems(org)!.add(getItemId(item));
      }
    });
  }

  Future<void> setInventoriesInOrganization(
      List<InventoryModel> items, String orgId) async {
    List<InventoryModel> allInventories =
        await _inventoryRepository.getAllInventories();

    _setItemsInOrganization(
        items,
        orgId,
        () => allInventories,
        _inventoryRepository.addInventory,
        _inventoryRepository.deleteInventory,
        (org) => org.inventories,
        (org, ids) => org.inventories = ids);
  }

  Future<void> setDomainsInOrganization(
      List<DomainModel> items, String orgId) async {
    List<DomainModel> allDomains = await _domainRepository.getAllDomains();

    _setItemsInOrganization(
        items,
        orgId,
        () => allDomains,
        _domainRepository.addDomain,
        _domainRepository.deleteDomain,
        (org) => org.domains,
        (org, ids) => org.domains = ids);
  }

  void setTagsInOrganization(List<TagModel> items, String orgId) {
    _setItemsInOrganization(
        items,
        orgId,
        _tagRepository.getAllTags,
        _tagRepository.addTag,
        _tagRepository.deleteTag,
        (org) => org.tags,
        (org, ids) => org.tags = ids);
  }

  void setReadersInOrganization(List<ReaderModel> items, String orgId) {
    _setItemsInOrganization(
        items,
        orgId,
        _readerRepository.getAllReaders,
        _readerRepository.addReader,
        _readerRepository.deleteReader,
        (org) => org.readers,
        (org, ids) => org.readers = ids);
  }

  void setMembersInOrganization(List<MemberModel> items, String orgId) {
    _setItemsInOrganization(
        items,
        orgId,
        _memberRepository.getAllMembers,
        _memberRepository.addMember,
        _memberRepository.deleteMember,
        (org) => org.members,
        (org, ids) => org.members = ids);
  }

  void setEntitiesInOrganization(List<EntityModel> items, String orgId) {
    _setItemsInOrganization(
        items,
        orgId,
        _entityRepository.getAllEntities,
        _entityRepository.addEntity,
        _entityRepository.deleteEntity,
        (org) => org.entities,
        (org, ids) => org.entities = ids);
  }

  void _appendItemsInOrganization<T>(
      List<T> items,
      String orgId,
      void Function(T) addItem,
      List<String>? Function(OrganizationModel) getOrgItems) {
    _loadDataInOrganization(orgId, (org) {
      for (T item in items) {
        addItem(item);
        getOrgItems(org)!.add(getItemId(item));
      }
    });
  }

  void appendInventoriesInOrganization(
      List<InventoryModel> items, String orgId) {
    _appendItemsInOrganization(items, orgId, _inventoryRepository.addInventory,
        (org) => org.inventories);
  }

  void appendDomainsInOrganization(List<DomainModel> items, String orgId) {
    _appendItemsInOrganization(
        items, orgId, _domainRepository.addDomain, (org) => org.domains);
  }

  void appendTagsInOrganization(List<TagModel> items, String orgId) {
    _appendItemsInOrganization(
        items, orgId, _tagRepository.addTag, (org) => org.tags);
  }

  void appendReadersInOrganization(List<ReaderModel> items, String orgId) {
    _appendItemsInOrganization(
        items, orgId, _readerRepository.addReader, (org) => org.readers);
  }

  void appendMembersInOrganization(List<MemberModel> items, String orgId) {
    _appendItemsInOrganization(
        items, orgId, _memberRepository.addMember, (org) => org.members);
  }

  void appendEntitiesInOrganization(List<EntityModel> items, String orgId) {
    _appendItemsInOrganization(
        items, orgId, _entityRepository.addEntity, (org) => org.entities);
  }

  String generateUniqueId() {
    var uuid = const Uuid();
    String id;
    do {
      id = uuid.v4();
    } while (_organizations.any((organization) => organization.id == id));
    return id;
  }
}
