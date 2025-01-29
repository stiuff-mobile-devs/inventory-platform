import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:inventory_platform/data/models/entity_model.dart';
import 'package:inventory_platform/data/repositories/entity_repository.dart';
import 'package:inventory_platform/features/common/widgets/custom_text_field.dart';

class EntityForm extends StatefulWidget {
  final bool? enabled;
  final dynamic initialData;
  final Color? labelColor;

  const EntityForm({
    super.key,
    this.enabled,
    this.initialData,
    this.labelColor,
  });

  @override
  EntityFormState createState() => EntityFormState();
}

class EntityFormState extends State<EntityForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _typeController = TextEditingController();
  final _attributesController = TextEditingController();

  final EntityRepository _entityRepository = EntityRepository();

  EntityModel get entityModel => EntityModel(
        id: _entityRepository.generateUniqueId(),
        title: _titleController.text,
        type: _typeController.text,
        attributes: _parseAttributes(_attributesController.text),
        createdAt: DateTime.now(),
      );

  @override
  void dispose() {
    _titleController.dispose();
    _typeController.dispose();
    _attributesController.dispose();
    super.dispose();
  }

  bool submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      return true;
    }
    return false;
  }

  Map<String, dynamic>? _parseAttributes(String attributes) {
    if (attributes.isEmpty) return null;
    try {
      return Map<String, dynamic>.from(json.decode(attributes));
    } catch (e) {
      return null;
    }
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
            hint: 'Ex.: Minha Nova Entidade',
            validator: (value) =>
                value == null || value.isEmpty ? 'Título é obrigatório' : null,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Tipo *',
            controller: _typeController,
            hint: 'Ex.: Tipo de Entidade',
            validator: (value) =>
                value == null || value.isEmpty ? 'Tipo é obrigatório' : null,
          ),
          const SizedBox(height: 10),
          CustomTextField(
            label: 'Atributos',
            controller: _attributesController,
            hint: 'Ex.: {"chave": "valor"}',
            maxLines: 3,
            keyboardType: TextInputType.multiline,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
