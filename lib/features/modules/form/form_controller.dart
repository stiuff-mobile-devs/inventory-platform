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
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';
import 'package:inventory_platform/core/debug/logger.dart';

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

  @override
  void onInit() {
    super.onInit();
    utilsService = UtilsService();
    panelController = Get.find<PanelController>();
    organizationRepository = Get.find<OrganizationRepository>();

    tabType = Get.arguments[0];
    currentOrganization = panelController.getCurrentOrganization()!;
  }

  Future<void> submitForm(dynamic formKey) async {
    bool isFormValid = false;
    dynamic formData;
    dynamic newFormData;

    switch (tabType) {
      case TabType.inventories:
        isFormValid = formKey.currentState?.submitForm() ?? false;
        formData = formKey.currentState?.inventoryModel;
        if (isFormValid) {
          await _handleInventorySubmission(formData);
        }
        break;
      case TabType.domains:
        isFormValid = (formKey.currentState)?.submitForm() ?? false;
        formData = (formKey.currentState)?.domainModel;
        if (isFormValid) {
          await _handleDomainSubmission(formData);
        }
        break;
      case TabType.tags:
        isFormValid = formKey.currentState?.submitForm() ?? false;
        formData = formKey.currentState?.prevTagModel;
        newFormData = formKey.currentState?.tagModel;

        if (isFormValid) {
          await _handleTagSubmission(formData, newFormData);
        }
        break;
      case TabType.readers:
        isFormValid = formKey.currentState?.submitForm() ?? false;
        formData = formKey.currentState?.prevReaderModel;
        newFormData = formKey.currentState?.readerModel;
        if (isFormValid) {
          await _handleReaderSubmission(formData, newFormData);
        }
        break;
      case TabType.members:
        isFormValid = formKey.currentState?.submitForm() ?? false;
        formData = formKey.currentState?.memberModel;
        if (isFormValid) {
          _handleMemberSubmission(formData);
        }
        break;
      case TabType.entities:
        isFormValid = formKey.currentState?.submitForm() ?? false;
        formData = formKey.currentState?.entityModel;
        if (isFormValid) {
          await _handleEntitySubmission(formData);
        }
        break;
      default:
        Logger.error('Tipo de formulário não reconhecido.');
        break;
    }

    if (isFormValid) {
      panelController.refreshPage();
      Logger.info('Formulário submetido com sucesso!');
      if (activeMode.value == 2) {
        activeMode.value = 1;
      } else {
        Get.back();
      }
    } else {
      Logger.error('Erro na validação do formulário.');
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
        Logger.error('Tipo de item não reconhecido.');
        break;
    }
    panelController.refreshPage();
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

  Future<void> _handleInventorySubmission(InventoryModel formData) async {
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

  Future<void> _handleDomainSubmission(DomainModel formData) async {
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

  Future<void> _handleTagSubmission(
      TagModel formData, TagModel? newFormData) async {
    TagModel? existingTag = await organizationRepository.getTagById(
        currentOrganization.id, formData.id);
    if (existingTag != null && newFormData != null) {
      organizationRepository.deleteTagFromOrganization(
          currentOrganization.id, formData.id);
      organizationRepository
          .appendTagsInOrganization([newFormData], currentOrganization.id);
    } else {
      organizationRepository
          .appendTagsInOrganization([formData], currentOrganization.id);
    }
  }

  Future<void> _handleReaderSubmission(
      ReaderModel formData, ReaderModel? newFormData) async {
    ReaderModel? existingReader = await organizationRepository.getReaderById(
        currentOrganization.id, formData.mac);
    if (existingReader != null && newFormData != null) {
      organizationRepository.deleteReaderFromOrganization(
          currentOrganization.id, formData.mac);
      organizationRepository
          .appendReadersInOrganization([newFormData], currentOrganization.id);
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

  Future<void> _handleEntitySubmission(EntityModel formData) async {
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
