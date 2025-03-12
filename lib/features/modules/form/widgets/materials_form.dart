import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_platform/core/services/mock_service.dart';

class MaterialsForm extends StatefulWidget {
  const MaterialsForm({super.key});

  @override
  _MaterialsFormState createState() => _MaterialsFormState();
}

class _MaterialsFormState extends State<MaterialsForm> {
  MockService mockService = Get.find<MockService>();

  final _barcodeController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _geolocationController = TextEditingController();
  final _locationController = TextEditingController();
  final _nameController = TextEditingController();
  final _observations = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Função para escolher ou capturar uma imagem
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Função para salvar os dados no Firebase
  Future<void> _saveMaterial() async {
    if (_barcodeController.text.isEmpty || _descriptionController.text.isEmpty || _image == null) {
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

      // Criando um nome único para a imagem
     /* String fileName = "departments/${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      await storageRef.putFile(_image!);
      String imageUrl = await storageRef.getDownloadURL();*/


         // Obtém a referência da coleção existente "inventories"
     String departmentId = "EsQDsCXUBXsL9NKOoih5"; // Substituir pelo ID correto

    // Obtendo a referência do documento do departamento específico
      DocumentReference departmentRef = FirebaseFirestore.instance
        .collection("departments")
        .doc(departmentId);
      CollectionReference inventoriesRef = departmentRef.collection("inventories");
      String inventoryId = "eyCtyST3VVkp3HJ67s8S"; // Substituir pelo ID correto do inventário
      DocumentReference inventoryRef = inventoriesRef.doc(inventoryId);
      CollectionReference itemsRef = inventoryRef.collection("items");



  

      // Salvando no Firestore
      await itemsRef.add({
        "barcode": _barcodeController.text.trim(),
        "date": _dateController.text.trim(),
        "description": _descriptionController.text.trim(),
        "geolocation": _geolocationController.text.trim(),
        "location": _locationController.text.trim(),
        "name": _nameController.text.trim(),
        "observations": _observations.text.trim(),
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

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Criar Novo Departamento")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _barcodeController,
              decoration: const InputDecoration(labelText: "Código de Barras"),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: "Data"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Descrição"),
            ),
            TextField(
              controller: _geolocationController,
              decoration: const InputDecoration(labelText: "Geolocalização"),
            ),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: "Localização"),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Nome"),
            ),
            TextField(
              controller: _observations,
              decoration: const InputDecoration(labelText: "Observações"),
            ),
            const SizedBox(height: 10),
            _image == null
                ? const Text("Nenhuma imagem selecionada")
                : Image.file(_image!, height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.camera),
                  onPressed: () => _pickImage(ImageSource.camera),
                ),
                IconButton(
                  icon: const Icon(Icons.photo_library),
                  onPressed: () => _pickImage(ImageSource.gallery),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _saveMaterial,
                    child: const Text("Salvar Departamento"),
                  ),
          ],
        ),
      ),
    );
  }
}
