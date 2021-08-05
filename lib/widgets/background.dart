import 'package:flutter/material.dart';

// Arka plan tasarımı olarak kullanılan sınıf
// Ekran görüntüsü için github adresi ziyaret edilebilir.
class Background extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    _drawPentagone(canvas, size);
  }

  _drawPentagone(Canvas canvas, Size size) {
    var path = new Path();
    path.addPolygon([
      new Offset(size.width, size.height / 8),
      new Offset(size.width, size.height),
      new Offset(50, size.height),
      new Offset(0.0, size.height / 3),
    ], true);
    path.close();
    canvas.drawPath(path, new Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
