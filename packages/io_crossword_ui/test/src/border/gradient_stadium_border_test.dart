// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../helpers/helpers.dart';

void main() {
  group('$GradientStadiumBorder', () {
    group('renders as expected', () {
      Uri goldenKey(String name) =>
          Uri.parse('goldens/gradient_outlined_border_$name.png');

      testWidgets(
        'OutlinedButton',
        (tester) async {
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
