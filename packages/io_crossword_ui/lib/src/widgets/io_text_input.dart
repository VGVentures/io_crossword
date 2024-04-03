import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_text_input}
/// An IO styled text input that accepts a fixed number of characters.
/// {@endtemplate}
class IoTextInput extends StatefulWidget {
  /// {@macro io_text_input}
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
    final style = Theme.of(context).io.textInput;

    return Row(
      children: [
        for (var i = 0; i < widget.length; i++)
          Padding(
            padding: style.padding,
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
      widget.controller.text = '_';
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
    final style = Theme.of(context).io.textInput;

    return SizedBox.square(
      dimension: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(0.77)),
          border: Border.all(
            width: 1.8,
            color: IoCrosswordColors.seedWhite,
          ),
          color: IoCrosswordColors.darkGray,
        ),
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

/// {@template io_text_input_style}
/// The style of the [IoTextInput].
/// {@endtemplate}
class IoTextInputStyle extends Equatable {
  /// {@macro io_text_input_style}
  const IoTextInputStyle({
    required this.padding,
    required this.empty,
    required this.filled,
    required this.focused,
    required this.disabled,
  });

  /// The margin between the character fields.
  final EdgeInsets padding;

  /// The style of an empty character field.
  final IoTextInputCharacterFieldStyle empty;

  /// The style of the filled character field.
  ///
  /// A filled character field is the one that has a value.
  final IoTextInputCharacterFieldStyle filled;

  /// The style of the focused character field.
  ///
  /// A focused character field is the one that is currently being inputted.
  final IoTextInputCharacterFieldStyle focused;

  /// The style of the disabled character field.
  ///
  /// A disabled character field is the one that is not available for input.
  final IoTextInputCharacterFieldStyle disabled;

  /// Linearly interpolate between two [IoTextInputStyle].
  IoTextInputStyle lerp(IoTextInputStyle other, double t) {
    return IoTextInputStyle(
      padding: EdgeInsets.lerp(padding, other.padding, t)!,
      empty: empty.lerp(other.empty, t),
      filled: filled.lerp(other.filled, t),
      focused: focused.lerp(other.focused, t),
      disabled: disabled.lerp(other.disabled, t),
    );
  }

  @override
  List<Object?> get props => [
        padding,
        empty,
        filled,
        focused,
        disabled,
      ];
}

/// {@template io_text_input_character_field_style}
/// The style of a character field in the [IoTextInput].
/// {@endtemplate}
class IoTextInputCharacterFieldStyle extends Equatable {
  /// {@macro io_text_input_character_field_style}
  const IoTextInputCharacterFieldStyle({
    required this.backgroundColor,
    required this.border,
    required this.borderRadius,
    required this.textStyle,
  });

  /// The background color of the character field.
  final Color backgroundColor;

  /// The border of the character field.
  final Border border;

  /// The border radius of the character field.
  final BorderRadius borderRadius;

  /// The text style of the character field.
  final TextStyle textStyle;

  /// Linearly interpolate between two [IoTextInputCharacterFieldStyle].
  IoTextInputCharacterFieldStyle lerp(
    IoTextInputCharacterFieldStyle other,
    double t,
  ) {
    return IoTextInputCharacterFieldStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      border: Border.lerp(border, other.border, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
    );
  }

  @override
  List<Object?> get props => [backgroundColor, border, borderRadius, textStyle];
}
