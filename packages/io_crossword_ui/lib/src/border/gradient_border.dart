import 'package:flutter/material.dart';

/// {@template gradient_border}
/// A gradient border for the [OutlinedButton].
/// {@endtemplate}
class GradientBorder extends BorderSide {
  /// {@macro gradient_border}
  const GradientBorder({
    required this.gradient,
    super.width = 2,
    super.style,
  });

  /// The gradient to use for the border.
  final Gradient gradient;

  @override
  Paint toPaint() {
    switch (style) {
      case BorderStyle.solid:
        return Paint()
          ..strokeWidth = width
          ..style = PaintingStyle.stroke
          ..shader = gradient
              .createShader(Rect.fromCircle(center: Offset.zero, radius: 50))
          ..color = color;
      case BorderStyle.none:
        return Paint()
          ..color = const Color(0x00000000)
          ..strokeWidth = 0.0
          ..style = PaintingStyle.stroke;
    }
  }
}
