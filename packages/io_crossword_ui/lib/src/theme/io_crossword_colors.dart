import 'package:flutter/material.dart';

/// Colors used in the I/O Crossword UI.
abstract class IoCrosswordColors {
  /// Gold
  static const Color seedGold = Color(0xffffbb00);

  /// Silver
  static const Color seedSilver = Color(0xffdadce0);

  /// Bronze
  static const Color seedBronze = Color(0xffff5145);

  /// seedLightBlue
  static const Color seedLightBlue = Color(0xff54c5f8);

  /// seedBlue
  static const Color seedBlue = Color(0xff428eff);

  /// seedRed
  static const Color seedRed = Color(0xffff5145);

  /// seedYellow
  static const Color seedYellow = Color(0xffffbb00);

  /// seedGreen
  static const Color seedGreen = Color(0xff38a852);

  /// seedBrown
  static const Color seedBrown = Color(0xff94513d);

  /// seedBlack
  static const Color seedBlack = Color(0xff202124);

  /// seedWhite
  static const Color seedWhite = Color(0xffffffff);

  /// accessibleBlack
  static const Color accessibleBlack = Color(0xff202124);

  /// accessibleGrey
  static const Color accessibleGrey = Color(0xff5f6368);

  /// accessibleBrandLightBlue
  static const Color accessibleBrandLightBlue = Color(0xff076f9f);

  /// accessibleBrandBlue
  static const Color accessibleBrandBlue = Color(0xff0056d6);

  /// accessibleBrandRed
  static const Color accessibleBrandRed = Color(0xffda0f00);

  /// accessibleBrandYellow
  static const Color accessibleBrandYellow = Color(0xff8c6700);

  /// accessibleBrandGreen
  static const Color accessibleBrandGreen = Color(0xff236a34);

  /// mediumGray
  static const Color mediumGray = Color(0xff393B40);

  /// darkGray
  static const Color darkGray = Color(0xff212123);

  /// color for the links
  static const linkBlue = Color(0xFF1A73E8);

  /// light blue gradient
  static const lightGradientBlue = Color(0xFFB1CEFF);

  /// light blue gradient
  static const darkGradientBlue = Color(0xFF337BFA);

  /// googleBlue
  static const googleBlue = Color(0xFF3D96FF);

  /// flutterBlue
  static const flutterBlue = Color(0xFF5CA7FF);

  /// androidGreen
  static const androidGreen = Color(0xFF6AC76E);

  /// sparkyYellow
  static const sparkyYellow = Color(0xFFFECD3C);

  /// chromeRed
  static const chromeRed = Color(0xFFFF6F5C);

  /// black
  static const black = Color(0xFF010101);

  /// soft gray
  static const softGray = Color(0xFF80858B);

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
      IoCrosswordColors.androidGreen,
      IoCrosswordColors.sparkyYellow,
      IoCrosswordColors.redError,
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
