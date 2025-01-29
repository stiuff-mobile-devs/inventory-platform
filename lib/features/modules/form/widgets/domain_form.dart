import 'package:flutter/material.dart';
import 'package:inventory_platform/data/models/domain_model.dart';
import 'package:inventory_platform/data/repositories/domain_repository.dart';
import 'package:inventory_platform/features/common/widgets/custom_text_field.dart';

class DomainForm extends StatefulWidget {
  final DomainModel? initialData;
  final bool? isFormReadOnly;

  const DomainForm({
    super.key,
    this.initialData,
    this.isFormReadOnly,
  });

  @override
  DomainFormState createState() => DomainFormState();
}

class DomainFormState extends State<DomainForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _capacityController;

  final DomainRepository _domainRepository = DomainRepository();

  DomainModel get domainModel => DomainModel(
        id: widget.initialData?.id ?? _domainRepository.generateUniqueId(),
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        capacity: int.tryParse(_capacityController.text),
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
    _locationController =
        TextEditingController(text: widget.initialData?.location ?? '');
    _capacityController = TextEditingController(
        text: widget.initialData?.capacity?.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
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
            hint: 'Ex.: Meu Novo Domínio',
            validator: (value) =>
                value == null || value.isEmpty ? 'Título é obrigatório' : null,
            isReadOnly: widget.isFormReadOnly,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Descrição',
            controller: _descriptionController,
            hint: 'Ex.: Um domínio com dados variados',
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            isReadOnly: widget.isFormReadOnly,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Localização',
            controller: _locationController,
            hint: 'Ex.: Armazenamento principal',
            isReadOnly: widget.isFormReadOnly,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Capacidade',
            controller: _capacityController,
            hint: 'Ex.: 500',
            keyboardType: TextInputType.number,
            isReadOnly: widget.isFormReadOnly,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
