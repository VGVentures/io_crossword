import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
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

    group('geminiInputDecorationTheme', () {
      late InputDecorationTheme geminiInput;

      setUp(() {
        geminiInput = IoCrosswordTheme.geminiInputDecorationTheme;
      });

      test('displays GradientInputBorder on border', () {
        expect(
          geminiInput.border,
          equals(
            isA<GradientInputBorder>().having(
              (decoration) => decoration.gradient,
              'gradient',
              IoCrosswordColors.geminiGradient,
            ),
          ),
        );
      });

      test('displays GradientInputBorder on enabledBorder', () {
        expect(
          geminiInput.enabledBorder,
          equals(
            isA<GradientInputBorder>().having(
              (decoration) => decoration.gradient,
              'gradient',
              IoCrosswordColors.geminiGradient,
            ),
          ),
        );
      });

      test('displays GradientInputBorder on focusedBorder', () {
        expect(
          geminiInput.focusedBorder,
          equals(
            isA<GradientInputBorder>().having(
              (decoration) => decoration.gradient,
              'gradient',
              IoCrosswordColors.geminiGradient,
            ),
          ),
        );
      });

      test('displays OutlineInputBorder on disabledBorder', () {
        expect(
          geminiInput.disabledBorder,
          equals(
            isA<OutlineInputBorder>(),
          ),
        );
      });

      test('displays OutlineInputBorder on errorBorder', () {
        expect(
          geminiInput.errorBorder,
          equals(
            isA<OutlineInputBorder>(),
          ),
        );
      });

      test('displays OutlineInputBorder on focusedErrorBorder', () {
        expect(
          geminiInput.errorBorder,
          equals(
            isA<OutlineInputBorder>(),
          ),
        );
      });
    });
  });
}
