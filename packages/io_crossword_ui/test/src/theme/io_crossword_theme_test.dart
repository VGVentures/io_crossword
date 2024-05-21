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
            IoCrosswordTheme().themeData.outlinedButtonTheme.style!.shape!;

        test('displays StadiumBorder with ${WidgetState.disabled}', () {
          expect(
            outlinedBorder.resolve({WidgetState.disabled}),
            equals(isA<StadiumBorder>()),
          );
        });

        test('displays GradientOutlinedBorder when there are no states', () {
          expect(
            outlinedBorder.resolve({}),
            equals(
              isA<GradientStadiumBorder>().having(
                (border) => border.gradient,
                'Google gradient',
                IoCrosswordColors.googleGradient,
              ),
            ),
          );
        });

        for (final state in WidgetState.values.toList()
          ..remove(WidgetState.disabled)) {
          test('displays GradientOutlinedBorder with $state', () {
            expect(
              outlinedBorder.resolve({state}),
              equals(
                isA<GradientStadiumBorder>().having(
                  (border) => border.gradient,
                  'Google gradient',
                  IoCrosswordColors.googleGradient,
                ),
              ),
            );
          });
        }
      });

      group('IoOutlineButtonTheme', () {
        final outlinedBorder = IoCrosswordTheme()
            .themeData
            .io
            .outlineButtonTheme
            .simpleBorder
            .shape!;

        test('displays StadiumBorder with ${WidgetState.disabled}', () {
          expect(
            outlinedBorder.resolve({WidgetState.disabled}),
            equals(isA<StadiumBorder>()),
          );
        });

        test('displays mediumGray color when there are no states', () {
          expect(
            outlinedBorder.resolve({}),
            equals(
              isA<StadiumBorder>().having(
                (border) => border.side.color,
                'Medium gray gradient',
                IoCrosswordColors.mediumGray,
              ),
            ),
          );
        });

        for (final state in WidgetState.values.toList()
          ..remove(WidgetState.disabled)) {
          test('displays mediumGray color with $state', () {
            expect(
              outlinedBorder.resolve({state}),
              equals(
                isA<StadiumBorder>().having(
                  (border) => border.side.color,
                  'Medium gray gradient',
                  IoCrosswordColors.mediumGray,
                ),
              ),
            );
          });
        }
      });

      group('geminiOutlinedButtonThemeData', () {
        final outlinedBorder =
            IoCrosswordTheme.geminiOutlinedButtonThemeData.style!.shape!;

        test('displays StadiumBorder with ${WidgetState.disabled}', () {
          expect(
            outlinedBorder.resolve({WidgetState.disabled}),
            equals(isA<StadiumBorder>()),
          );
        });

        test('displays GradientOutlinedBorder when there are no states', () {
          expect(
            outlinedBorder.resolve({}),
            equals(
              isA<GradientStadiumBorder>().having(
                (border) => border.gradient,
                'Gemini gradient',
                IoCrosswordColors.geminiGradient,
              ),
            ),
          );
        });

        for (final state in WidgetState.values.toList()
          ..remove(WidgetState.disabled)) {
          test('displays GradientOutlinedBorder with $state', () {
            expect(
              outlinedBorder.resolve({state}),
              equals(
                isA<GradientStadiumBorder>().having(
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
          IoCrosswordTheme().themeData.colorScheme.surface,
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
            addTearDown(() => tester.binding.setSurfaceSize(null));

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
            addTearDown(() => tester.binding.setSurfaceSize(null));

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

    group('iconButton', () {
      group('iconColor', () {
        test('is mediumGray when ${WidgetState.disabled}', () {
          final iconButtonTheme = IoCrosswordTheme().themeData.iconButtonTheme;
          final property = iconButtonTheme.style!.iconColor!;

          expect(
            property.resolve({WidgetState.disabled}),
            IoCrosswordColors.mediumGray,
          );
        });

        for (final state in WidgetState.values.toSet()
          ..remove(WidgetState.disabled)) {
          test('is seedWhite when $state', () {
            final iconButtonTheme =
                IoCrosswordTheme().themeData.iconButtonTheme;
            final property = iconButtonTheme.style!.iconColor!;

            expect(property.resolve({state}), IoCrosswordColors.seedWhite);
          });
        }
      });
    });
  });
}
