import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/src/theme/theme.dart';

void main() {
  group('IoCrosswordTheme', () {
    group('themeData', () {
      test('uses material 3', () {
        expect(IoCrosswordTheme.themeData.useMaterial3, isTrue);
      });

      test('background color is IoCrosswordColors.seedBlack', () {
        expect(
          IoCrosswordTheme.themeData.colorScheme.background,
          IoCrosswordColors.seedBlack,
        );
      });

      test('uses mobile text theme on android', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        expect(
          IoCrosswordTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(IoCrosswordTextStyles.mobile.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses mobile text theme on ios', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        expect(
          IoCrosswordTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(IoCrosswordTextStyles.mobile.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on macOS', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        expect(
          IoCrosswordTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(
            IoCrosswordTextStyles.desktop.textTheme.displayLarge?.fontSize,
          ),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on windows', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        expect(
          IoCrosswordTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(
            IoCrosswordTextStyles.desktop.textTheme.displayLarge?.fontSize,
          ),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on linux', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;
        expect(
          IoCrosswordTheme.themeData.textTheme.displayLarge?.fontSize,
          equals(
            IoCrosswordTextStyles.desktop.textTheme.displayLarge?.fontSize,
          ),
        );
        debugDefaultTargetPlatformOverride = null;
      });
    });
  });
}
