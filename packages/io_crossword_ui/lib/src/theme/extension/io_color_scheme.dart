import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart';

/// {@template io_color_scheme}
/// An extended IO styled color scheme.
/// {@endtemplate}
class IoColorScheme extends Equatable {
  /// {@macro io_color_scheme}
  const IoColorScheme({required this.primaryGradient});

  /// The main gradient of the color scheme.
  final Gradient primaryGradient;

  /// Linearly interpolate between two color schemes.
  IoColorScheme lerp(IoColorScheme other, double t) {
    return IoColorScheme(
      primaryGradient:
          Gradient.lerp(primaryGradient, other.primaryGradient, t)!,
    );
  }

  @override
  List<Object?> get props => [primaryGradient];
}
