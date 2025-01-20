import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/core/services/utils_service.dart';
import 'package:inventory_platform/features/common/widgets/base_scaffold.dart';
import 'package:inventory_platform/features/modules/form/widgets/domain_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/inventory_form.dart';

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
  late final String organizationName;

  final GlobalKey<InventoryFormState> _inventoryFormKey =
      GlobalKey<InventoryFormState>();
  final GlobalKey<DomainFormState> _domainFormKey =
      GlobalKey<DomainFormState>();

  @override
  void initState() {
    super.initState();
    _utilsService = UtilsService();
    tabType = Get.arguments[0];
    organizationName = Get.arguments[1];
  }

  void _submitForm() {
    bool isFormValid = false;

    if (tabType == TabType.inventories) {
      isFormValid = _inventoryFormKey.currentState?.submitForm() ?? false;
      if (isFormValid) {
        final inventoryData = _inventoryFormKey.currentState?.formData;
        debugPrint('Dados do InventoryModel: $inventoryData');
      }
    } else if (tabType == TabType.domains) {
      isFormValid = _domainFormKey.currentState?.submitForm() ?? false;
      if (isFormValid) {
        final domainData = _domainFormKey.currentState?.formData;
        debugPrint('Dados do DomainModel: $domainData');
      }
    }

    if (isFormValid) {
      debugPrint('Formulário submetido com sucesso!');
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
                    organizationName,
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
