import 'package:flutter/material.dart';

class GradientOutlinedBorder extends StadiumBorder {
  GradientOutlinedBorder({
    required this.gradient,
    super.side,
  });

  final Gradient gradient;

  @override
  GradientOutlinedBorder copyWith({
    BorderSide? side,
    Gradient? gradient,
  }) {
    return GradientOutlinedBorder(
      gradient: gradient ?? this.gradient,
      side: side ?? this.side,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final radius = Radius.circular(rect.shortestSide / 2);
    final borderRect = RRect.fromRectAndRadius(rect, radius);
    final paint = Paint()
      ..strokeWidth = side.toPaint().strokeWidth
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(borderRect.inflate(side.strokeOffset / 2), paint);
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientOutlinedBorder) {
      final outline = a;
      return GradientOutlinedBorder(
        gradient: Gradient.lerp(
          LinearGradient(
            // Fake a gradient with a single color to make a smooth transition
            colors: [outline.side.color, outline.side.color],
          ),
          gradient,
          t,
        )!,
        side: BorderSide.lerp(side, outline.side, t),
      );
    }
    return super.lerpFrom(a, t);
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
