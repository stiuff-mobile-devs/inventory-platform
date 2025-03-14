// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:inventory_platform/core/theme/expandable_fab.dart';
import 'package:inventory_platform/routes/routes.dart';

class BarcodeScannerWidget extends StatefulWidget {
  final String? cod;
  const BarcodeScannerWidget({super.key, this.cod});

  @override
  State<BarcodeScannerWidget> createState() => _BarcodeScannerWidgetState();
}

class _BarcodeScannerWidgetState extends State<BarcodeScannerWidget> {
  final ImagePicker _picker = ImagePicker();
  late BarcodeScanner _barcodeScanner;

  @override
  void initState() {
    super.initState();
    _barcodeScanner = BarcodeScanner();
  }

  Future<void> _pickImageAndScan() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);

      _showLoadingDialog();

      final result = await _scanBarcodeFromImage(imageFile);

      Navigator.of(context).pop();

      if (result == null) {
        _showNoBarcodeDialog(context);
      } else {
        _showResultDialog(result);
      }
    }
  }

  Future<void> _captureImageAndScan() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final File imageFile = File(pickedFile.path);

      _showLoadingDialog();

      final result = await _scanBarcodeFromImage(imageFile);

      Navigator.of(context).pop();

      if (result == null) {
        _showNoBarcodeDialog(context);
      } else {
        _showResultDialog(result);
      }
    }
  }

  Future<String?> _scanBarcodeFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFilePath(imageFile.path);

      final List<Barcode> barcodes =
          await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        return barcodes.first.displayValue;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Erro ao tentar ler o código de barras: $e");
      return null;
    }
  }

  void _showNoBarcodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: const Text('Nenhum Código Encontrado'),
          content:
              const Text('Não foi possível identificar um código de barras.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showResultDialog(String? result) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          backgroundColor: Colors.white,
          title: Text(
            result != null ? 'Código Escaneado' : 'Nenhum Código Encontrado',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            result ?? 'Não foi possível identificar um código de barras.',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16.0),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
            result != null
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                       Get.toNamed(AppRoutes.material,
                    parameters: {'cod': widget.cod!, 'barcode': result});
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ],
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  color: Colors.blue,
                ),
                SizedBox(height: 10),
                Text(
                  'Processando...',
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      onPressed: () {},
      children: [
        FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: _pickImageAndScan,
          heroTag: null,
          tooltip: 'Escolher Imagem',
          child: const Icon(
            Icons.photo,
            color: Colors.white,
          ),
        ),
        FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: _captureImageAndScan,
          heroTag: null,
          tooltip: 'Capturar Foto',
          child: const Icon(
            Icons.camera_alt,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
