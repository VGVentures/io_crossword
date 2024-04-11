import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_character_field}
/// The character field used in to show and fill up crossword words.
/// {@endtemplate}
class IoCharacterField extends StatelessWidget {
  /// {@macro io_character_field}
  const IoCharacterField({
    required this.style,
    required this.child,
    super.key,
  });

  /// The style of this [IoCharacterField].
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
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 48.61,
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
  });

  /// The background color of the character field.
  final Color backgroundColor;

  /// The border of the character field.
  final Border border;

  /// The border radius of the character field.
  final BorderRadius borderRadius;

  /// The text style of the character field.
  final TextStyle textStyle;

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
    );
  }

  @override
  List<Object?> get props => [backgroundColor, border, borderRadius, textStyle];
}
