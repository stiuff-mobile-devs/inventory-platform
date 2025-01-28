import 'package:flutter/material.dart';
import 'package:inventory_platform/data/models/reader_model.dart';
import 'package:inventory_platform/features/common/widgets/custom_text_field.dart';

class ReaderForm extends StatefulWidget {
  final dynamic initialData;
  final bool? isFormReadOnly;

  const ReaderForm({
    super.key,
    this.initialData,
    this.isFormReadOnly,
  });

  @override
  ReaderFormState createState() => ReaderFormState();
}

class ReaderFormState extends State<ReaderForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _macController;

  ReaderModel get readerModel => ReaderModel(
        name: _nameController.text,
        mac: _macController.text,
        isActive: 1,
        createdAt: widget.initialData?.createdAt ?? DateTime.now(),
        lastSeen: DateTime.now(),
      );

  ReaderModel get prevReaderModel => ReaderModel(
        name: _nameController.text,
        mac: widget.initialData?.mac ?? _macController.text,
        isActive: 1,
        createdAt: widget.initialData?.createdAt ?? DateTime.now(),
        lastSeen: DateTime.now(),
      );

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialData?.name ?? '');
    _macController = TextEditingController(text: widget.initialData?.mac ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _macController.dispose();
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
            label: 'Nome *',
            controller: _nameController,
            hint: 'Ex.: Leitor Principal',
            validator: (value) =>
                value == null || value.isEmpty ? 'Nome é obrigatório' : null,
            isReadOnly: widget.isFormReadOnly,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'MAC Address *',
            maxLength: 17,
            controller: _macController,
            hint: 'Ex.: 00:14:22:01:23:45',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'MAC Address é obrigatório';
              }
              if (value.length < 17) {
                return 'MAC Address deve ter pelo menos 17 caracteres';
              }
              return null;
            },
            isReadOnly: widget.isFormReadOnly,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
