part of 'io_word_input.dart';

/// {@template shakable}
/// An animated widget to shake the passed [child] widget.
/// {@endtemplate}
class Shakable extends StatefulWidget {
  /// {@macro shakable}
  const Shakable({
    required this.child,
    required this.shakeDuration,
    this.controller,
    this.speed = 6,
    @visibleForTesting this.animationController,
    super.key,
  });

  /// {@macro io_word_input_controller}
  final IoWordInputController? controller;

  /// Animation controller.
  ///
  /// Usable only for testing.
  @visibleForTesting
  final AnimationController? animationController;

  /// Child widget.
  final Widget child;

  /// Duration of the shaking animation.
  final Duration shakeDuration;

  /// Speed of the animation.
  final int speed;

  @override
  State<Shakable> createState() => ShakableState();
}

/// {@template shakable_state}
/// State class of the [Shakable] animation.
/// {@endtemplate}
@visibleForTesting
class ShakableState extends State<Shakable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController =
      widget.animationController ??
          AnimationController(
            vsync: this,
            duration: widget.shakeDuration,
          );

  /// Starts the shaking animation and resets it when it ends if word is empty.
  void _onInputReset() {
    final controller = widget.controller;

    if (controller != null && controller.didReset) {
      _animationController.forward(from: 0).then(
            (value) => _animationController.reset(),
          );
    }
  }

  @override
  void didUpdateWidget(covariant Shakable oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_onInputReset);
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    widget.controller?.addListener(_onInputReset);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: widget.child,
      builder: (context, child) {
        final sinValue = sin(
          widget.speed * pi * _animationController.value,
        );
        return Transform.translate(
          offset: Offset(sinValue * 10, 0),
          child: child,
        );
      },
    );
  }
}
