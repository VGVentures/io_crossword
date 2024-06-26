import 'dart:collection';
import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

part 'shakable.dart';

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

  /// Updates the [_word] with new value.
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
    required this.readOnly,
    this.controller,
    this.onWord,
    this.onSubmit,
    this.style,
    Axis? direction,
    Map<int, String>? characters,
    super.key,
  })  : characters = characters != null
            ? UnmodifiableMapView(
                Map.from(characters)
                  ..removeWhere((key, value) => key >= length),
              )
            : null,
        direction = direction ?? Axis.horizontal;

  /// Creates an [IoWordInput] that only accepts alphabetic characters.
  IoWordInput.alphabetic({
    required int length,
    bool readOnly = false,
    IoWordInputController? controller,
    Axis? direction,
    Map<int, String>? characters,
    ValueChanged<String>? onWord,
    ValueChanged<String>? onSubmit,
    IoWordInputStyle? style,
    Key? key,
  }) : this._(
          length: length,
          key: key,
          readOnly: readOnly,
          characters: characters,
          direction: direction,
          controller: controller,
          onWord: onWord,
          onSubmit: onSubmit,
          characterValidator: (character) =>
              RegExp('[a-zA-Z]').hasMatch(character),
          style: style,
        );

  /// {@macro io_word_input_controller}
  final IoWordInputController? controller;

  /// The direction of the input.
  ///
  /// Since the input does not support [TextDirection.rtl], an [Axis.horizontal]
  /// will allow the input to be given from left to right. Whereas an
  /// [Axis.vertical] will allow the input to be given from top to bottom.
  ///
  /// Defaults to [Axis.horizontal].
  final Axis direction;

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

  /// {@macro io_word_input_style}
  ///
  /// Defaults to the inherited [IoWordInputTheme.primary].
  final IoWordInputStyle? style;

  /// Whether the [EditableText] can be changed.
  ///
  /// When this is set to true, the text cannot be modified
  /// by any shortcut or keyboard operation. The text is still selectable.
  ///
  /// Defaults to false.
  final bool readOnly;

  /// The character that represents an empty character field.
  static const _emptyCharacter = '_';

  @override
  State<IoWordInput> createState() => _IoWordInputState();
}

class _IoWordInputState extends State<IoWordInput> {
  /// The index of the current character that is being inputted.
  ///
  /// Initiated to minus one until [initState]'s first call to [_next]
  /// initiating the actual active index.
  int _activeCharacterIndex = -1;

  final Map<int, FocusNode> _focusNodes = {};

  /// The [FocusNode] of the character field that is currently being inputted.
  FocusNode? get _activeFocusNode => _focusNodes[_activeCharacterIndex];

  final Map<int, TextEditingController> _controllers = {};

  /// The [TextEditingController] of the character field that is currently
  /// being inputted.
  TextEditingController? get _activeController =>
      _controllers[_activeCharacterIndex];

  /// The word that has been inputted so far by the user.
  ///
  /// Unlike [_entireWord], this word does not contain the empty character
  /// fields.
  String get _word => _entireWord.replaceAll(
        IoWordInput._emptyCharacter,
        '',
      );

  /// The word that has been inputted so far, with the empty character fields
  /// represented by the [IoWordInput._emptyCharacter].
  String get _entireWord {
    final word = StringBuffer();

    for (var i = 0; i < widget.length; i++) {
      final isFixed =
          widget.characters != null && widget.characters!.containsKey(i);
      final character =
          (isFixed ? widget.characters![i] : _controllers[i]!.text)!;
      if (character.isNotEmpty) {
        word.write(character);
      }
    }

    return word.toString();
  }

  /// The previous word that has been inputted so far.
  ///
  /// This may not reflect the current [_entireWord], but the previous word
  /// before it has been processed by [_onTextChanged].
  ///
  /// After it has been processed, the [_previousWord] will be equivalent to
  /// the [_entireWord].
  ///
  /// It includes the empty character fields, represented by the
  /// [IoWordInput._emptyCharacter].
  late String _previousWord = _entireWord;

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
      final previousActiveCharacter = _previousWord[_activeCharacterIndex];

