import 'package:flutter/material.dart';

/// Colors used in the I/O Crossword UI.
abstract class IoCrosswordColors {
  /// seedWhite
  static const seedWhite = Color(0xffffffff);

  /// black
  static const black = Color(0xFF010101);

  /// darkGray
  static const darkGray = Color(0xff212123);

  /// mediumGray
  static const mediumGray = Color(0xff393B40);

  /// accessibleGrey
  static const accessibleGrey = Color(0xff5f6368);

  /// soft gray
  static const softGray = Color(0xFF80858B);

  /// color for the links
  static const linkBlue = Color(0xFF1A73E8);

  /// light blue gradient
  static const lightGradientBlue = Color(0xFFB1CEFF);

  /// light blue gradient
  static const darkGradientBlue = Color(0xFF337BFA);

  /// developer blue
  static const developerBlue = Color(0xFFB7D8FF);

  /// googleBlue
  static const googleBlue = Color(0xFF4383F2);

  /// googleBlue
  static const googleGreen = Color(0xFF6AC76E);

  /// googleBlue
  static const googleYellow = Color(0xFFFFC10A);

  /// googleBlue
  static const googleRed = Color(0xFFFD2B25);

  /// flutterBlue
  static const flutterBlue = Color(0xFF5CA7FF);

  /// androidGreen
  static const androidGreen = Color(0xFF6AC76E);

  /// sparkyYellow
  static const sparkyYellow = Color(0xFFFECD3C);

  /// chromeRed
  static const chromeRed = Color(0xFFFF6F5C);

  /// error red color
  static const redError = Color(0xFFEA4335);

  /// Light theme gradient
  static const LinearGradient geminiGradient = LinearGradient(
    colors: [
      IoCrosswordColors.lightGradientBlue,
      IoCrosswordColors.darkGradientBlue,
    ],
    stops: [0.0, 1.0],
  );

  /// Google multi team theme gradient
  static const LinearGradient googleGradient = LinearGradient(
    colors: [
      IoCrosswordColors.googleBlue,
      IoCrosswordColors.googleGreen,
      IoCrosswordColors.googleYellow,
      IoCrosswordColors.googleRed,
    ],
    stops: [0.0, 0.33, 0.66, 1.0],
  );

  /// Dash theme gradient
  static const LinearGradient dashGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xFF1F85FA),
      Color(0xFF00A947),
    ],
    stops: [0.0, 1.0],
  );

  /// Android theme gradient
  static const LinearGradient androidGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xFFFFC700),
      Color(0xFF00A947),
    ],
    stops: [0.0, 1.0],
  );

  /// Sparky theme gradient
  static const LinearGradient sparkyGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xFFFFC700),
      Color(0xFFFF5C10),
      Color(0xFFFD2B25),
    ],
    stops: [0.33, 0.66, 1.0],
  );

  /// Dino theme gradient
  static const LinearGradient dinoGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: [
      Color(0xFF4383F2),
      Color(0xFFA769D9),
      Color(0xFFFD2B25),
    ],
    stops: [0.33, 0.66, 1.0],
  );
}
