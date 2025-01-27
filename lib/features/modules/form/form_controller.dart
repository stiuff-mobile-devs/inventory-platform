import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
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

  void submitForm() {
    bool isFormValid = false;
    dynamic formData;

    switch (tabType) {
      case TabType.inventories:
        isFormValid = inventoryFormKey.currentState?.submitForm() ?? false;
        formData = inventoryFormKey.currentState?.inventoryModel;
        if (isFormValid) {
          organizationRepository.appendInventoriesInOrganization(
              [formData], currentOrganization.id);
        }
        break;
      case TabType.domains:
        isFormValid = domainFormKey.currentState?.submitForm() ?? false;
        formData = domainFormKey.currentState?.domainModel;
        if (isFormValid) {
          organizationRepository
              .appendDomainsInOrganization([formData], currentOrganization.id);
        }
        break;
      case TabType.tags:
        isFormValid = tagFormKey.currentState?.submitForm() ?? false;
        formData = tagFormKey.currentState?.tagModel;
        if (isFormValid) {
          organizationRepository
              .appendTagsInOrganization([formData], currentOrganization.id);
        }
        break;
      case TabType.readers:
        isFormValid = readerFormKey.currentState?.submitForm() ?? false;
        formData = readerFormKey.currentState?.readerModel;
        if (isFormValid) {
          organizationRepository
              .appendReadersInOrganization([formData], currentOrganization.id);
        }
        break;
      case TabType.members:
        isFormValid = memberFormKey.currentState?.submitForm() ?? false;
        formData = memberFormKey.currentState?.memberModel;
        if (isFormValid) {
          organizationRepository
              .appendMembersInOrganization([formData], currentOrganization.id);
        }
        break;
      case TabType.entities:
        isFormValid = entityFormKey.currentState?.submitForm() ?? false;
        formData = entityFormKey.currentState?.entityModel;
        if (isFormValid) {
          organizationRepository
              .appendEntitiesInOrganization([formData], currentOrganization.id);
        }
        break;
      default:
        debugPrint('Tipo de formulário não reconhecido.');
        break;
    }

    if (isFormValid) {
      panelController.refreshItemsAndPaging();
      debugPrint('Formulário submetido com sucesso!');
      Get.back();
    } else {
      debugPrint('Erro na validação do formulário.');
    }
  }
}
