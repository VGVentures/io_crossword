import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_physical_model}
/// An IO styled [PhysicalModel] widget.
/// {@endtemplate}
class IoPhysicalModel extends StatelessWidget {
  /// {@macro io_physical_model}
  const IoPhysicalModel({
    required this.child,
    super.key,
  });

  /// The child widget.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).io.physicalModel;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: Transform.translate(
            offset: Offset(style.elevation, style.elevation * 1.08),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: style.border,
                borderRadius: style.borderRadius,
                gradient: style.gradient,
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

/// {@template io_physical_model_style}
/// Style configuration for [PhysicalModel].
/// {@endtemplate}
class IoPhysicalModelStyle extends Equatable {
  /// {@macro io_physical_model_style}
  const IoPhysicalModelStyle({
    required this.gradient,
    required this.border,
    required this.borderRadius,
    required this.elevation,
  });

  /// The gradient to use for the shadow.
  final Gradient gradient;

  /// The border to use for the shadow.
  final Border border;

  /// The border radius of the shadow.
  final BorderRadius borderRadius;

  /// The elevation of the shadow.
  final double elevation;

  /// Linearly interpolate between two [IoPhysicalModelStyle].
  IoPhysicalModelStyle lerp(
    IoPhysicalModelStyle other,
    double t,
  ) {
    return IoPhysicalModelStyle(
      gradient: Gradient.lerp(gradient, other.gradient, t)!,
      border: Border.lerp(border, other.border, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      elevation: ui.lerpDouble(elevation, other.elevation, t)!,
    );
  }

  @override
  List<Object?> get props => [gradient, border, borderRadius, elevation];
}
