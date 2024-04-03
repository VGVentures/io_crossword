import 'package:flutter/material.dart';

class GradientOutlinedBorder extends RoundedRectangleBorder {
  GradientOutlinedBorder({
    required this.gradient,
    super.borderRadius,
  });

  final Gradient gradient;

  @override
  RoundedRectangleBorder copyWith({
    BorderSide? side,
    BorderRadiusGeometry? borderRadius,
    Gradient? gradient,
  }) {
    return GradientOutlinedBorder(
      gradient: gradient ?? this.gradient,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return super.getInnerPath(rect);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return super.getOuterPath(rect);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(rect);
    final path = getOuterPath(rect, textDirection: textDirection);
    canvas.drawPath(path, paint);
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
