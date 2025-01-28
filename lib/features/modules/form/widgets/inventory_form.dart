import 'package:flutter/material.dart';
import 'package:inventory_platform/data/models/inventory_model.dart';
import 'package:inventory_platform/data/repositories/inventory_repository.dart';
import 'package:inventory_platform/features/common/widgets/custom_text_field.dart';

class InventoryForm extends StatefulWidget {
  final dynamic initialData;
  final bool? isFormReadOnly;

  const InventoryForm({
    super.key,
    this.initialData,
    this.isFormReadOnly,
  });

  @override
  InventoryFormState createState() => InventoryFormState();
}

class InventoryFormState extends State<InventoryForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _revisionController;

  final InventoryRepository _inventoryRepository = InventoryRepository();

  InventoryModel get inventoryModel => InventoryModel(
        id: widget.initialData?.id ?? _inventoryRepository.generateUniqueId(),
        title: _titleController.text,
        description: _descriptionController.text,
        revisionNumber: _revisionController.text,
        isActive: 1,
        createdAt: widget.initialData?.createdAt ?? DateTime.now(),
        lastUpdatedAt: DateTime.now(),
      );

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialData?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.initialData?.description ?? '');
    _revisionController =
        TextEditingController(text: widget.initialData?.revisionNumber ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _revisionController.dispose();
    super.dispose();
  }

  bool submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            label: 'Título *',
            controller: _titleController,
            hint: 'Ex.: Meu Novo Inventário',
            validator: (value) =>
                value == null || value.isEmpty ? 'Título é obrigatório' : null,
            isReadOnly: widget.isFormReadOnly,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Descrição',
            controller: _descriptionController,
            hint: 'Ex.: Um inventário de sazonalidade',
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            isReadOnly: widget.isFormReadOnly,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Número de Revisão *',
            controller: _revisionController,
            hint: 'Ex.: 1.0.0',
            validator: (value) => value == null || value.isEmpty
                ? 'Número de Revisão é obrigatório'
                : null,
            isReadOnly: widget.isFormReadOnly,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
