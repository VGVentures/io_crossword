import 'package:flutter/material.dart';

/// {@template io_logo}
/// A widget that displays the IO logo.
///
/// See also:
///
/// * [FlutterLogo], a similar widget for the Flutter logo.
/// {@endtemplate}
class IoLogo extends StatelessWidget {
  /// {@macro io_logo}
  const IoLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 32.45,
      height: 19.87,
      child: CustomPaint(
        painter: _IoLogoCustomPainter(color: theme.colorScheme.onSurface),
      ),
    );
  }
}

class _IoLogoCustomPainter extends CustomPainter {
  _IoLogoCustomPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = color
      ..filterQuality = FilterQuality.high;
    canvas
      ..drawRect(
        Rect.fromLTWH(
          0,
          size.height * 0.08642600,
          size.width * 0.2509288,
          size.height * 0.8259450,
        ),
        paint,
      )
      ..drawOval(
        Rect.fromCenter(
          center: Offset(size.width * 0.7222606, size.height * 0.5050100),
          width: size.width * 0.5222030,
          height: size.height * 0.8594290,
        ),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(15.5543, 0.0546875)
          ..lineTo(14.0996, 0.0546875)
          ..lineTo(9.62354, 19.922)
          ..lineTo(11.0782, 19.922)
          ..lineTo(15.5543, 0.0546875)
          ..close(),
        paint,
      );
  }

  @override
  bool shouldRepaint(covariant _IoLogoCustomPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
