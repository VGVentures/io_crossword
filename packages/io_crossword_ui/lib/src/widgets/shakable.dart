import 'dart:math';

import 'package:flutter/material.dart';

/// {@template shakable}
/// An animated widget to shake the passed [child] widget.
/// {@endtemplate}
class Shakable extends StatefulWidget {
  /// {@macro shakable}
  const Shakable({
    required this.child,
    required this.shakeDuration,
    this.shakeCount = 3,
    super.key,
  });

  /// Child widget.
  final Widget child;

  /// Duration of the shaking animation.
  final Duration shakeDuration;

  /// How many times the child will move back and forth.
  final int shakeCount;

  @override
  State<Shakable> createState() => ShakableState();
}

/// {@template shakable_state}
/// State class of the [Shakable] animation.
/// {@endtemplate}
class ShakableState extends State<Shakable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: widget.shakeDuration,
  );

  /// Starts the shaking animation and resets it when it ends.
  void shake() {
    _animationController.forward(from: 0).then(
          (value) => _animationController.reset(),
        );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: widget.child,
      builder: (context, child) {
        final sinValue = sin(
          widget.shakeCount * 2 * pi * _animationController.value,
        );
        return Transform.translate(
          offset: Offset(sinValue * 10, 0),
          child: child,
        );
      },
    );
  }
}
