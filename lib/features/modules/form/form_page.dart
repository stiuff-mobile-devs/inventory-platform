import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/core/enums/tab_type_enum.dart';
import 'package:inventory_platform/features/common/widgets/base_scaffold.dart';
import 'package:inventory_platform/features/modules/form/form_controller.dart';
import 'package:inventory_platform/features/modules/form/widgets/domain_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/entity_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/inventory_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/member_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/reader_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/tag_form.dart';

class FormPage extends StatelessWidget {
  final FormController controller = Get.put(FormController());

  FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                    'Adicionar ${controller.utilsService.tabNameToSingular(controller.tabType)}',
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
                    controller.currentOrganization.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (controller.tabType == TabType.inventories)
                  InventoryForm(key: controller.inventoryFormKey),
                if (controller.tabType == TabType.domains)
                  DomainForm(key: controller.domainFormKey),
                if (controller.tabType == TabType.tags)
                  TagForm(key: controller.tagFormKey),
                if (controller.tabType == TabType.readers)
                  ReaderForm(key: controller.readerFormKey),
                if (controller.tabType == TabType.members)
                  MemberForm(key: controller.memberFormKey),
                if (controller.tabType == TabType.entities)
                  EntityForm(key: controller.entityFormKey),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextButton(
                        onPressed: controller.submitForm,
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.symmetric(vertical: 16.0),
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
