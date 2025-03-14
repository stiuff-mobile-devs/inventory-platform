import 'package:flutter/material.dart';

class BarcodePainter extends CustomPainter {
  final List<Rect> barcodeRects;
  BarcodePainter({required this.barcodeRects});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.yellow.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    for (var rect in barcodeRects) {
      canvas.drawRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
