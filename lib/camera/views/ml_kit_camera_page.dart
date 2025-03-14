import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:inventory_platform/core/theme/barcode_painter.dart';
import 'package:inventory_platform/routes/routes.dart';

class CameraPage extends StatefulWidget {
  final String? cod;
  const CameraPage({super.key, this.cod});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _isDetecting = false;
  List<Rect> _barcodeRects = [];
  Size? _imageSize;
  String? _scannedCode;

  double _buttonBottomPosition = 0;
  double _buttonOpacity = 0.0;

  bool _isInFormPage = false;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final camera = cameras.first;

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      setState(() {
        _imageSize = Size(
          _cameraController!.value.previewSize!.height,
          _cameraController!.value.previewSize!.width,
        );
      });

      if (!_isInFormPage) {
        _cameraController!.startImageStream((CameraImage image) {
          if (_isDetecting || _isInFormPage) return;
          _isDetecting = true;

          _scanBarcode(image).then((_) {
            setState(() {});
            _isDetecting = false;
          });
        });
      } else {
        _cameraController!.stopImageStream();
      }
    } catch (e) {
      debugPrint('Erro ao inicializar a câmera: $e');
    }
  }

  Future<void> _scanBarcode(CameraImage image) async {
    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();
      final bytesPerRow = image.planes[0].bytesPerRow;

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotationValue.fromRawValue(
                  _cameraController!.description.sensorOrientation) ??
              InputImageRotation.rotation0deg,
          format: InputImageFormat.nv21,
          bytesPerRow: bytesPerRow,
        ),
      );

      final barcodes = await _barcodeScanner.processImage(inputImage);

      if (barcodes.isNotEmpty) {
        setState(() {
          _scannedCode = barcodes.first.rawValue;
          _buttonBottomPosition = 50;
          _buttonOpacity = 1.0;
        });
      }

      for (Barcode b in barcodes) {
        debugPrint("Captura do valor: ${b.rawValue.toString()}");
      }

      setState(() {
        _barcodeRects = barcodes.map((barcode) {
          final rect = barcode.boundingBox;
          return _scaleRect(rect, _imageSize!, context);
        }).toList();
      });
    } catch (e) {
      debugPrint('Erro ao processar imagem: $e');
    }
  }

  Rect _scaleRect(Rect rect, Size imageSize, BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    double scaleX = screenSize.width / imageSize.width;
    double scaleY = screenSize.height / imageSize.height;

    return Rect.fromLTRB(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _cameraController != null) {
            return Stack(
              children: [
                FittedBox(
                  fit: BoxFit.fill,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
                CustomPaint(
                  painter: BarcodePainter(barcodeRects: _barcodeRects),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                Center(
                  child: Opacity(
                    opacity: 0.5,
                    child: SvgPicture.asset(
                      'assets/icons/scan-surface.svg',
                      width: 100,
                      height: 100,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOut,
                  bottom: _buttonBottomPosition,
                  left: MediaQuery.of(context).size.width * 0.15,
                  right: MediaQuery.of(context).size.width * 0.15,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _buttonOpacity,
                    child: GestureDetector(
                      onTap: () {
                        if (_scannedCode != null) {
                          setState(() {
                            _isInFormPage = true;
                          });
                          Get.toNamed(AppRoutes.material,
                          parameters: {'cod': widget.cod!, 'barcode': _scannedCode!});
                         }
                        },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            'Código: $_scannedCode',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
        },
      ),
    );
  }
}
