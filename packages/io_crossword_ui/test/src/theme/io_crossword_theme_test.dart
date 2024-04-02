import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/src/theme/theme.dart';
import 'package:mocktail/mocktail.dart';

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('IoCrosswordTheme', () {
    group('themeData', () {
      test('uses material 3', () {
        expect(IoCrosswordTheme.themeData.useMaterial3, isTrue);
      });

      group('ActionIconThemeData', () {
        final actionIconTheme = IoCrosswordTheme.themeData.actionIconTheme!;

        test('displays close icon when using closeButtonIconBuilder', () {
          final context = _MockBuildContext();

          expect(
            actionIconTheme.closeButtonIconBuilder!(context),
            equals(
              isA<Container>().having(
                (widget) => (widget.child! as Icon).icon,
                'Close icon',
                Icons.close,
              ),
            ),
          );
        });
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
