import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:inventory_platform/routes/routes.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AlternateCameraPage extends StatefulWidget {
  final String? cod;

  const AlternateCameraPage({super.key, this.cod});

  @override
  State<AlternateCameraPage> createState() => _AlternateCameraPageState();
}

class _AlternateCameraPageState extends State<AlternateCameraPage> {
  String? _scannedCode;
  double _buttonBottomPosition = 0;
  double _buttonOpacity = 0.0;
  bool _isInFormPage = false;
  final MobileScannerController _scannerController = MobileScannerController();

  List<Rect> _barcodeRects = [];

  @override
  void initState() {
    super.initState();

    _scannerController.start().then((_) {
      final size = _scannerController.cameraResolution;
      if (size != null) {
        debugPrint('Resolução capturada: ${size.width}x${size.height}');
      } else {
        debugPrint('Não foi possível determinar a resolução da câmera.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: _scannerController,
            onDetect: (barcodeCapture) {
              final barcodes = barcodeCapture.barcodes;
              final List<Rect> detectedRects = [];
              for (var barcode in barcodes) {
                if (barcode.rawValue != null) {
                  detectedRects.add(_cornersToRect(barcode.corners));
                }
              }

              setState(() {
                _barcodeRects = detectedRects;
                if (barcodes.isNotEmpty && !_isInFormPage) {
                  _scannedCode = barcodes.first.rawValue;
                  _buttonBottomPosition = 50;
                  _buttonOpacity = 1.0;
                }
              });
            },
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
          CustomPaint(
            painter: BarcodeRectPainter(_barcodeRects),
            child: Container(),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
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
      ),
    );
  }

  Rect _mapRectToScreen(Rect rect, Size screenSize) {
    const scaleX = 0.8;
    const scaleY = 1.275;

    return Rect.fromLTRB(
      rect.left * scaleX,
      rect.top * scaleY,
      rect.right * scaleX,
      rect.bottom * scaleY,
    );
  }

  Rect _cornersToRect(List<Offset> corners) {
    final left = corners.map((c) => c.dx).reduce((a, b) => a < b ? a : b);
    final top = corners.map((c) => c.dy).reduce((a, b) => a < b ? a : b);
    final right = corners.map((c) => c.dx).reduce((a, b) => a > b ? a : b);
    final bottom = corners.map((c) => c.dy).reduce((a, b) => a > b ? a : b);

    final rect = Rect.fromLTRB(left, top, right, bottom);
    final screenSize = MediaQuery.of(context).size;

    return _mapRectToScreen(rect, screenSize);
  }
}

class BarcodeRectPainter extends CustomPainter {
  final List<Rect> barcodeRects;

  BarcodeRectPainter(this.barcodeRects);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (var rect in barcodeRects) {
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
