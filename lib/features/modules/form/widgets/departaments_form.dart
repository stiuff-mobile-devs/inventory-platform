import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DepartamentsForm extends StatefulWidget {
  const DepartamentsForm({super.key});

  @override
  _DepartamentsFormstate createState() => _DepartamentsFormstate();
}

class _DepartamentsFormstate extends State<DepartamentsForm> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
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
  Future<void> _saveDepartment() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty || _image == null) {
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

      // Salvando no Firestore
      await FirebaseFirestore.instance.collection("departments").add({
        "title": _titleController.text.trim(),
        "description": _descriptionController.text.trim(),
       // "image": imageUrl,
        "created_at": FieldValue.serverTimestamp(),
        "created_by": user.uid, // Adiciona o ID do usuário
      });

      // Feedback de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Departamento criado com sucesso!")),
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
              controller: _titleController,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Descrição"),
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
                    onPressed: _saveDepartment,
                    child: const Text("Salvar Departamento"),
                  ),
          ],
        ),
      ),
    );
  }
}
