import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  bool _isLoading = false;

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

  Future<void> _saveInventory() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos e selecione uma imagem.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Verifique se o usuário está autenticado
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não autenticado.")),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }


   
     // Obtém a referência da coleção existente "inventories"
     String departmentId = "EsQDsCXUBXsL9NKOoih5"; // Substituir pelo ID correto

    // Obtendo a referência do documento do departamento específico
    DocumentReference departmentRef = FirebaseFirestore.instance
        .collection("departments")
        .doc(departmentId);

    // Adicionando um novo documento na subcoleção "inventories"
    await departmentRef.collection("inventories").add({
      "title": _titleController.text.trim(),
      "description": _descriptionController.text.trim(),
      "revision_number": _revisionController.text.trim(),
      "created_at": FieldValue.serverTimestamp(),
      "created_by": user.uid,
    });


      // Feedback de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Departamento e inventário criados com sucesso!")),
      );

      // Voltar para a tela anterior
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar departamento: $e")),
      );
    }

    setState(() {
      _isLoading = false;
    });
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
          ElevatedButton(
            onPressed: _isLoading ? null : _saveInventory,
            child: _isLoading
                ? CircularProgressIndicator()
                : Text('Salvar Inventário'),
          ),
        ],
      ),
    );
  }
}
