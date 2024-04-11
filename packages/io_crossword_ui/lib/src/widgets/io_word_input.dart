import 'dart:collection';

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

      final character = Padding(
        padding: textInputStyle.padding,
        child: IoCharacterField(
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
