import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

void main() {
  group('$IoChromeTheme', () {
    test('themeData returns normally', () {
      expect(() => IoChromeTheme().themeData, returnsNormally);
    });

    group('OutlinedButtonThemeData', () {
      final outlinedBorder =
          IoChromeTheme().themeData.outlinedButtonTheme.style!.shape!;

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
              'Dino gradient',
              IoCrosswordColors.dinoGradient,
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
                'Dino gradient',
                IoCrosswordColors.dinoGradient,
              ),
            ),
          );
        });
      }
    });
  });
}
