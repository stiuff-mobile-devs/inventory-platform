import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inventory_platform/features/common/widgets/custom_text_field.dart';
import 'package:inventory_platform/features/modules/form/controllers/inventory_controller.dart';

class InventoryForm extends StatelessWidget {
  final InventoryController controller = Get.find<InventoryController>();
  final String cod;

  InventoryForm({required this.cod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const  Text("Criar Novo Inventário", style: TextStyle(color: Colors.white),), ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           CustomTextField(
            label: 'Título *',
            controller: controller.titleController,
            hint: 'Ex.: Meu Novo Inventário',
            validator: (value) =>
                value == null || value.isEmpty ? 'Título é obrigatório' : null,
            ),
             const SizedBox(height: 10),
            CustomTextField(
              label: 'Descrição',
              controller: controller.descriptionController,
              hint: 'Ex.: Um inventário de sazonalidade',
              maxLines: 3,
              keyboardType: TextInputType.multiline,
            ),
            const SizedBox(height: 10),
          CustomTextField(
            label: 'Número de Revisão *',
            controller: controller.revisionController,
            hint: 'Ex.: 1.0.0',
            validator: (value) => value == null || value.isEmpty
                ? 'Número de Revisão é obrigatório'
                : null,
          ),
          const SizedBox(height: 20),
             ElevatedButton(
            onPressed: controller.isLoading.value ? null : () {
                controller.saveInventory(context);
            },
            child: controller.isLoading.value
                ? const CircularProgressIndicator()
                : const Text('Salvar Inventário'),
          ),
          ],
        ),
      ),
    );
  }
}

