import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/data/models/entity_model.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/models/member_model.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';
import 'package:inventory_platform/features/modules/form/widgets/domain_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/entity_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/inventory_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/member_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/reader_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/tag_form.dart';
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';

class FormController extends GetxController {
  late final UtilsService utilsService;
  late final TabType tabType;
  late final OrganizationModel currentOrganization;
  late final OrganizationRepository organizationRepository;
  late final PanelController panelController;

  //**
  // 0 == Create
  // 1 == Read
  // 2 == Edit
  // */
  RxInt activeMode = 0.obs;
  dynamic initialData;

  final inventoryFormKey = GlobalKey<InventoryFormState>();
  final domainFormKey = GlobalKey<DomainFormState>();
  final tagFormKey = GlobalKey<TagFormState>();
  final readerFormKey = GlobalKey<ReaderFormState>();
  final memberFormKey = GlobalKey<MemberFormState>();
  final entityFormKey = GlobalKey<EntityFormState>();

  @override
  void onInit() {
    super.onInit();
    utilsService = UtilsService();
    panelController = Get.find<PanelController>();
    organizationRepository = Get.find<OrganizationRepository>();

    tabType = Get.arguments[0];
    currentOrganization = panelController.getCurrentOrganization();
  }

  void submitForm(GlobalKey<DomainFormState> formKey) {
    bool isFormValid = false;
    dynamic formData;

    switch (tabType) {
      case TabType.inventories:
        isFormValid = inventoryFormKey.currentState?.submitForm() ?? false;
        formData = inventoryFormKey.currentState?.inventoryModel;
        if (isFormValid) {
          _handleInventorySubmission(formData);
        }
        break;
      case TabType.domains:
        isFormValid = (formKey.currentState)?.submitForm() ?? false;
        formData = (formKey.currentState)?.domainModel;
        if (isFormValid) {
          _handleDomainSubmission(formData);
        }
        break;
      case TabType.tags:
        isFormValid = tagFormKey.currentState?.submitForm() ?? false;
        formData = tagFormKey.currentState?.tagModel;
        if (isFormValid) {
          _handleTagSubmission(formData);
        }
        break;
      case TabType.readers:
        isFormValid = readerFormKey.currentState?.submitForm() ?? false;
        formData = readerFormKey.currentState?.readerModel;
        if (isFormValid) {
          _handleReaderSubmission(formData);
        }
        break;
      case TabType.members:
        isFormValid = memberFormKey.currentState?.submitForm() ?? false;
        formData = memberFormKey.currentState?.memberModel;
        if (isFormValid) {
          _handleMemberSubmission(formData);
        }
        break;
      case TabType.entities:
        isFormValid = entityFormKey.currentState?.submitForm() ?? false;
        formData = entityFormKey.currentState?.entityModel;
        if (isFormValid) {
          _handleEntitySubmission(formData);
        }
        break;
      default:
        debugPrint('Tipo de formulário não reconhecido.');
        break;
    }

    if (isFormValid) {
      panelController.refreshItemsAndPaging();
      debugPrint('Formulário submetido com sucesso!');
      if (activeMode.value == 2) {
        activeMode.value = 1;
      } else {
        Get.back();
      }
    } else {
      debugPrint('Erro na validação do formulário.');
    }
  }

  void deleteItem() {
    switch (tabType) {
      case TabType.inventories:
        InventoryModel data = initialData;
        _deleteInventory(data.id);
        break;
      case TabType.domains:
        DomainModel data = initialData;
        _deleteDomain(data.id);
        break;
      case TabType.tags:
        TagModel data = initialData;
        _deleteTag(data.id);
        break;
      case TabType.readers:
        ReaderModel data = initialData;
        _deleteReader(data.mac);
        break;
      case TabType.members:
        TagModel data = initialData;
        _deleteMember(data.id);
        break;
      case TabType.entities:
        EntityModel data = initialData;
        _deleteEntity(data.id);
        break;
      default:
        debugPrint('Tipo de item não reconhecido.');
        break;
    }
    panelController.refreshItemsAndPaging();
    Get.back();
  }

  void _deleteInventory(String id) {
    organizationRepository.deleteInventoryFromOrganization(
        currentOrganization.id, id);
  }

  void _deleteDomain(String id) {
    organizationRepository.deleteDomainFromOrganization(
        currentOrganization.id, id);
  }

  void _deleteTag(String id) {
    organizationRepository.deleteTagFromOrganization(
        currentOrganization.id, id);
  }

  void _deleteReader(String id) {
    organizationRepository.deleteReaderFromOrganization(
        currentOrganization.id, id);
  }

  void _deleteMember(String id) {
    organizationRepository.deleteMemberFromOrganization(
        currentOrganization.id, id);
  }

  void _deleteEntity(String id) {
    organizationRepository.deleteEntityFromOrganization(
        currentOrganization.id, id);
  }

  void _handleInventorySubmission(InventoryModel formData) async {
    InventoryModel? existingInventory = await organizationRepository
        .getInventoryById(currentOrganization.id, formData.id);
    if (existingInventory != null) {
      organizationRepository.updateInventoryInOrganization(
          currentOrganization.id, formData);
    } else {
      organizationRepository
          .appendInventoriesInOrganization([formData], currentOrganization.id);
    }
  }

  void _handleDomainSubmission(DomainModel formData) async {
    DomainModel? existingDomain = await organizationRepository.getDomainById(
        currentOrganization.id, formData.id);
    if (existingDomain != null) {
      organizationRepository.updateDomainInOrganization(
          currentOrganization.id, formData);
    } else {
      organizationRepository
          .appendDomainsInOrganization([formData], currentOrganization.id);
    }
  }

  void _handleTagSubmission(TagModel formData) async {
    TagModel? existingTag = await organizationRepository.getTagById(
        currentOrganization.id, formData.id);
    if (existingTag != null) {
      organizationRepository.updateTagInOrganization(
          currentOrganization.id, formData);
    } else {
      organizationRepository
          .appendTagsInOrganization([formData], currentOrganization.id);
    }
  }

  void _handleReaderSubmission(ReaderModel formData) async {
    ReaderModel? existingReader = await organizationRepository.getReaderById(
        currentOrganization.id, formData.mac);
    if (existingReader != null) {
      organizationRepository.updateReaderInOrganization(
          currentOrganization.id, formData);
    } else {
      organizationRepository
          .appendReadersInOrganization([formData], currentOrganization.id);
    }
  }

  void _handleMemberSubmission(MemberModel formData) {
    MemberModel? existingMember = organizationRepository.getMemberById(
        currentOrganization.id, formData.id);
    if (existingMember != null) {
      organizationRepository.updateMemberInOrganization(
          currentOrganization.id, formData);
    } else {
      organizationRepository
          .appendMembersInOrganization([formData], currentOrganization.id);
    }
  }

  void _handleEntitySubmission(EntityModel formData) async {
    EntityModel? existingEntity = await organizationRepository.getEntityById(
        currentOrganization.id, formData.id);
    if (existingEntity != null) {
      organizationRepository.updateEntityInOrganization(
          currentOrganization.id, formData);
    } else {
      organizationRepository
          .appendEntitiesInOrganization([formData], currentOrganization.id);
    }
  }
}
