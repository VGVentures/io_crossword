import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

/// {@template gradient_input_border}
/// A gradient border for the CMS input field
/// {@endtemplate}
class GradientInputBorder extends OutlineInputBorder {
  /// {@macro gradient_input_border}
  const GradientInputBorder({
    required this.gradient,
    super.borderRadius,
    super.borderSide,
    super.gapPadding,
  });

  /// The gradient to use for the border.
  final Gradient gradient;

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is OutlineInputBorder) {
      final outline = a;
      return GradientInputBorder(
        gradient: Gradient.lerp(
          LinearGradient(
            // Fake a gradient with a single color to make a smooth transition
            colors: [outline.borderSide.color, outline.borderSide.color],
          ),
          gradient,
          t,
        )!,
        borderRadius: BorderRadius.lerp(borderRadius, outline.borderRadius, t)!,
        borderSide: BorderSide.lerp(borderSide, outline.borderSide, t),
        gapPadding: outline.gapPadding,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderSide.width;

    final outer = borderRadius.toRRect(rect);
    final center = outer.deflate(borderSide.width / 2.0);

    if (gapStart == null || gapExtent <= 0.0 || gapPercentage == 0.0) {
      canvas.drawRRect(center, paint);
    } else {
      final extent =
          lerpDouble(0.0, gapExtent + gapPadding * 2.0, gapPercentage)!;
      final path = _gapBorderPath(
        canvas,
        center,
        math.max(0, gapStart - gapPadding),
        extent,
      );
      canvas.drawPath(path, paint);
    }
  }

  // Copied from Flutter's OutlineInputBorder._gapBorderPath
  Path _gapBorderPath(
    Canvas canvas,
    RRect center,
    double start,
    double extent,
  ) {
    // When the corner radii on any side add up to be greater than the
    // given height, each radius has to be scaled to not exceed the
    // size of the width/height of the RRect.
    final scaledRRect = center.scaleRadii();

    final tlCorner = Rect.fromLTWH(
      scaledRRect.left,
      scaledRRect.top,
      scaledRRect.tlRadiusX * 2.0,
      scaledRRect.tlRadiusY * 2.0,
    );
    final trCorner = Rect.fromLTWH(
      scaledRRect.right - scaledRRect.trRadiusX * 2.0,
      scaledRRect.top,
      scaledRRect.trRadiusX * 2.0,
      scaledRRect.trRadiusY * 2.0,
    );
    final brCorner = Rect.fromLTWH(
      scaledRRect.right - scaledRRect.brRadiusX * 2.0,
      scaledRRect.bottom - scaledRRect.brRadiusY * 2.0,
      scaledRRect.brRadiusX * 2.0,
      scaledRRect.brRadiusY * 2.0,
    );
    final blCorner = Rect.fromLTWH(
      scaledRRect.left,
      scaledRRect.bottom - scaledRRect.blRadiusY * 2.0,
      scaledRRect.blRadiusX * 2.0,
      scaledRRect.blRadiusY * 2.0,
    );

    // This assumes that the radius is circular (x and y radius are equal).
    // Currently, BorderRadius only supports circular radii.
    const cornerArcSweep = math.pi / 2.0;
    final path = Path();

    // Top left corner
    if (scaledRRect.tlRadius != Radius.zero) {
      final tlCornerArcSweep =
          math.acos(clampDouble(1 - start / scaledRRect.tlRadiusX, 0, 1));
      path.addArc(tlCorner, math.pi, tlCornerArcSweep);
    } else {
      // Because the path is painted with Paint.strokeCap = StrokeCap.butt,
      // horizontal coordinate is moved to the left using borderSide.width / 2.
      path.moveTo(scaledRRect.left - borderSide.width / 2, scaledRRect.top);
    }

    // Draw top border from top left corner to gap start.
    if (start > scaledRRect.tlRadiusX) {
      path.lineTo(scaledRRect.left + start, scaledRRect.top);
    }

    // Draw top border from gap end to top right corner and draw top right
    // corner.
    const trCornerArcStart = (3 * math.pi) / 2.0;
    const trCornerArcSweep = cornerArcSweep;
    if (start + extent < scaledRRect.width - scaledRRect.trRadiusX) {
      path
        ..moveTo(scaledRRect.left + start + extent, scaledRRect.top)
        ..lineTo(scaledRRect.right - scaledRRect.trRadiusX, scaledRRect.top);
      if (scaledRRect.trRadius != Radius.zero) {
        path.addArc(trCorner, trCornerArcStart, trCornerArcSweep);
      }
    }

    // Draw right border and bottom right corner.
    if (scaledRRect.brRadius != Radius.zero) {
      path.moveTo(scaledRRect.right, scaledRRect.top + scaledRRect.trRadiusY);
    }
    path.lineTo(scaledRRect.right, scaledRRect.bottom - scaledRRect.brRadiusY);
    if (scaledRRect.brRadius != Radius.zero) {
      path.addArc(brCorner, 0, cornerArcSweep);
    }

    // Draw bottom border and bottom left corner.
    path.lineTo(scaledRRect.left + scaledRRect.blRadiusX, scaledRRect.bottom);
    if (scaledRRect.blRadius != Radius.zero) {
      path.addArc(blCorner, math.pi / 2.0, cornerArcSweep);
    }

    // Draw left border
    path.lineTo(scaledRRect.left, scaledRRect.top + scaledRRect.tlRadiusY);

    return path;
  }
}
