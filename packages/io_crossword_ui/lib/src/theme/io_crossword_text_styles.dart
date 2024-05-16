import 'package:flutter/material.dart';

/// {@template io_crossword_text_styles}
/// Text styles used in the IO Crossword UI.
/// {@endtemplate}
abstract class IoCrosswordTextStyles {
  const IoCrosswordTextStyles._();

  /// Package name
  static const package = 'io_crossword_ui';

  /// Text styles for desktop devices.
  static const desktop = _TextStylesDesktop._();

  /// Text styles for mobile devices.
  static const mobile = _TextStylesMobile._();

  /// Creates a [TextTheme] from the text styles.
  TextTheme get textTheme => TextTheme(
        displayLarge: heading1,
        displaySmall: h2,
        bodyLarge: body,
        bodyMedium: body3,
        bodySmall: body5,
      );

  /// Text style for heading1.
  TextStyle get heading1;

  /// Text style for h2.
  TextStyle get h2;

  /// Text style for body.
  TextStyle get body;

  /// Text style for body2.
  TextStyle get body2;

  /// Text style for body3.
  TextStyle get body3;

  /// Text style for body4.
  TextStyle get body4;

  /// Text style for body5.
  TextStyle get body5;
}

class _TextStylesDesktop extends IoCrosswordTextStyles {
  const _TextStylesDesktop._() : super._();

  @override
  TextStyle get heading1 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w400,
        fontSize: 32,
        height: 1.25,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get h2 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w500,
        fontSize: 24,
        height: 1.33,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get body => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w400,
        fontSize: 20,
        height: 1.4,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get body2 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w500,
        fontSize: 20,
        height: 1.4,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get body3 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w400,
        fontSize: 18,
        height: 1.8,
        letterSpacing: -.2,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get body4 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get body5 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0,
        package: IoCrosswordTextStyles.package,
      );
}

class _TextStylesMobile extends IoCrosswordTextStyles {
  const _TextStylesMobile._() : super._();

  @override
  TextStyle get heading1 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w500,
        fontSize: 24,
        height: 1.33,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get h2 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w500,
        fontSize: 18,
        height: 1.3,
        letterSpacing: 0,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get body => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w400,
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get body2 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w500,
        fontSize: 16,
        height: 1.5,
        letterSpacing: 0,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get body3 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w500,
        fontSize: 14,
        height: 1.43,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get body4 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w500,
        fontSize: 12,
        height: 1.33,
        package: IoCrosswordTextStyles.package,
      );

  @override
  TextStyle get body5 => const TextStyle(
        fontFamily: 'Google Sans',
        fontWeight: FontWeight.w400,
        fontSize: 12,
        height: 1.33,
        package: IoCrosswordTextStyles.package,
      );
}

/// Extension for [TextStyle] to add Font Weight
extension TextStyleX on TextStyle? {
  /// Copy with [FontWeight.w700]
  TextStyle? get bold => this?.copyWith(fontWeight: FontWeight.w700);

  /// Copy with [FontWeight.w500]
  TextStyle? get medium => this?.copyWith(fontWeight: FontWeight.w500);

  /// Copy with [FontWeight.w400]
  TextStyle? get regular => this?.copyWith(fontWeight: FontWeight.w400);
}
