import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template character_validator}
/// Validates a character.
///
/// Returns `true` if the character is valid, otherwise `false`.
///
/// This determines if a new character will be accepted or not. If not accepted,
/// it will not be rendered in the character field and it wil be considered as
/// a backspace.
/// {@endtemplate}
typedef CharacterValidator = bool Function(String character);

/// {@template io_text_input}
/// An IO styled text input that accepts a fixed number of characters.
///
/// The input can be configured to only accept certain characters, and some
/// characters can be fixed and not editable.
/// {@endtemplate}
class IoTextInput extends StatefulWidget {
  /// {@macro io_text_input}
  IoTextInput._({
    required this.length,
    required this.characterValidator,
    Map<int, String>? characters,
    super.key,
  }) : characters = characters != null
            ? UnmodifiableMapView(
                Map.from(characters)
                  ..removeWhere((key, value) => key >= length),
              )
            : null;

  /// Creates an [IoTextInput] that only accepts alphabetic characters.
  IoTextInput.alphabetic({
    required int length,
    Map<int, String>? characters,
    Key? key,
  }) : this._(
          length: length,
          key: key,
          characters: characters,
          characterValidator: (character) =>
              RegExp('[a-zA-Z]').hasMatch(character),
        );

  /// The length of the input.
  ///
  /// In other words, the number of characters that the input will accept.
  final int length;

  /// Characters that are fixed and cannot be changed.
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

  /// {@macro character_validator}
  final CharacterValidator characterValidator;

  /// The character that represents an empty character field.
  static const _emptyCharacter = '_';

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

  late String text;

  final Map<int, FocusNode> _focusNodes = {};

  /// The [FocusNode] of the character field that is currently being inputted.
  FocusNode? get _activeFocusNode => _focusNodes[_currentCharacterIndex];

  final Map<int, TextEditingController> _controllers = {};

  /// The [TextEditingController] of the character field that is currently
  /// being inputted.
  TextEditingController? get _activeController =>
      _controllers[_currentCharacterIndex];

  /// Callback for when a character field has changed its value.
  void _onTextChanged(String value) {
    final newValue = (value.split('')
          ..removeWhere((c) => !widget.characterValidator(c)))
        .join();

    if (newValue.isEmpty) {
      _activeController?.text = IoTextInput._emptyCharacter;
      _previous();

      setState(() {
        // Update the styles.
      });
      return;
    }

    final newCharacter = newValue[newValue.length - 1];
    _activeController?.text = newCharacter.toUpperCase();
    _next();

    setState(() {
      // Update the styles.
    });
  }

  /// Changes the current character field that is being inputted, to the
  /// next available character field.
  ///
  /// If there are no more available character fields ahead, then nothing will
  /// happen.
  void _next() {
    final nextFields = _controllers.entries
        .where((e) => e.key > (_currentCharacterIndex ?? -1))
        .map((e) => e.key);

    if (nextFields.isEmpty) return;
    _updateCurrentIndex(nextFields.first);
  }

  /// Changes the current character field that is being inputted, to the
  /// previous available character field.
  ///
  /// If no more previous character fields are available, then nothing will
  /// happen.
  ///
  /// Triggered when a character is removed, usually associated when the user
  /// presses backspace.
  void _previous() {
    final previousFields = _controllers.entries
        .where((e) => e.key < (_currentCharacterIndex ?? widget.length))
        .map((e) => e.key);

    if (previousFields.isEmpty) return;
    _updateCurrentIndex(previousFields.last);
  }

  /// Changes the current character field that is being inputted, to the
  /// character at the [index] position.
  ///
  /// If [index] is already the current character field, then nothing will
  /// happen.
  ///
  /// Additionally, if the [index] is invalid, then the current character field
  /// will not be updated. An invalid [index] is one that is not within the
  /// range of the input length or one that is fixed by
  /// [IoTextInput.characters].
  void _updateCurrentIndex(int index) {
    final isWithinRange = index < 0 || index >= widget.length;
    final isFixed =
        widget.characters != null && widget.characters!.containsKey(index);
    if (index == _currentCharacterIndex || isWithinRange || isFixed) {
      return;
    }

    _currentCharacterIndex = index;
    _focus();
  }

  /// Focus on the character field that is currently being inputted.
  ///
  /// Characters can only be inputted from left to right, hence if the user
  /// focuses on a character field before or after the current one, the focus
  /// will adjusted to be in the current one.
  void _focus() {
    _activeFocusNode?.requestFocus();
  }

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < widget.length; i++) {
      if (widget.characters == null || !widget.characters!.containsKey(i)) {
        _focusNodes[i] = FocusNode();
        _controllers[i] =
            TextEditingController(text: IoTextInput._emptyCharacter);
      }
    }

    for (final focus in _focusNodes.values) {
      focus.addListener(() {
        if (focus.hasFocus) _focus();
        setState(() {
          // Update the styles.
        });
      });
    }

    _next();
  }

  @override
  void didUpdateWidget(covariant IoTextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // TODO(alestiago): Handle this.
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
      } else if (controller.text == IoTextInput._emptyCharacter) {
        style = textInputStyle.empty;
      } else {
        style = textInputStyle.filled;
      }

      final character = Padding(
        padding: textInputStyle.padding,
        child: _CharacterField(
          style: style,
          child: readOnly
              ? Text(widget.characters![i]!, style: style.textStyle)
              : EditableText(
                  keyboardType: TextInputType.text,
                  scrollPadding: EdgeInsets.zero,
                  controller: controller,
                  enableSuggestions: false,
                  onChanged: _onTextChanged,
                  focusNode: focusNode,
                  textAlign: TextAlign.center,
                  style: style.textStyle,
                  onSelectionChanged: (selection, cause) {
                    controller.selection = TextSelection.fromPosition(
                      const TextPosition(offset: 1),
                    );
                  },
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

class _CharacterField extends StatelessWidget {
  const _CharacterField({
    required this.style,
    required this.child,
  });

  /// {@macro io_text_input_character_field_style}
  final IoTextInputCharacterFieldStyle style;

  /// The child widget.
  ///
  /// Usually a [Text] or an [EditableText] widget.
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
