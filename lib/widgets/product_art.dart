import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductArt extends StatelessWidget {
  final Product product;
  const ProductArt({super.key, required this.product});
  @override
  Widget build(BuildContext context) => ColoredBox(
    color: product.color,
    child: CustomPaint(painter: _ShoePainter(), child: const SizedBox.expand()),
  );
}

class _ShoePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    final scale = size.width * .8 / 300;
    canvas.translate(size.width * .1, (size.height - 190 * scale) / 2);
    canvas.scale(scale);
    canvas.drawOval(
      Rect.fromLTWH(20, 151, 260, 22),
      Paint()..color = Colors.black.withValues(alpha: .08),
    );
    final upper = Path()
      ..moveTo(18, 115)
      ..lineTo(37, 52)
      ..quadraticBezierTo(58, 85, 91, 67)
      ..lineTo(125, 26)
      ..quadraticBezierTo(146, 21, 152, 48)
      ..quadraticBezierTo(175, 90, 226, 101)
      ..quadraticBezierTo(278, 106, 285, 134)
      ..lineTo(22, 141)
      ..close();
    canvas.drawPath(upper, Paint()..color = const Color(0xFFFAFAF4));
    canvas.drawPath(
      upper,
      Paint()
        ..color = const Color(0xFF829380)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    canvas.drawPath(
      Path()
        ..moveTo(20, 131)
        ..quadraticBezierTo(148, 145, 285, 130)
        ..lineTo(284, 149)
        ..quadraticBezierTo(156, 163, 18, 149)
        ..close(),
      Paint()..color = const Color(0xFFDBD8CC),
    );
    canvas.drawPath(
      Path()
        ..moveTo(59, 106)
        ..lineTo(109, 112)
        ..lineTo(171, 83)
        ..lineTo(116, 125)
        ..lineTo(60, 120)
        ..close(),
      Paint()..color = const Color(0xFF315D45),
    );
    for (var i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset(118 + i * 9, 57 + i * 8),
        Offset(145 + i * 9, 49 + i * 8),
        Paint()
          ..color = const Color(0xFF8C9787)
          ..strokeWidth = 4
          ..strokeCap = StrokeCap.round,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
