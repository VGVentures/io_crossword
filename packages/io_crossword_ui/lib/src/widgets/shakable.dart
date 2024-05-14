part of 'io_word_input.dart';

/// {@template shakable}
/// An animated widget to shake the passed [child] widget.
/// {@endtemplate}
class Shakable extends StatefulWidget {
  /// {@macro shakable}
  const Shakable({
    required this.controller,
    required this.child,
    this.speed = 6,
    super.key,
  });

  /// Controls the shaking animation.
  final AnimationController controller;

  /// The widget to shake.
  final Widget child;

  /// Speed of the animation.
  final int speed;

  @override
  State<Shakable> createState() => _ShakableState();
}

/// {@template shakable_state}
/// State class of the [Shakable] animation.
/// {@endtemplate}
class _ShakableState extends State<Shakable>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      child: widget.child,
      builder: (context, child) {
        final sinValue = sin(
          widget.speed * pi * widget.controller.value,
        );
        return Transform.translate(
          offset: Offset(sinValue * 10, 0),
          child: child,
        );
      },
    );
  }
}
