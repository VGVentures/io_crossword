import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

class IoTextInput extends StatefulWidget {
  const IoTextInput({
    required this.length,
    super.key,
  });

  /// The length of the input.
  ///
  /// In other words, the number of characters that the input will accept.
  final int length;

  @override
  State<IoTextInput> createState() => _IoTextInputState();
}

class _IoTextInputState extends State<IoTextInput> {
  var _currentCharacterIndex = 0;

  late final _focusNodes = List.generate(widget.length, (_) => FocusNode());

  late final _controllers =
      List.generate(widget.length, (_) => TextEditingController());

  void _onControllerChanged() {
    final activeController = _controllers[_currentCharacterIndex];

    if (activeController.text.isNotEmpty) {
      final nextCharacter = _nextCharacter();
      if (nextCharacter == -1) {
        // TODO(alestiago): Submit.
        return;
      }

      _currentCharacterIndex = nextCharacter;
      _focusNodes[_currentCharacterIndex].requestFocus();
    }
  }

  /// Find the next available character position.
  ///
  /// If there is no available position, returns `-1`.
  int _nextCharacter() {
    return _controllers.indexWhere((controller) => controller.text.isEmpty);
  }

  @override
  void initState() {
    super.initState();

    for (final controller in _controllers) {
      controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < widget.length; i++)
          Padding(
            padding: const EdgeInsets.all(8),
            child: _CharacterInputField(
              focusNode: _focusNodes[i],
              controller: _controllers[i],
            ),
          ),
      ],
    );
  }
}

class _CharacterInputField extends StatefulWidget {
  const _CharacterInputField({
    required this.controller,
    required this.focusNode,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  State<_CharacterInputField> createState() => _CharacterInputFieldState();
}

class _CharacterInputFieldState extends State<_CharacterInputField> {
  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChanged);
    super.dispose();
  }

  void _onFocusChanged() {
    setState(() {});
  }

  void _onTextChanged(String? input) {
    if (input == null) return;

    final isAlphabetic = RegExp('[a-zA-Z]').hasMatch(input);
    if (!isAlphabetic) {
      widget.controller.text = '';
      return;
    }

    if (input.length == 1) {
      widget.controller.text = input.toUpperCase();
    } else {
      widget.controller.text = input[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 50,
      child: ColoredBox(
        color: widget.focusNode.hasFocus
            ? IoCrosswordColors.seedGreen
            : IoCrosswordColors.seedBlue,
        child: Center(
          child: EditableText(
            keyboardType: TextInputType.text,
            onChanged: _onTextChanged,
            controller: widget.controller,
            focusNode: widget.focusNode,
            textAlign: TextAlign.center,
            style: const TextStyle(),
            cursorColor: Colors.transparent,
            backgroundCursorColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
