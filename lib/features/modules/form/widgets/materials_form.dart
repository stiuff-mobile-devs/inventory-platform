import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:inventory_platform/features/modules/form/controllers/materials_controller.dart';

class MaterialsForm extends StatefulWidget {
  late final String cod;
  MaterialsForm({required this.cod});
  
  @override
  _MaterialsFormState createState() => _MaterialsFormState();
}

class _MaterialsFormState extends State<MaterialsForm> {
  MockService mockService = Get.find<MockService>();
  final MaterialsController controller = Get.find<MaterialsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Novo Departamento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.barcodeController,
              decoration: const InputDecoration(labelText: "Código de Barras"),
            ),
            TextField(
              controller: controller.dateController,
              decoration: const InputDecoration(labelText: "Data"),
            ),
            TextField(
              controller: controller.descriptionController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            TextField(
              controller: controller.geolocationController,
              decoration: const InputDecoration(labelText: "Geolocalização"),
            ),
            TextField(
              controller: controller.locationController,
              decoration: const InputDecoration(labelText: "Localização"),
            ),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: controller.observations,
              decoration: const InputDecoration(labelText: "Observações"),
            ),
            const SizedBox(height: 10),
            controller.image == null
                ? const Text("Nenhuma imagem selecionada")
                : Image.file(controller.image!, height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera),
                  onPressed: () => controller.pickImage(ImageSource.camera),
                ),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => controller.pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),
            controller.isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () => controller.saveMaterial(context),
                    child: const Text("Salvar Material"),
                  ),
          ],
        ),
      ),
    );
  }
}
