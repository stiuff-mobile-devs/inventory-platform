import 'package:flutter/material.dart';
import 'package:inventory_platform/data/models/tag_model.dart';
import 'package:inventory_platform/features/common/widgets/custom_text_field.dart';

class TagForm extends StatefulWidget {
  final dynamic initialData;
  final bool? isFormReadOnly;

  const TagForm({
    super.key,
    this.initialData,
    this.isFormReadOnly,
  });

  @override
  TagFormState createState() => TagFormState();
}

class TagFormState extends State<TagForm> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _idController;
  late TextEditingController _serialController;

  TagModel get tagModel => TagModel(
        id: _idController.text,
        isActive: 1,
        createdAt: widget.initialData?.createdAt ?? DateTime.now(),
        lastSeen: DateTime.now(),
      );

  TagModel get prevTagModel => TagModel(
        id: widget.initialData?.id ?? _idController.text,
        isActive: 1,
        createdAt: widget.initialData?.createdAt ?? DateTime.now(),
        lastSeen: DateTime.now(),
      );

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController(text: widget.initialData?.id ?? '');
    _serialController = TextEditingController(
      text: _idController.text.length >= 6
          ? _idController.text.substring(_idController.text.length - 6)
          : _idController.text,
    );
  }

  @override
  void dispose() {
    _idController.dispose();
    _serialController.dispose();
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
            label: 'ID *',
            controller: _idController,
            showLength: false,
            maxLength: 24,
            onChanged: (value) {
              setState(() {
                _serialController.text = value.length >= 6
                    ? value.substring(value.length - 6)
                    : value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'O campo ID é obrigatório';
              }
              if (value.length < 24) {
                return 'O campo ID deve ter pelo menos 24 caracteres';
              }
              return null;
            },
            isReadOnly: widget.isFormReadOnly,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Serial',
            isReadOnly: true,
            controller: _serialController,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
