import 'package:flutter/material.dart';

class GradientOutlinedBorder extends OutlinedBorder {
  @override
  OutlinedBorder copyWith({BorderSide? side}) {
    // TODO: implement copyWith
    throw UnimplementedError();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    throw UnimplementedError();
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getOuterPath
    throw UnimplementedError();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    switch (style) {
      case BorderStyle.solid:
        final paint = Paint()
          ..strokeWidth = width
          ..style = PaintingStyle.fill
          ..shader = gradient.createShader(rect)
          // .createShader(Rect.fromCircle(center: Offset(50, 0), radius: 30))
          ..color = color;

        canvas.drawPaint(paint);
      case BorderStyle.none:
        return Paint()
          ..color = const Color(0x00000000)
          ..strokeWidth = 0.0
          ..style = PaintingStyle.stroke;
    }
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    throw UnimplementedError();
  }
}

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
          ..style = PaintingStyle.fill
          ..shader = gradient.createShader(Rect.fromLTRB(0, 0, 80, 0))
          // .createShader(Rect.fromCircle(center: Offset(50, 0), radius: 30))
          ..color = color;
      case BorderStyle.none:
        return Paint()
          ..color = const Color(0x00000000)
          ..strokeWidth = 0.0
          ..style = PaintingStyle.stroke;
    }
  }
}
