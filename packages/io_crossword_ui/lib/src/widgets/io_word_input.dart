import 'dart:collection';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
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

/// {@template io_word_input_controller}
/// A controller for the [IoWordInput].
/// {@endtemplate}
class IoWordInputController extends ChangeNotifier {
  String _word = '';

  void _updateWord(String word) {
    if (word == _word) return;

    _word = word;
    notifyListeners();
  }

  /// The word that has been inputted so far.
  ///
  /// This word might not reach the specified [IoWordInput.length].
  ///
  /// Updating the word through the controller is not supported.
  ///
  /// See also:
  ///
  /// * [IoWordInput.onWord], the callback that is called when a word has been
  ///  completed.
  String get word => _word;
}

/// {@template io_word_input}
/// An IO styled text input that accepts a fixed number of characters.
///
/// The input can be configured to only accept certain characters, and some
/// characters can be fixed and not editable.
/// {@endtemplate}
class IoWordInput extends StatefulWidget {
  /// {@macro io_word_input}
  IoWordInput._({
    required this.length,
    required this.characterValidator,
    this.controller,
    this.onWord,
    this.onSubmit,
    Map<int, String>? characters,
    super.key,
  }) : characters = characters != null
            ? UnmodifiableMapView(
                Map.from(characters)
                  ..removeWhere((key, value) => key >= length),
              )
            : null;

  /// Creates an [IoWordInput] that only accepts alphabetic characters.
  IoWordInput.alphabetic({
    required int length,
    IoWordInputController? controller,
    Map<int, String>? characters,
    ValueChanged<String>? onWord,
    ValueChanged<String>? onSubmit,
    Key? key,
  }) : this._(
          length: length,
          key: key,
          characters: characters,
          controller: controller,
          onWord: onWord,
          onSubmit: onSubmit,
          characterValidator: (character) =>
              RegExp('[a-zA-Z]').hasMatch(character),
        );

  /// {@macro io_word_input_controller}
  final IoWordInputController? controller;

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

  /// Callback for when the word has been completed.
  ///
  /// If you wish to remove the focus from the input once a word has been
  /// completed, you can parent the [IoWordInput] with a [Focus] widget and
  /// call [FocusNode.removeFocus()] in this callback. For example:
  ///
  /// ```dart
  /// Focus(
  ///     focusNode: _focusNode,
  ///     child: IoWordInput.alphabetic(
  ///       length: 5,
  ///       onWord: (value) {
  ///         _focusNode.unfocus();
  ///       },
  ///     ),
  ///   );
  /// ),
  /// ```
  final ValueChanged<String>? onWord;

  /// Callback for when the word has been submitted.
  ///
  /// This is called when the user presses the submit button on the keyboard.
  ///
  /// The given value is the word that has been inputted so far. Hence, it might
  /// not be the full word if the input length has not been reached.
  final ValueChanged<String>? onSubmit;

  /// The character that represents an empty character field.
  static const _emptyCharacter = '_';

  @override
  State<IoWordInput> createState() => _IoWordInputState();
}

// TODO(alestiago): Updating the widget does nothing yet, since the current
// implementation is the first iteration and ignores `didUpdateWidget`. This
// will be updated in the future, as soon as the following is resolved:
// https://very-good-ventures-team.monday.com/boards/6004820050/pulses/6364673378
class _IoWordInputState extends State<IoWordInput> {
  /// The current character that is being inputted.
  ///
  /// Will be `null` if there is no available character field to input. This
  /// happens when [IoWordInput.characters] is has the same length as
  /// [IoWordInput.length]. In other words, when there is no available character
  /// field to input since they are all fixed.
  int? _currentCharacterIndex;

  final Map<int, FocusNode> _focusNodes = {};

  /// The [FocusNode] of the character field that is currently being inputted.
  FocusNode? get _activeFocusNode => _focusNodes[_currentCharacterIndex];

  final Map<int, TextEditingController> _controllers = {};

  /// The [TextEditingController] of the character field that is currently
  /// being inputted.
  TextEditingController? get _activeController =>
      _controllers[_currentCharacterIndex];

