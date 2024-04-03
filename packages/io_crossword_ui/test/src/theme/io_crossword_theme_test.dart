import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_tag.dart';

class _MockBuildContext extends Mock implements BuildContext {}

void main() {
  group('$IoCrosswordTheme', () {
    group('themeData', () {
      test('uses material 3', () {
        expect(IoCrosswordTheme().themeData.useMaterial3, isTrue);
      });

      group('OutlinedButtonThemeData', () {
        final outlinedBorder =
            IoCrosswordTheme().outlinedButtonThemeData.style!.shape!;

        test('displays StadiumBorder with ${MaterialState.disabled}', () {
          expect(
            outlinedBorder.resolve({MaterialState.disabled}),
            equals(isA<StadiumBorder>()),
          );
        });

        test('displays GradientOutlinedBorder when there are no states', () {
          expect(
            outlinedBorder.resolve({}),
            equals(
              isA<GradientOutlinedBorder>().having(
                (border) => border.gradient,
                'Google gradient',
                IoCrosswordColors.googleGradient,
              ),
            ),
          );
        });

        for (final state in MaterialState.values.toList()
          ..remove(MaterialState.disabled)) {
          test('displays GradientOutlinedBorder with $state', () {
            expect(
              outlinedBorder.resolve({state}),
              equals(
                isA<GradientOutlinedBorder>().having(
                  (border) => border.gradient,
                  'Google gradient',
                  IoCrosswordColors.googleGradient,
                ),
              ),
            );
          });
        }
      });

      group('geminiOutlinedButtonThemeData', () {
        final outlinedBorder =
            IoCrosswordTheme.geminiOutlinedButtonThemeData.style!.shape!;

        test('displays StadiumBorder with ${MaterialState.disabled}', () {
          expect(
            outlinedBorder.resolve({MaterialState.disabled}),
            equals(isA<StadiumBorder>()),
          );
        });

        test('displays GradientOutlinedBorder when there are no states', () {
          expect(
            outlinedBorder.resolve({}),
            equals(
              isA<GradientOutlinedBorder>().having(
                (border) => border.gradient,
                'Gemini gradient',
                IoCrosswordColors.geminiGradient,
              ),
            ),
          );
        });

        for (final state in MaterialState.values.toList()
          ..remove(MaterialState.disabled)) {
          test('displays GradientOutlinedBorder with $state', () {
            expect(
              outlinedBorder.resolve({state}),
              equals(
                isA<GradientOutlinedBorder>().having(
                  (border) => border.gradient,
                  'Gemini gradient',
                  IoCrosswordColors.geminiGradient,
                ),
              ),
            );
          });
        }
      });

      group('ActionIconThemeData', () {
        final actionIconTheme = IoCrosswordTheme().themeData.actionIconTheme!;

        test('displays close icon when using closeButtonIconBuilder', () {
          final context = _MockBuildContext();

          expect(
            actionIconTheme.closeButtonIconBuilder!(context),
            equals(
              isA<Icon>().having((widget) => widget.icon, 'icon', Icons.close),
            ),
          );
        });
      });

      test('background color is IoCrosswordColors.seedBlack', () {
        expect(
          IoCrosswordTheme().themeData.colorScheme.background,
          IoCrosswordColors.seedBlack,
        );
      });

      test('uses mobile text theme on android', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.android;
        expect(
          IoCrosswordTheme().themeData.textTheme.displayLarge?.fontSize,
          equals(IoCrosswordTextStyles.mobile.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses mobile text theme on ios', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
        expect(
          IoCrosswordTheme().themeData.textTheme.displayLarge?.fontSize,
          equals(IoCrosswordTextStyles.mobile.textTheme.displayLarge?.fontSize),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on macOS', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
        expect(
          IoCrosswordTheme().themeData.textTheme.displayLarge?.fontSize,
          equals(
            IoCrosswordTextStyles.desktop.textTheme.displayLarge?.fontSize,
          ),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on windows', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        expect(
          IoCrosswordTheme().themeData.textTheme.displayLarge?.fontSize,
          equals(
            IoCrosswordTextStyles.desktop.textTheme.displayLarge?.fontSize,
          ),
        );
        debugDefaultTargetPlatformOverride = null;
      });

      test('uses desktop text theme on linux', () {
        debugDefaultTargetPlatformOverride = TargetPlatform.linux;
        expect(
          IoCrosswordTheme().themeData.textTheme.displayLarge?.fontSize,
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

    group('IoCardTheme', () {
      group('styles', () {
        Uri goldenKey(String name) => Uri.parse('goldens/card/card__$name.png');

        testWidgets(
          'plain by default',
          tags: TestTag.golden,
          (tester) async {
            await tester.binding.setSurfaceSize(const Size.square(200));

            await tester.pumpWidget(
              MaterialApp(
                theme: IoCrosswordTheme().themeData,
                home: const Center(
                  child: Card(
                    child: SizedBox.square(dimension: 150),
                  ),
                ),
              ),
            );

            await expectLater(
              find.byType(Card),
              matchesGoldenFile(goldenKey('plain')),
            );
          },
        );

        testWidgets(
          'highlight when specified',
          tags: TestTag.golden,
          (tester) async {
            await tester.binding.setSurfaceSize(const Size.square(200));

            final themeData = IoCrosswordTheme().themeData;
            final cardTheme = themeData.io.cardTheme.highlight;

            await tester.pumpWidget(
              MaterialApp(
                theme: themeData.copyWith(cardTheme: cardTheme),
                home: const Center(
                  child: Card(
                    child: SizedBox.square(dimension: 150),
                  ),
                ),
              ),
            );

            await expectLater(
              find.byType(Card),
              matchesGoldenFile(goldenKey('highlight')),
            );
          },
        );
      });
    });
  });
}
