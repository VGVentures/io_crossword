import 'package:flutter/material.dart';

/// {@template gradient_outlined_border}
/// A gradient outlined border for the [OutlinedButton].
/// {@endtemplate}
class GradientStadiumBorder extends StadiumBorder {
  /// {@macro gradient_outlined_border}
  const GradientStadiumBorder({
    required this.gradient,
    super.side,
  });

  /// The gradient border.
  final Gradient gradient;

  @override
  GradientStadiumBorder copyWith({
    BorderSide? side,
    Gradient? gradient,
  }) {
    return GradientStadiumBorder(
      gradient: gradient ?? this.gradient,
      side: side ?? this.side,
    );
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    final radius = Radius.circular(rect.shortestSide / 2);
    final borderRect = RRect.fromRectAndRadius(rect, radius);

    final paint = Paint()
      ..strokeWidth = side.width < 2 ? 2 : side.width
      ..style = PaintingStyle.stroke
      ..shader = gradient.createShader(rect);
    canvas.drawRRect(borderRect.inflate(side.strokeOffset / 2), paint);
  }

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is GradientStadiumBorder) {
      return GradientStadiumBorder(
        gradient: Gradient.lerp(
          LinearGradient(
            // Fake a gradient with a single color to make a smooth transition
            colors: [a.side.color, a.side.color],
          ),
          gradient,
          t,
        )!,
        side: BorderSide.lerp(a.side, side, t),
      );
    }

    return super.lerpFrom(a, t);
  }
}
