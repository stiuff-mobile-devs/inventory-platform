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

  GlobalKey<DomainFormState> domainFormKey = GlobalKey<DomainFormState>();
  /*GlobalKey<InventoryFormState> inventoryFormKey =
      GlobalKey<InventoryFormState>();*/
  GlobalKey<TagFormState> tagFormKey = GlobalKey<TagFormState>();
  GlobalKey<ReaderFormState> readerFormKey = GlobalKey<ReaderFormState>();
  GlobalKey<MemberFormState> memberFormKey = GlobalKey<MemberFormState>();
  GlobalKey<EntityFormState> entityFormKey = GlobalKey<EntityFormState>();

  String getHeaderPrefix(int activeMode) {
    const modeLabels = {
      0: 'Adicionando',
      1: 'Visualizando',
      2: 'Editando',
    };
    return modeLabels[activeMode] ?? 'Unavailable';
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
    controller.activeMode.value = 1;

    final formKeys = {
    /*  TabType.inventories: () =>
          inventoryFormKey = GlobalKey<InventoryFormState>(),*/
      TabType.domains: () => domainFormKey = GlobalKey<DomainFormState>(),
      TabType.tags: () => tagFormKey = GlobalKey<TagFormState>(),
      TabType.readers: () => readerFormKey = GlobalKey<ReaderFormState>(),
      TabType.members: () => memberFormKey = GlobalKey<MemberFormState>(),
      TabType.entities: () => entityFormKey = GlobalKey<EntityFormState>(),
    };

    formKeys[controller.tabType]?.call();
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
                _buildHeader(),
                _buildOrganizationBadge(),
                const SizedBox(height: 20),
                Obx(() => _buildForm()),
                Obx(() => _buildActionButtons()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          '${getHeaderPrefix(controller.activeMode.value)} '
          '${controller.utilsService.tabNameToSingular(controller.tabType)}',
          style: const TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildOrganizationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
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
    );
  }

  Widget _buildForm() {
    final formMap = {
      /*TabType.inventories: () => InventoryForm(
            key: inventoryFormKey,
            initialData: controller.initialData,
            isFormReadOnly: controller.activeMode.value == 1,
          ),*/
      TabType.domains: () => DomainForm(
            key: domainFormKey,
            initialData: controller.initialData,
            isFormReadOnly: controller.activeMode.value == 1,
          ),
      TabType.tags: () => TagForm(
            key: tagFormKey,
            initialData: controller.initialData,
            isFormReadOnly: controller.activeMode.value == 1,
          ),
      TabType.readers: () => ReaderForm(
            key: readerFormKey,
            initialData: controller.initialData,
            isFormReadOnly: controller.activeMode.value == 1,
          ),
      TabType.members: () => MemberForm(
            key: memberFormKey,
            enabled: controller.activeMode.value != 1,
            initialData: controller.initialData,
          ),
      TabType.entities: () => EntityForm(
            key: entityFormKey,
            enabled: controller.activeMode.value != 1,
            initialData: controller.initialData,
          ),
    };

    return formMap[controller.tabType]?.call() ?? const SizedBox.shrink();
  }

  Widget _buildActionButtons() {
    if (controller.activeMode.value == 0 || controller.activeMode.value == 2) {
      return _buildEditModeButtons();
    } else {
      return _buildViewModeButtons();
    }
  }

  Widget _buildEditModeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (controller.activeMode.value == 2)
          TextButton(
            onPressed: _cancelForm,
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.red),
            ),
          ),
        const SizedBox(width: 16.0),
        _buildSaveButton(),
      ],
    );
  }

  Widget _buildSaveButton() {
    return TextButton(
      onPressed: () => _submitForm(),
      style: _buttonStyle(Colors.blue),
      child: const Row(
        children: [
          Icon(Icons.save_rounded),
          SizedBox(width: 8.0),
          Text('Salvar'),
        ],
      ),
    );
  }

  Widget _buildViewModeButtons() {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildEditButton(),
          const SizedBox(height: 16.0),
          _buildDeleteButton(),
        ],
      ),
    );
  }

  Widget _buildEditButton() {
    return TextButton(
      onPressed: () => controller.activeMode.value = 2,
      style: _buttonStyle(Colors.orange.withOpacity(0.8)),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit),
          SizedBox(width: 8.0),
          Text('Editar'),
        ],
      ),
    );
  }

  Widget _buildDeleteButton() {
    return TextButton(
      onPressed: () => controller.deleteItem(),
      style: _buttonStyle(Colors.red),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.delete_forever),
          const SizedBox(width: 8.0),
          Text(
            'Deletar ${controller.utilsService.tabNameToSingular(controller.tabType)}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle(Color color) {
    return ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      ),
      foregroundColor: WidgetStateProperty.all(Colors.white),
      backgroundColor: WidgetStateProperty.all(color),
      textStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  void _submitForm() {
    final formMap = {
     // TabType.inventories: inventoryFormKey,
      TabType.domains: domainFormKey,
      TabType.tags: tagFormKey,
      TabType.readers: readerFormKey,
      TabType.members: memberFormKey,
      TabType.entities: entityFormKey,
    };

    controller.submitForm(formMap[controller.tabType]);
  }
}
