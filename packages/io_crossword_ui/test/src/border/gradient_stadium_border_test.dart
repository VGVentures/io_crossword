// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../test_tag.dart';
import '../helpers/helpers.dart';

void main() {
  group('$GradientStadiumBorder', () {
    group('renders as expected', () {
      Uri goldenKey(String name) =>
          Uri.parse('goldens/gradient_outlined_border_$name.png');

      testWidgets(
        'OutlinedButton',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size.square(200));

          await tester.pumpApp(
            _GoldenSubject(
              child: OutlinedButton(
                onPressed: () {},
                child: SizedBox(),
              ),
            ),
          );

          await expectLater(
            find.byType(OutlinedButton),
            matchesGoldenFile(goldenKey('button')),
          );
        },
      );
    });

    group('copyWith', () {
      test('updates side', () {
        const gradient = LinearGradient(
          colors: [Color(0xFF00FF00), Color(0xFF00FF00)],
        );

        final gradientBorder = GradientStadiumBorder(
          gradient: gradient,
        ).copyWith(side: BorderSide(width: 4));

        expect(gradientBorder.side.width, equals(4));
        expect(gradientBorder.gradient, equals(gradient));
      });

      test('updates gradient', () {
        const gradient = LinearGradient(
          colors: [Color(0xFF00FF00), Color(0xFF00FF00)],
        );

        final gradientBorder = GradientStadiumBorder(
          gradient: const LinearGradient(colors: []),
          side: BorderSide(width: 4),
        ).copyWith(gradient: gradient);

        expect(gradientBorder.side.width, equals(4));
        expect(gradientBorder.gradient, equals(gradient));
      });
    });

    group('lerpFrom', () {
      test('two GradientStadiumBorder', () {
        final from = GradientStadiumBorder(
          side: BorderSide(),
          gradient: const LinearGradient(
            colors: [Color(0xFF00FF00), Color(0xFF00FF00)],
          ),
        );
        final to = GradientStadiumBorder(
          side: BorderSide(width: 2),
          gradient: const LinearGradient(
            colors: [Color(0xFF0000FF), Color(0xFF0000FF)],
          ),
        );

        final lerp = from.lerpFrom(to, 0.5)! as GradientStadiumBorder;

        expect(lerp.side.width, 1.5);

        expect(lerp.side, isNot(from.side));
        expect(lerp.side, isNot(to.side));

        expect(lerp.gradient, isNot(from.gradient));
        expect(lerp.gradient, isNot(to.gradient));
        expect(lerp.gradient.colors.first, const Color(0xff007f00));
      });

      test('one GradientStadiumBorder and StadiumBorder', () {
        final from = GradientStadiumBorder(
          side: BorderSide(),
          gradient: const LinearGradient(
            colors: [Color(0xFF00FF00), Color(0xFF00FF00)],
          ),
        );
        final to = StadiumBorder(
          side: BorderSide(width: 2),
        );

        final lerp = from.lerpFrom(to, 0.5)! as StadiumBorder;

        expect(lerp.side.width, 1.5);

        expect(lerp.side, isNot(from.side));
        expect(lerp.side, isNot(to.side));
      });
    });
  });
}

class _GoldenSubject extends StatelessWidget {
  const _GoldenSubject({required this.child});

  final OutlinedButton child;

  @override
  Widget build(BuildContext context) {
    final themeData = IoCrosswordTheme().themeData;

    return Theme(
      data: themeData,
      child: Material(
        child: ColoredBox(
          color: themeData.colorScheme.background,
          child: Center(child: child),
        ),
      ),
    );
  }
}
