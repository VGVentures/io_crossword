import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

/// {@template io_theme_extension}
/// Extension for the IO theme.
/// {@endtemplate}
@immutable
class IoThemeExtension extends Equatable
    implements ThemeExtension<IoThemeExtension> {
  /// {@macro io_theme_extension}
  const IoThemeExtension({
    required this.wordTheme,
    required this.iconButtonTheme,
    required this.cardTheme,
    required this.physicalModel,
    required this.outlineButtonTheme,
    required this.wordInput,
    required this.colorScheme,
    required this.crosswordLetterTheme,
    required this.textStyles,
  });

  /// {@macro io_word_theme}
  final IoWordTheme wordTheme;

  /// {@macro io_icon_button_theme}
  final IoIconButtonTheme iconButtonTheme;

  /// {@macro io_card_theme}
  final IoCardTheme cardTheme;

  /// {@macro io_physical_model_style}
  final IoPhysicalModelStyle physicalModel;

  /// {@macro io_outline_button}
  final IoOutlineButtonTheme outlineButtonTheme;

  /// {@macro io_word_input_theme}
  final IoWordInputTheme wordInput;

  /// {@macro io_color_scheme}
  final IoColorScheme colorScheme;

  /// {@macro io_crossword_letter_theme}
  final IoCrosswordLetterTheme crosswordLetterTheme;

  /// {@macro io_crossword_text_styles}
  final IoCrosswordTextStyles textStyles;

  @override
  Object get type => IoThemeExtension;

  @override
  ThemeExtension<IoThemeExtension> copyWith({
    IoWordTheme? wordTheme,
    IoIconButtonTheme? iconButtonTheme,
    IoCardTheme? cardTheme,
    IoPhysicalModelStyle? physicalModel,
    IoWordInputTheme? wordInput,
    IoColorScheme? colorScheme,
    IoOutlineButtonTheme? outlineButtonTheme,
    IoCrosswordLetterTheme? crosswordLetterTheme,
    IoCrosswordTextStyles? textStyles,
  }) {
    return IoThemeExtension(
      wordTheme: wordTheme ?? this.wordTheme,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
      cardTheme: cardTheme ?? this.cardTheme,
      physicalModel: physicalModel ?? this.physicalModel,
      wordInput: wordInput ?? this.wordInput,
      colorScheme: colorScheme ?? this.colorScheme,
      outlineButtonTheme: outlineButtonTheme ?? this.outlineButtonTheme,
      crosswordLetterTheme: crosswordLetterTheme ?? this.crosswordLetterTheme,
      textStyles: textStyles ?? this.textStyles,
    );
  }

  @override
  ThemeExtension<IoThemeExtension> lerp(
    covariant ThemeExtension<IoThemeExtension>? other,
    double t,
  ) {
    if (other is! IoThemeExtension) {
      return this;
    }

    return IoThemeExtension(
      wordTheme: wordTheme.lerp(other.wordTheme, t),
      iconButtonTheme: iconButtonTheme.lerp(other.iconButtonTheme, t),
      cardTheme: cardTheme.lerp(other.cardTheme, t),
      physicalModel: physicalModel.lerp(other.physicalModel, t),
      wordInput: wordInput.lerp(other.wordInput, t),
      colorScheme: colorScheme.lerp(other.colorScheme, t),
      outlineButtonTheme: outlineButtonTheme.lerp(other.outlineButtonTheme, t),
      crosswordLetterTheme:
          crosswordLetterTheme.lerp(other.crosswordLetterTheme, t),
      textStyles: textStyles,
    );
  }

  @override
  List<Object?> get props => [
        wordTheme,
        iconButtonTheme,
        cardTheme,
        physicalModel,
        wordInput,
        colorScheme,
        outlineButtonTheme,
        crosswordLetterTheme,
        textStyles,
      ];
}

/// {@template extended_theme_data}
/// Get the [IoThemeExtension] from the [ThemeData].
/// {@endtemplate}
extension ExtendedThemeData on ThemeData {
  /// {@macro extended_theme_data}
  IoThemeExtension get io {
    final extension = this.extension<IoThemeExtension>();
    assert(extension != null, '$IoThemeExtension not found in $ThemeData');
    return extension!;
  }
}