  /// The entire word that has been inputted so far.
  String get _word {
    final word = StringBuffer();

    for (var i = 0; i < widget.length; i++) {
      final isFixed =
          widget.characters != null && widget.characters!.containsKey(i);
      final character =
          (isFixed ? widget.characters![i] : _controllers[i]!.text)!
              .replaceAll(IoWordInput._emptyCharacter, '');
      if (character.isNotEmpty) word.write(character);
    }
    return word.toString();
  }

  /// Callback for when a character field has changed its value.
  void _onTextChanged(String value) {
    final newValue = (value.split('')
          ..removeWhere((c) => !widget.characterValidator(c)))
        .join();

    void updateWord() {
      setState(() {});
      widget.controller?._updateWord(_word);
    }

    if (newValue.isEmpty) {
      _activeController?.text = IoWordInput._emptyCharacter;
      _previous();
      updateWord();
      return;
    }

    // The new characters will always be at the end, since the selection is
    // forced to be at the end.
    final newCharacter = newValue[newValue.length - 1];
    _activeController?.text = newCharacter.toUpperCase();
    _next();
    updateWord();
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

    if (nextFields.isEmpty) {
      widget.onWord?.call(_word);
      return;
    }

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
  /// [IoWordInput.characters].
  void _updateCurrentIndex(int index) {
    final isOutsideRange = index < 0 || index >= widget.length;
    final isFixed =
        widget.characters != null && widget.characters!.containsKey(index);
    if (index == _currentCharacterIndex || isOutsideRange || isFixed) {
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
            TextEditingController(text: IoWordInput._emptyCharacter);
      }
    }

    for (final focusNode in _focusNodes.values) {
      focusNode.addListener(() => _onFocusChanged(focusNode));
    }

    widget.controller?._updateWord(_word);
    _next();
  }

  void _onFocusChanged(FocusNode focusNode) {
    if (focusNode.hasFocus) _focus();
    focusNode.parent;
    setState(() {
      // Styling depends on focus, update it.
    });
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
    final textInputStyle = Theme.of(context).io.wordInput;

    final characters = <Widget>[];
    for (var i = 0; i < widget.length; i++) {
      final focusNode = _focusNodes[i];
      final controller = _controllers[i];
      final readOnly = !(focusNode != null && controller != null);

      late final IoWordInputCharacterFieldStyle style;
      if (readOnly) {
        style = textInputStyle.disabled;
      } else if (focusNode.hasFocus) {
        style = textInputStyle.focused;
      } else if (controller.text == IoWordInput._emptyCharacter) {
        style = textInputStyle.empty;
      } else {
        style = textInputStyle.filled;
      }

      final characterField = _CharacterField(
        style: style,
        child: readOnly
            ? Text(
                widget.characters![i]!,
                style: style.textStyle,
                textAlign: TextAlign.center,
              )
            : EditableText(
                keyboardType: TextInputType.text,
                enableSuggestions: false,
                controller: controller,
                focusNode: focusNode,
                style: style.textStyle,
                cursorWidth: 0,
                textAlign: TextAlign.center,
                cursorColor: Colors.transparent,
                backgroundCursorColor: Colors.transparent,
                onChanged: _onTextChanged,
                onSubmitted: widget.onSubmit != null
                    ? (_) => widget.onSubmit!(_word)
                    : null,
                onSelectionChanged: (selection, cause) {
                  controller.selection = TextSelection.fromPosition(
                    const TextPosition(offset: 1),
                  );
                },
              ),
      );

      final character = Padding(
        padding: textInputStyle.padding,
        child: characterField,
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

class _CharacterField extends StatefulWidget {
  const _CharacterField({
    required this.style,
    required this.child,
  });

  /// The style of this [_CharacterField].
  ///
  /// See also:
  ///
  /// * [IoThemeExtension.wordInput], the default style for [IoWordInput].
  final IoWordInputCharacterFieldStyle style;

  /// The child widget.
  ///
  /// Usually a [Text] or an [EditableText] widget.
  final Widget child;

  @override
  State<_CharacterField> createState() => _CharacterFieldState();
}

class _CharacterFieldState extends State<_CharacterField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );

  late var _offsetTween = Tween(
    begin: Offset(0, -widget.style.elevation),
    end: Offset(0, -widget.style.elevation),
  );

  late var _decorationTween = DecorationTween(
    begin: widget.style._toBoxDecoration(),
    end: widget.style._toBoxDecoration(),
  );

  @override
  void didUpdateWidget(covariant _CharacterField oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.forward(from: 0);

    _offsetTween = Tween(
      begin: Offset(0, -oldWidget.style.elevation),
      end: Offset(0, -widget.style.elevation),
    );
    _decorationTween = DecorationTween(
      begin: oldWidget.style._toBoxDecoration(),
      end: widget.style._toBoxDecoration(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetTween.evaluate(_controller),
          child: SizedBox.fromSize(
            size: widget.style.size,
            child: DecoratedBox(
              decoration: _decorationTween.evaluate(_controller),
              child: Center(child: widget.child),
            ),
          ),
        );
      },
    );
  }
}

/// {@template io_word_input_style}
/// The style of the [IoWordInput].
/// {@endtemplate}
class IoWordInputStyle extends Equatable {
  /// {@macro io_word_input_style}
  const IoWordInputStyle({
    required this.padding,
    required this.empty,
    required this.filled,
    required this.focused,
    required this.disabled,
  });

