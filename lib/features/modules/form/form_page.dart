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

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  FormPageState createState() => FormPageState();
}

class FormPageState extends State<FormPage> {
  final FormController controller = Get.put(FormController());

  GlobalKey<DomainFormState> formKey = GlobalKey<DomainFormState>();

  String getHeaderPrefix(int activeMode) {
    switch (activeMode) {
      case 0:
        return 'Adicionando';
      case 1:
        return 'Visualizando';
      case 2:
        return 'Editando';
      default:
        return 'Unavailable';
    }
  }

  @override
  void initState() {
    super.initState();
    if (Get.arguments.length > 1 && Get.arguments[1] != null) {
      controller.initialData = Get.arguments[1];
    }
    if (controller.initialData != null) controller.activeMode = 1.obs;
  }

  void _cancelForm() {
    setState(() {
      controller.activeMode = 1.obs;
      formKey = GlobalKey<DomainFormState>();
    });
  }

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
                Obx(() => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        '${getHeaderPrefix(controller.activeMode.value)} ${controller.utilsService.tabNameToSingular(controller.tabType)}',
                        style: const TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    )),
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
                Obx(() {
                  switch (controller.tabType) {
                    case TabType.inventories:
                      return InventoryForm(
                        key: formKey,
                        enabled: controller.activeMode.value != 1,
                        initialData: controller.initialData,
                      );
                    case TabType.domains:
                      return DomainForm(
                        key: formKey,
                        initialData: controller.initialData,
                        isFormReadOnly: controller.activeMode.value == 1,
                      );
                    case TabType.tags:
                      return TagForm(
                        key: formKey,
                        enabled: controller.activeMode.value != 1,
                        initialData: controller.initialData,
                      );
                    case TabType.readers:
                      return ReaderForm(
                        key: formKey,
                        enabled: controller.activeMode.value != 1,
                        initialData: controller.initialData,
                      );
                    case TabType.members:
                      return MemberForm(
                        key: formKey,
                        enabled: controller.activeMode.value != 1,
                        initialData: controller.initialData,
                      );
                    case TabType.entities:
                      return EntityForm(
                        key: formKey,
                        enabled: controller.activeMode.value != 1,
                        initialData: controller.initialData,
                      );
                    default:
                      return Container();
                  }
                }),
                Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (controller.activeMode.value == 0 ||
                            controller.activeMode.value == 2)
                          Row(
                            children: [
                              (controller.activeMode.value == 2)
                                  ? TextButton(
                                      onPressed: _cancelForm,
                                      child: const Text(
                                        'Cancelar',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              const SizedBox(width: 16.0),
                              TextButton(
                                onPressed: () => controller.submitForm(formKey),
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                  ),
                                  foregroundColor:
                                      WidgetStateProperty.all(Colors.white),
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.blue),
                                  textStyle: WidgetStateProperty.all(
                                    const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.save_rounded),
                                    SizedBox(width: 8.0),
                                    Text('Salvar'),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    controller.activeMode = 2.obs;
                                  });
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                  ),
                                  foregroundColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                    Colors.orange.withOpacity(0.8),
                                  ),
                                  textStyle: WidgetStateProperty.all(
                                    const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(Icons.edit),
                                    SizedBox(width: 8.0),
                                    Text('Editar'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              TextButton(
                                onPressed: () {
                                  controller.deleteItem();
                                },
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0),
                                  ),
                                  foregroundColor: WidgetStateProperty.all(
                                    Colors.white,
                                  ),
                                  backgroundColor: WidgetStateProperty.all(
                                    Colors.red,
                                  ),
                                  textStyle: WidgetStateProperty.all(
                                    const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.delete_forever),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      'Deletar ${controller.utilsService.tabNameToSingular(controller.tabType)}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(width: 6.0),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
