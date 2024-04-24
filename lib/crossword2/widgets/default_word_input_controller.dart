import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template default_word_input_controller}
/// Creates a default [IoWordInputController] for the child widget.
/// {@endtemplate}
class DefaultWordInputController extends StatefulWidget {
  const DefaultWordInputController({
    required this.child,
    super.key,
  });

  final Widget child;

  /// Returns the [IoWordInputController] from the closest
  /// [DefaultWordInputController] ancestor.
  static IoWordInputController of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<IoWordInputControllerScope>();
    assert(
      scope != null,
      'No $DefaultWordInputController found in context',
    );
    return scope!.wordInputController;
  }

  @override
  State<DefaultWordInputController> createState() =>
      _DefaultWordInputControllerState();
}

class _DefaultWordInputControllerState
    extends State<DefaultWordInputController> {
  final IoWordInputController _wordInputController = IoWordInputController();

  @override
  void dispose() {
    _wordInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IoWordInputControllerScope(
      wordInputController: _wordInputController,
      child: widget.child,
    );
  }
}

@visibleForTesting
class IoWordInputControllerScope extends InheritedWidget {
  @visibleForTesting
  const IoWordInputControllerScope({
    required this.wordInputController,
    required super.child,
    super.key,
  });

  final IoWordInputController wordInputController;

  @override
  bool updateShouldNotify(covariant IoWordInputControllerScope oldWidget) {
    return wordInputController != oldWidget.wordInputController;
  }
}
