import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_platform/features/modules/form/widgets/inventory_form.dart';
import 'package:inventory_platform/features/modules/form/widgets/materials_form.dart';
import 'package:inventory_platform/features/modules/panel/panel_controller.dart';

class MaterialsController extends GetxController {
  
  final _panelController = Get.find<PanelController>();

  final TextEditingController barcodeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController geolocationController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController observations = TextEditingController();

  File? image;
  final ImagePicker picker = ImagePicker();
  bool isLoading = false;

  // Função para escolher ou capturar uma imagem
  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      update();
    }
  }

  // Função para salvar os dados no Firebase
  Future<void> saveMaterial(BuildContext context) async {
    if (barcodeController.text.isEmpty || locationController.text.isEmpty ){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos.")),
      );
      return;
    }

    try {
      // Verifique se o usuário está autenticado
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não autenticado.")),
        );

        return;
      }

      // Criando um nome único para a imagem
     /* String fileName = "departments/${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(_image!);
      String imageUrl = await storageRef.getDownloadURL();*/


      // Obtém a referência da coleção existente "inventories"
     String departmentId = _panelController.getCurrentOrganization()!.id; 

    // Obtendo a referência do documento do departamento específico
      DocumentReference departmentRef = FirebaseFirestore.instance
        .collection("departments")
        .doc(departmentId);

      CollectionReference inventoriesRef = departmentRef.collection("inventories");
      String inventoryId = (context.widget as MaterialsForm).cod; 

      DocumentReference inventoryRef = inventoriesRef.doc(inventoryId);
      CollectionReference itemsRef = inventoryRef.collection("items");

      // Salvando no Firestore
      await itemsRef.add({
        "barcode": barcodeController.text.trim(),
        "date": dateController.text.trim(),
        "description": descriptionController.text.trim(),
        "geolocation": geolocationController.text.trim(),
        "location": locationController.text.trim(),
        "name": nameController.text.trim(),
        "observations": observations.text.trim(),
        //"image": imageUrl,
        "created_at": FieldValue.serverTimestamp(),
        "created_by": user.uid, // Adiciona o ID do usuário
      });

      // Feedback de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("material adicionado com sucesso!")),
      );

      // Voltar para a tela anterior
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar departamento: $e")),
      );
    }
  }
}