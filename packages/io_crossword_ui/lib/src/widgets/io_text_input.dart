import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

// class TextEditingController extends TextEditingController {
//   TextEditingController() {
//     text = _emptyCharacter;
//   }

//   static const _emptyCharacter = '_';

//   @override
//   set value(TextEditingValue newValue) {
//     final newText = newValue.text;
//     if (newText.isEmpty || newText == _emptyCharacter) {
//       super.value = newValue.copyWith(text: _emptyCharacter);
//       return;
//     }

//     final lastCharacter = newText[newText.length - 1];
//     final isAlphabetic = RegExp('[a-zA-Z]').hasMatch(lastCharacter);
//     if (isAlphabetic) {
//       super.value = newValue.copyWith(text: lastCharacter.toUpperCase());
//     }
//   }
// }

const _emptyCharacter = '_';

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

  late final _controllers = List.generate(
    widget.length,
    (_) => TextEditingController(text: _emptyCharacter),
  );

  void _onTextChanged(String value) {
    final controller = _controllers[_currentCharacterIndex];
    if (value.isEmpty) {
      _previous();
      controller.text = _emptyCharacter;
      return;
    }

    final newCharacter = value[value.length - 1];
    final isAlphabetic = RegExp('[a-zA-Z]').hasMatch(newCharacter);
    if (!isAlphabetic) {
      controller.text =
          controller.text.substring(0, controller.text.length - 1);
      return;
    }

    controller.text = newCharacter.toUpperCase();
    _next();
  }

  void _next() {
    final nextCharacter = _controllers.indexWhere(
      (controller) => controller.text == _emptyCharacter,
    );
    if (nextCharacter == -1) {
      _submit();
      return;
    }
    _changeCurrentIndex(nextCharacter);
  }

  void _previous() {
    final previousCharacter = _currentCharacterIndex - 1;
    if (previousCharacter == -1) {
      return;
    }
    _changeCurrentIndex(previousCharacter);
  }

  void _changeCurrentIndex(int index) {
    if ((index < 0 || index >= widget.length) ||
        index == _currentCharacterIndex) {
      return;
    }

    _currentCharacterIndex = index;
    _focus();
  }

  void _focus() {
    final focusNode = _focusNodes[_currentCharacterIndex];
    if (!focusNode.hasFocus) {
      focusNode.requestFocus();
    }
  }

  void _submit() {}

  @override
  void initState() {
    super.initState();
    _changeCurrentIndex(_currentCharacterIndex);
    for (final focus in _focusNodes) {
      focus.addListener(() {
        if (focus.hasFocus) _focus();
      });
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
              onChanged: _onTextChanged,
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
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String value) onChanged;

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

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).io.textInput;

    final activeStyle = style.empty;

    return SizedBox.square(
      dimension: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: activeStyle.borderRadius,
          border: activeStyle.border,
          color: widget.focusNode.hasFocus
              ? Colors.red
              : activeStyle.backgroundColor,
        ),
        child: Center(
          child: EditableText(
            keyboardType: TextInputType.text,
            // readOnly: widget.controller.readOnly,
            controller: widget.controller,
            onChanged: widget.onChanged,
            focusNode: widget.focusNode,
            textAlign: TextAlign.center,
            style: activeStyle.textStyle,
            cursorColor: Colors.transparent,
            backgroundCursorColor: activeStyle.backgroundColor,
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
