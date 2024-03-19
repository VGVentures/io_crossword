import 'package:flutter/material.dart';

/// Text styles used in the IO Crossword UI.
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
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );

  /// Display large text style.
  TextStyle get displayLarge;

  /// Display medium text style.
  TextStyle get displayMedium;

  /// Display small text style.
  TextStyle get displaySmall;

  /// Headline large text style.
  TextStyle get headlineLarge;

  /// Headline medium text style.
  TextStyle get headlineMedium;

  /// Headline small text style.
  TextStyle get headlineSmall;

  /// Title large text style.
  TextStyle get titleLarge;

  /// Title medium text style.
  TextStyle get titleMedium;

  /// Title small text style.
  TextStyle get titleSmall;

  /// Body large text style.
  TextStyle get bodyLarge;

  /// Body medium text style.
  TextStyle get bodyMedium;

  /// Body small text style.
  TextStyle get bodySmall;

  /// Label large text style.
  TextStyle get labelLarge;

  /// Label medium text style.
  TextStyle get labelMedium;

  /// Label small text style.
  TextStyle get labelSmall;

  /// displayLG
  static const TextStyle displayLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 57,
    height: 1.12,
    package: package,
  );

  /// displayMD
  static const TextStyle displayMD = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 45,
    height: 1.15,
    package: package,
  );

  /// displaySM
  static const TextStyle displaySM = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 36,
    height: 1.22,
    package: package,
  );

  /// headlineLG
  static const TextStyle headlineLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 32,
    height: 1.25,
    package: package,
  );

  /// headlineMD
  static const TextStyle headlineMD = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 28,
    height: 1.28,
    package: package,
  );

  /// headlineSM
  static const TextStyle headlineSM = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 24,
    height: 1.33,
    package: package,
  );

  /// titleLG
  static const TextStyle titleLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 22,
    height: 1.27,
    package: package,
  );

  /// titleMD
  static const TextStyle titleMD = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 20,
    height: 1.4,
    package: package,
  );

  /// titleSM
  static const TextStyle titleSM = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
    package: package,
  );

  /// bodyLG
  static const TextStyle bodyLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    letterSpacing: -0.01,
    package: package,
  );

  /// bodyMD
  static const TextStyle bodyMD = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.43,
    package: package,
  );

  /// bodySM
  static const TextStyle bodySM = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1.33,
    package: package,
  );

  /// labelLG
  static const TextStyle labelLG = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 1.43,
    package: package,
  );

  /// labelMD
  static const TextStyle labelMD = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 1.66,
    package: package,
  );

  /// labelSM
  static const TextStyle labelSM = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w500,
    fontSize: 11,
    height: 1.45,
    package: package,
  );

  /// gridLetter
  static const TextStyle gridLetter = TextStyle(
    fontFamily: 'Google Sans',
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 1.27,
    letterSpacing: 1.2,
    package: package,
  );
}

class _TextStylesDesktop extends IoCrosswordTextStyles {
  const _TextStylesDesktop._() : super._();

  @override
  TextStyle get displayLarge => IoCrosswordTextStyles.displayLG;

  @override
  TextStyle get displayMedium => IoCrosswordTextStyles.displayMD;

  @override
  TextStyle get displaySmall => IoCrosswordTextStyles.displaySM;

  @override
  TextStyle get headlineLarge => IoCrosswordTextStyles.headlineLG;

  @override
  TextStyle get headlineMedium => IoCrosswordTextStyles.headlineMD;

  @override
  TextStyle get headlineSmall => IoCrosswordTextStyles.headlineSM;

  @override
  TextStyle get titleLarge => IoCrosswordTextStyles.titleLG;

  @override
  TextStyle get titleMedium => IoCrosswordTextStyles.titleMD;

  @override
  TextStyle get titleSmall => IoCrosswordTextStyles.titleSM;

  @override
  TextStyle get bodyLarge => IoCrosswordTextStyles.bodyLG;

  @override
  TextStyle get bodyMedium => IoCrosswordTextStyles.bodyMD;

  @override
  TextStyle get bodySmall => IoCrosswordTextStyles.bodySM;

  @override
  TextStyle get labelLarge => IoCrosswordTextStyles.labelLG;

  @override
  TextStyle get labelMedium => IoCrosswordTextStyles.labelMD;

  @override
  TextStyle get labelSmall => IoCrosswordTextStyles.labelSM;
}

class _TextStylesMobile extends IoCrosswordTextStyles {
  const _TextStylesMobile._() : super._();

  @override
  TextStyle get displayLarge => IoCrosswordTextStyles.displayLG;

  @override
  TextStyle get displayMedium => IoCrosswordTextStyles.displayMD;

  @override
  TextStyle get displaySmall => IoCrosswordTextStyles.displaySM;

  @override
  TextStyle get headlineLarge => IoCrosswordTextStyles.headlineLG;

  @override
  TextStyle get headlineMedium => IoCrosswordTextStyles.headlineMD;

  @override
  TextStyle get headlineSmall => IoCrosswordTextStyles.headlineSM;

  @override
  TextStyle get titleLarge => IoCrosswordTextStyles.titleLG;

  @override
  TextStyle get titleMedium => IoCrosswordTextStyles.titleMD;

  @override
  TextStyle get titleSmall => IoCrosswordTextStyles.titleSM;

  @override
  TextStyle get bodyLarge => IoCrosswordTextStyles.bodyLG;

  @override
  TextStyle get bodyMedium => IoCrosswordTextStyles.bodyMD;

  @override
  TextStyle get bodySmall => IoCrosswordTextStyles.bodySM;

  @override
  TextStyle get labelLarge => IoCrosswordTextStyles.labelLG;

  @override
  TextStyle get labelMedium => IoCrosswordTextStyles.labelMD;

  @override
  TextStyle get labelSmall => IoCrosswordTextStyles.labelSM;
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
