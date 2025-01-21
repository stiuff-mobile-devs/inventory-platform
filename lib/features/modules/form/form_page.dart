import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/data/models/organization_model.dart';
import 'package:inventory_platform/data/repositories/organization_repository.dart';
import 'package:inventory_platform/features/common/widgets/base_scaffold.dart';
import 'package:inventory_platform/features/modules/form/widgets/domain_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/entity_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/inventory_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/member_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/reader_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/tag_form.dart';
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';

class FormPage extends StatefulWidget {
  const FormPage({
    super.key,
  });

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  late final UtilsService _utilsService;
  late final TabType tabType;
  late final OrganizationModel _currentOrganization;

  late final PanelController _panelController;

  late OrganizationRepository _organizationRepository;

  late final GlobalKey<InventoryFormState> _inventoryFormKey;
  late final GlobalKey<DomainFormState> _domainFormKey;
  late final GlobalKey<TagFormState> _tagFormKey;
  late final GlobalKey<ReaderFormState> _readerFormKey;
  late final GlobalKey<MemberFormState> _memberFormKey;
  late final GlobalKey<EntityFormState> _entityFormKey;

  @override
  void initState() {
    super.initState();
    _panelController = Get.find<PanelController>();
    _organizationRepository = Get.find<OrganizationRepository>();

    _utilsService = UtilsService();

    tabType = Get.arguments[0];

    _currentOrganization = _panelController.getCurrentOrganization();

    _inventoryFormKey = GlobalKey<InventoryFormState>();
    _domainFormKey = GlobalKey<DomainFormState>();
    _tagFormKey = GlobalKey<TagFormState>();
    _readerFormKey = GlobalKey<ReaderFormState>();
    _memberFormKey = GlobalKey<MemberFormState>();
    _entityFormKey = GlobalKey<EntityFormState>();
  }

  void _submitForm() {
    bool isFormValid = false;
    dynamic formData;

    switch (tabType) {
      case TabType.inventories:
        isFormValid = _inventoryFormKey.currentState?.submitForm() ?? false;
        formData = _inventoryFormKey.currentState?.inventoryModel;
        if (isFormValid) {
          _organizationRepository.appendInventoriesInOrganization(
              [formData], _currentOrganization.id);
        }
        break;
      case TabType.domains:
        isFormValid = _domainFormKey.currentState?.submitForm() ?? false;
        formData = _domainFormKey.currentState?.domainModel;
        if (isFormValid) {
          _organizationRepository
              .appendDomainsInOrganization([formData], _currentOrganization.id);
        }
        break;
      case TabType.tags:
        isFormValid = _tagFormKey.currentState?.submitForm() ?? false;
        formData = _tagFormKey.currentState?.tagModel;
        if (isFormValid) {
          _organizationRepository
              .appendTagsInOrganization([formData], _currentOrganization.id);
        }
        break;
      case TabType.readers:
        isFormValid = _readerFormKey.currentState?.submitForm() ?? false;
        formData = _readerFormKey.currentState?.readerModel;
        if (isFormValid) {
          _organizationRepository
              .appendReadersInOrganization([formData], _currentOrganization.id);
        }
        break;
      case TabType.members:
        isFormValid = _memberFormKey.currentState?.submitForm() ?? false;
        formData = _memberFormKey.currentState?.memberModel;
        if (isFormValid) {
          _organizationRepository
              .appendMembersInOrganization([formData], _currentOrganization.id);
        }
        break;
      case TabType.entities:
        isFormValid = _entityFormKey.currentState?.submitForm() ?? false;
        formData = _entityFormKey.currentState?.entityModel;
        if (isFormValid) {
          _organizationRepository.appendEntitiesInOrganization(
              [formData], _currentOrganization.id);
        }
        break;
      default:
        debugPrint('Tipo de formulário não reconhecido.');
        break;
    }

    if (isFormValid) {
      _panelController.refreshItemsAndPaging();

      debugPrint('Formulário submetido com sucesso!');
      Get.back();
    } else {
      debugPrint('Erro na validação do formulário.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BaseScaffold(
        hideTitle: true,
        showBackButton: true,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Adicionar ${_utilsService.tabNameToSingular(tabType)}',
                    style: const TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade700,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    _currentOrganization.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (tabType == TabType.inventories)
                  InventoryForm(key: _inventoryFormKey),
                if (tabType == TabType.domains) DomainForm(key: _domainFormKey),
                if (tabType == TabType.tags) TagForm(key: _tagFormKey),
                if (tabType == TabType.readers) ReaderForm(key: _readerFormKey),
                if (tabType == TabType.members) MemberForm(key: _memberFormKey),
                if (tabType == TabType.entities)
                  EntityForm(key: _entityFormKey),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextButton(
                        onPressed: _submitForm,
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(
                              vertical: 16.0,
                            ),
                          ),
                          foregroundColor: WidgetStateProperty.all(
                            Colors.white,
                          ),
                          textStyle: WidgetStateProperty.all(
                            const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: WidgetStateProperty.all(
                            Colors.blue.withOpacity(0.8),
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: const Text('Salvar'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
