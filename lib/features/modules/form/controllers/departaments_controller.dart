import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inventory_platform/core/services/mock_service.dart';
import 'package:get/get.dart';

class DepartamentsController extends GetxController {
  final MockService mockService = Get.find<MockService>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();

  File? image;
  var isLoading = false.obs;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      update();
    }
  }

  Future<void> saveDepartment(BuildContext context) async {

    isLoading.value = true;

    try {
      //Segurança firebase
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário não autenticado.")),
        );
        isLoading.value = false;
        return;
      }

      await FirebaseFirestore.instance.collection("departments").add({
        "title": titleController.text.trim(),
        "description": descriptionController.text.trim(),
        "created_at": FieldValue.serverTimestamp(),
        "created_by": user.uid,
      });

      mockService.addSampleOrganizations();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Departamento criado com sucesso!")),
      );
      Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro ao salvar departamento: $e")),
      );
    }
    isLoading.value = false;
  }
}