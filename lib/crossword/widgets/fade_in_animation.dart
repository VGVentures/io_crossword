import 'package:flutter/material.dart';

/// {@template fade_in_animation}
/// A widget that fades in its child.
/// {@endtemplate}
class FadeInAnimation extends StatefulWidget {
  /// {@macro fade_in_animation}
  const FadeInAnimation({
    required this.child,
    this.duration = const Duration(seconds: 2),
    this.onComplete,
    super.key,
  });

  /// The child to fade in.
  final Widget child;

  /// The duration of the fade animation.
  final Duration duration;

  /// A callback that is called when the animation completes.
  final VoidCallback? onComplete;

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _controller
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && widget.onComplete != null) {
          widget.onComplete?.call();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}
