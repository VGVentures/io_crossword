import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

const _emptyCharacter = '_';

/// {@template io_text_input}
/// An IO styled text input that accepts a fixed number of characters.
/// {@endtemplate}
class IoTextInput extends StatefulWidget {
  /// {@macro io_text_input}
  IoTextInput({
    required this.length,
    Map<int, String>? characters,
    super.key,
  }) : characters = characters != null
            ? UnmodifiableMapView(
                Map.from(characters)
                  ..removeWhere((key, value) => key >= length),
              )
            : null;

  /// The length of the input.
  ///
  /// In other words, the number of characters that the input will accept.
  final int length;

  /// Values that are fixed and cannot be changed.
  ///
  /// The key is the index of the character field. For example, if the input
  /// has a length of 5, and the first and third characters are fixed, then
  /// the values map will be:
  ///
  /// ```dart
  /// {0: 'A', 2: 'B'}
  /// ```
  ///
  /// If an index is not present in the map, then the character field will be
  /// editable.
  ///
  /// Those indexes that are greater than the length of the input will be
  /// ignored.
  final UnmodifiableMapView<int, String>? characters;

  @override
  State<IoTextInput> createState() => _IoTextInputState();
}

class _IoTextInputState extends State<IoTextInput> {
  /// The current character that is being inputted.
  ///
  /// Will be `null` if there is no available character field to input. This
  /// happens when [IoTextInput.characters] is has the same length as
  /// [IoTextInput.length]. In other words, when there is no available character
  /// field to input since they are all fixed.
  int? _currentCharacterIndex;

  final Map<int, FocusNode> _focusNodes = {};

  FocusNode? get _activeFocusNode => _focusNodes[_currentCharacterIndex];

  final Map<int, TextEditingController> _controllers = {};

  TextEditingController? get _activeController =>
      _controllers[_currentCharacterIndex];

  void _onTextChanged(String value) {
    final isAlphabetic = RegExp('[a-zA-Z]');
    final newValue =
        (value.split('')..removeWhere((c) => !isAlphabetic.hasMatch(c))).join();
    if (newValue.isEmpty) {
      _activeController?.text = _emptyCharacter;
      _previous();

      setState(() {
        // Update the styles.
      });
      return;
    }

    final newCharacter = newValue.substring(0, 1);
    _activeController?.text = newCharacter.toUpperCase();
    _next();

    setState(() {
      // Update the styles.
    });
  }

  void _next() {
    final emptyFields = _controllers.entries
        .where(
          (e) =>
              e.key > (_currentCharacterIndex ?? -1) &&
              e.value.text == _emptyCharacter,
        )
        .map((e) => e.key);

    if (emptyFields.isEmpty) {
      _submit();
      return;
    }

    _changeCurrentIndex(emptyFields.first);
  }

  void _previous() {
    final previousFields = _controllers.entries
        .where((e) => e.key < (_currentCharacterIndex ?? widget.length))
        .map((e) => e.key);

    if (previousFields.isEmpty) return;
    _changeCurrentIndex(previousFields.last);
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
    _activeFocusNode?.requestFocus();
  }

  void _submit() {}

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.length; i++) {
      if (widget.characters == null || !widget.characters!.containsKey(i)) {
        _focusNodes[i] = FocusNode();
        _controllers[i] = TextEditingController(text: _emptyCharacter);
      }
    }

    for (final focus in _focusNodes.values) {
      focus.addListener(() {
        if (focus.hasFocus) _focus();
        setState(() {});
      });
    }

    _next();
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes.values) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textInputStyle = Theme.of(context).io.textInput;

    final characters = <Widget>[];

    for (var i = 0; i < widget.length; i++) {
      final focusNode = _focusNodes[i];
      final controller = _controllers[i];
      final readOnly = !(focusNode != null && controller != null);

      late final IoTextInputCharacterFieldStyle style;
      if (readOnly) {
        style = textInputStyle.disabled;
      } else if (focusNode.hasFocus) {
        style = textInputStyle.focused;
      } else if (controller.text == _emptyCharacter) {
        style = textInputStyle.empty;
      } else {
        style = textInputStyle.filled;
      }

      final character = Padding(
        padding: textInputStyle.padding,
        child: _CharacterInputBox(
          style: style,
          child: readOnly
              ? Text(widget.characters![i]!, style: style.textStyle)
              : EditableText(
                  keyboardType: TextInputType.text,
                  controller: controller,
                  onChanged: _onTextChanged,
                  focusNode: focusNode,
                  textAlign: TextAlign.center,
                  style: style.textStyle,
                  showCursor: false,
                  cursorColor: Colors.transparent,
                  backgroundCursorColor: Colors.transparent,
                ),
        ),
      );
      characters.add(character);
    }

    Widget child = Row(
      mainAxisSize: MainAxisSize.min,
      children: characters,
    );

    if (widget.characters?.length != widget.length) {
      child = GestureDetector(onTap: _focus, child: child);
    }

    return child;
  }
}

class _CharacterInputBox extends StatelessWidget {
  const _CharacterInputBox({
    required this.style,
    required this.child,
  });

  final IoTextInputCharacterFieldStyle style;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: style.borderRadius,
          border: style.border,
          color: style.backgroundColor,
        ),
        child: Center(child: child),
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