      _previousWord = _previousWord.replaceAt(
        _activeCharacterIndex,
        IoWordInput._emptyCharacter,
      );
      _activeController?.text = IoWordInput._emptyCharacter;

      // Because in the active controller we get the text already modified,
      // we need this to know if the focused character was empty or filled
      // when the backspace was pressed.
      //
      // If it was empty, we delete also the letter at the previous index.
      if (previousActiveCharacter == IoWordInput._emptyCharacter) {
        _previous();
        _previousWord = _previousWord.replaceAt(
          _activeCharacterIndex,
          IoWordInput._emptyCharacter,
        );
        _activeController?.text = IoWordInput._emptyCharacter;
      }
      updateWord();
      return;
    }

    // The new characters will always be at the end, since the selection is
    // forced to be at the end.
    final newCharacter = newValue[newValue.length - 1];
    _activeController?.text = newCharacter.toUpperCase();
    _previousWord = _previousWord.replaceAt(
      _activeCharacterIndex,
      newCharacter.toUpperCase(),
    );
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
        .where((e) => e.key > _activeCharacterIndex)
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
        .where((e) => e.key < _activeCharacterIndex)
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
    if (index == _activeCharacterIndex || isOutsideRange || isFixed) {
      return;
    }

    _activeCharacterIndex = index;
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
    final textInputStyle =
        widget.style ?? Theme.of(context).io.wordInput.primary;

    final characters = <Widget>[];
    for (var i = 0; i < widget.length; i++) {
      final focusNode = _focusNodes[i];
      final controller = _controllers[i];
      final displayText = !(focusNode != null && controller != null);

      late final IoWordInputCharacterFieldStyle style;
      if (displayText || widget.readOnly) {
        style = textInputStyle.disabled;
      } else if (focusNode.hasFocus) {
        style = textInputStyle.focused;
      } else if (controller.text == IoWordInput._emptyCharacter) {
        style = textInputStyle.empty;
      } else {
        style = textInputStyle.filled;
      }

      final character = Padding(
        padding: textInputStyle.padding,
        child: _CharacterField(
          style: style,
          child: displayText
              ? Text(
                  widget.characters![i]!,
                  style: style.textStyle,
                  textAlign: TextAlign.center,
                )
              : EditableText(
                  readOnly: widget.readOnly,
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
                    final offset = math.min(1, controller.text.length);
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: offset),
                    );
                  },
                ),
        ),
      );
      characters.add(character);
    }

    Widget child = Flex(
      direction: widget.direction,
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
  late final AnimationController _animationController = AnimationController(
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

    _offsetTween = Tween(
      begin: Offset(0, -oldWidget.style.elevation),
      end: Offset(0, -widget.style.elevation),
    );
    _decorationTween = DecorationTween(
      begin: oldWidget.style._toBoxDecoration(),
      end: widget.style._toBoxDecoration(),
    );

    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: _offsetTween.evaluate(_animationController),
          child: SizedBox.fromSize(
            size: widget.style.size,
            child: DecoratedBox(
              decoration: _decorationTween.evaluate(_animationController),
              child: Center(child: widget.child),
            ),
          ),
        );
      },
    );
  }
}

/// {@template io_word_input_theme}
/// The theme of the [IoWordInput].
/// {@endtemplate}
class IoWordInputTheme extends Equatable {
  /// {@macro io_word_input_theme}
  const IoWordInputTheme({
    required this.primary,
    required this.secondary,
  });

  /// The primary style of the [IoWordInput].
  ///
  /// Usually used for inputting a word, such as the initials.
  final IoWordInputStyle primary;

  /// The secondary style of the [IoWordInput].
  ///
  /// Usually used for inputting a crossword word. It's styling is usually
  /// similar to the [IoCrosswordLetter].
  final IoWordInputStyle secondary;

  /// Linearly interpolate between two [IoWordInputTheme]s.
  IoWordInputTheme lerp(IoWordInputTheme other, double t) {
    return IoWordInputTheme(
      primary: primary.lerp(other.primary, t),
      secondary: secondary.lerp(other.secondary, t),
    );
  }

  @override
  List<Object?> get props => [primary, secondary];
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

extension on String {
  String replaceAt(int index, String newChar) =>
      replaceRange(index, index + 1, newChar);
}