  /// The padding around the character fields.
  final EdgeInsets padding;

  /// The style of an empty character field.
  final IoWordInputCharacterFieldStyle empty;

  /// The style of the filled character field.
  ///
  /// A filled character field is the one that has a value.
  final IoWordInputCharacterFieldStyle filled;

  /// The style of the focused character field.
  ///
  /// A focused character field is the one that is currently being inputted.
  final IoWordInputCharacterFieldStyle focused;

  /// The style of the disabled character field.
  ///
  /// A disabled character field is the one that is not available for input.
  final IoWordInputCharacterFieldStyle disabled;

  /// Linearly interpolate between two [IoWordInputStyle].
  IoWordInputStyle lerp(IoWordInputStyle other, double t) {
    return IoWordInputStyle(
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

/// {@template io_word_input_character_field_style}
/// The style of a character field in the [IoWordInput].
/// {@endtemplate}
class IoWordInputCharacterFieldStyle extends Equatable {
  /// {@macro io_word_input_character_field_style}
  const IoWordInputCharacterFieldStyle({
    required this.backgroundColor,
    required this.border,
    required this.borderRadius,
    required this.textStyle,
    required this.size,
    this.elevation = 0,
  });

  /// The background color of the character field.
  final Color backgroundColor;

  /// The border of the character field.
  final Border border;

  /// The border radius of the character field.
  final BorderRadius borderRadius;

  /// The text style of the character field.
  final TextStyle textStyle;

  /// The size of the character field.
  final Size size;

  /// How much should the character field be elevated.
  final double elevation;

  BoxDecoration _toBoxDecoration() {
    return BoxDecoration(
      color: backgroundColor,
      border: border,
      borderRadius: borderRadius,
    );
  }

  /// Linearly interpolate between two [IoWordInputCharacterFieldStyle].
  IoWordInputCharacterFieldStyle lerp(
    IoWordInputCharacterFieldStyle other,
    double t,
  ) {
    return IoWordInputCharacterFieldStyle(
      backgroundColor: Color.lerp(backgroundColor, other.backgroundColor, t)!,
      border: Border.lerp(border, other.border, t)!,
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      textStyle: TextStyle.lerp(textStyle, other.textStyle, t)!,
      size: Size.lerp(size, other.size, t)!,
      elevation: lerpDouble(elevation, other.elevation, t)!,
    );
  }

  @override
  List<Object?> get props => [
        backgroundColor,
        border,
        borderRadius,
        textStyle,
        size,
        elevation,
      ];
}
