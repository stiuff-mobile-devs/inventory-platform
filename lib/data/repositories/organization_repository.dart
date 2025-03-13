import 'package:get/get.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/data/models/entity_model.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/models/item_model.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:inventory_platform/data/repositories/domain_repository.dart';
import 'package:inventory_platform/data/repositories/entity_repository.dart';
import 'package:inventory_platform/data/repositories/inventory_repository.dart';
import 'package:inventory_platform/data/repositories/item_repository.dart';
import 'package:inventory_platform/data/repositories/member_repository.dart';
import 'package:inventory_platform/data/repositories/reader_repository.dart';
import 'package:inventory_platform/data/repositories/tag_repository.dart';

class OrganizationRepository {
  List<OrganizationModel> _organizations = [];

  final DomainRepository _domainRepository = Get.find<DomainRepository>();
  final EntityRepository _entityRepository = Get.find<EntityRepository>();
  final InventoryRepository _inventoryRepository =
      Get.find<InventoryRepository>();
  final MemberRepository _memberRepository = Get.find<MemberRepository>();
  final ReaderRepository _readerRepository = Get.find<ReaderRepository>();
  final ItemRepository _itemRepository = Get.find<ItemRepository>();
  final TagRepository _tagRepository = Get.find<TagRepository>();

  Future<List<OrganizationModel>> getAllOrganizationsRep() async {
    CollectionReference departments = FirebaseFirestore.instance.collection('departments');

    QuerySnapshot querySnapshot = await departments.get();

    return _organizations = querySnapshot.docs.map((doc) {
      return OrganizationModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  List<OrganizationModel> getAllOrganizations() {
    getAllOrganizationsRep();
    return _organizations;
  }

  OrganizationModel? getOrganizationById(String id) {
    return _organizations.firstWhere((organization) => organization.id == id);
  }

  void addOrganization(OrganizationModel organization) {
    _organizations.add(organization);
  }

  void addAllOrganizations(List<OrganizationModel> organizations) {
    //_organizations.addAll(organizations);
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
    List<InventoryModel> allInventories =
        await _inventoryRepository.getInventoriesByDepartment(orgId);

    return allInventories;
  }

  Future<List<DomainModel>> getDomainsForOrganization(String orgId) async {
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

  Future<List<TagModel>> getTagsForOrganization(String orgId) async {
    List<TagModel> allTags = await _tagRepository.getAllTags();

    return allTags;
  }

  Future<List<ReaderModel>> getReadersForOrganization(String orgId) async {
    List<ReaderModel> allReaders = await _readerRepository.getAllReaders();

    return allReaders;
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

  Future<List<ItemModel>> getItemsForOrganization(String orgId) async {
    List<InventoryModel> list = await getInventoriesForOrganization(orgId);
    List<ItemModel> allItems = await _itemRepository.getAllItemsByOrganization(list,orgId);
    return allItems;
  }

  Future<List<EntityModel>> getEntitiesForOrganization(String orgId) async {
    List<EntityModel> allEntities = await _entityRepository.getAllEntities();

    return allEntities;
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

  void setTagsInOrganization(List<TagModel> items, String orgId) async {
    List<TagModel> allTags = await _tagRepository.getAllTags();

    _setItemsInOrganization(
        items,
        orgId,
        () => allTags,
        _tagRepository.addTag,
        _tagRepository.deleteTag,
        (org) => org.tags,
        (org, ids) => org.tags = ids);
  }

  Future<void> setReadersInOrganization(
      List<ReaderModel> items, String orgId) async {
    List<ReaderModel> allReaders = await _readerRepository.getAllReaders();

    _setItemsInOrganization(
        items,
        orgId,
        () => allReaders,
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

  Future<void> setEntitiesInOrganization(
      List<EntityModel> items, String orgId) async {
    List<EntityModel> allEntities = await _entityRepository.getAllEntities();

    _setItemsInOrganization(
        items,
        orgId,
        () => allEntities,
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

  void deleteInventoryFromOrganization(String orgId, String inventoryId) {
    _loadDataInOrganization(orgId, (org) {
      org.inventories?.remove(inventoryId);
      _inventoryRepository.deleteInventory(inventoryId);
    });
  }

  void updateInventoryInOrganization(
      String orgId, InventoryModel updatedInventory) {
    _loadDataInOrganization(orgId, (org) {
      // if (org.inventories?.contains(updatedInventory.id) ?? false) {
      _inventoryRepository.updateInventory(updatedInventory);
      // }
    });
  }

  void deleteDomainFromOrganization(String orgId, String domainId) {
    _loadDataInOrganization(orgId, (org) {
      org.domains?.remove(domainId);
      _domainRepository.deleteDomain(domainId);
    });
  }

  void updateDomainInOrganization(String orgId, DomainModel updatedDomain) {
    _loadDataInOrganization(orgId, (org) {
      // if (org.domains?.contains(updatedDomain.id) ?? false) {
      _domainRepository.updateDomain(updatedDomain);
      // }
    });
  }

  void deleteTagFromOrganization(String orgId, String tagId) {
    _loadDataInOrganization(orgId, (org) {
      org.tags?.remove(tagId);
      _tagRepository.deleteTag(tagId);
    });
  }

  void updateTagInOrganization(String orgId, TagModel updatedTag) {
    _loadDataInOrganization(orgId, (org) {
      // if (org.tags?.contains(updatedTag.id) ?? false) {
      _tagRepository.updateTag(updatedTag);
      // }
    });
  }

  void deleteReaderFromOrganization(String orgId, String readerMac) {
    _loadDataInOrganization(orgId, (org) {
      org.readers?.remove(readerMac);
      _readerRepository.deleteReader(readerMac);
    });
  }

  void updateReaderInOrganization(String orgId, ReaderModel updatedReader) {
    _loadDataInOrganization(orgId, (org) {
      // if (org.readers?.contains(updatedReader.mac) ?? false) {
      _readerRepository.updateReader(updatedReader);
      // }
    });
  }

  void deleteMemberFromOrganization(String orgId, String memberId) {
    _loadDataInOrganization(orgId, (org) {
      org.members?.remove(memberId);
      _memberRepository.deleteMember(memberId);
    });
  }

  void updateMemberInOrganization(String orgId, MemberModel updatedMember) {
    _loadDataInOrganization(orgId, (org) {
      // if (org.members?.contains(updatedMember.id) ?? false) {
      _memberRepository.updateMember(updatedMember);
      // }
    });
  }

  void deleteEntityFromOrganization(String orgId, String entityId) {
    _loadDataInOrganization(orgId, (org) {
      org.entities?.remove(entityId);
      _entityRepository.deleteEntity(entityId);
    });
  }

  void updateEntityInOrganization(String orgId, EntityModel updatedEntity) {
    _loadDataInOrganization(orgId, (org) {
      // if (org.entities?.contains(updatedEntity.id) ?? false) {
      _entityRepository.updateEntity(updatedEntity);
      // }
    });
  }

  Future<InventoryModel?> getInventoryById(
      String orgId, String inventoryId) async {
    List<InventoryModel> inventories =
        await getInventoriesForOrganization(orgId);
    return inventories
        .firstWhereOrNull((inventory) => inventory.id == inventoryId);
  }

  Future<DomainModel?> getDomainById(String orgId, String domainId) async {
    List<DomainModel> domains = await getDomainsForOrganization(orgId);
    return domains.firstWhereOrNull((domain) => domain.id == domainId);
  }

  Future<TagModel?> getTagById(String orgId, String tagId) async {
    List<TagModel> tags = await getTagsForOrganization(orgId);
    return tags.firstWhereOrNull((tag) => tag.id == tagId);
  }

  Future<ReaderModel?> getReaderById(String orgId, String readerMac) async {
    List<ReaderModel> readers = await getReadersForOrganization(orgId);
    return readers.firstWhereOrNull((reader) => reader.mac == readerMac);
  }

  MemberModel? getMemberById(String orgId, String memberId) {
    List<MemberModel> members = getMembersForOrganization(orgId);
    return members.firstWhereOrNull((member) => member.id == memberId);
  }

  Future<EntityModel?> getEntityById(String orgId, String entityId) async {
    List<EntityModel> entities = await getEntitiesForOrganization(orgId);
    return entities.firstWhereOrNull((entity) => entity.id == entityId);
  }
}
