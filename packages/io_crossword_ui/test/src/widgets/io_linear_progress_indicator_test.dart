// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../test_tag.dart';
import '../helpers/helpers.dart';

void main() {
  group('$IoLinearProgressIndicator', () {
    testWidgets(
        'renders AnimatedFractionallySizedBox with correct width factor',
        (tester) async {
      await tester.pumpApp(IoLinearProgressIndicator(value: 0.5));

      expect(find.byType(AnimatedFractionallySizedBox), findsOneWidget);

      expect(
        tester
            .widget<AnimatedFractionallySizedBox>(
              find.byType(AnimatedFractionallySizedBox),
            )
            .widthFactor,
        equals(0.5),
      );
    });

    group('renders as expected', () {
      Uri goldenKey(String name) => Uri.parse(
            'goldens/io_linear_progress_indicator/io_indicator_$name.png',
          );

      testWidgets(
        'with half progress',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(500, 50));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await tester.pumpApp(
            _GoldenSubject(
              child: IoLinearProgressIndicator(
                value: 0.5,
              ),
            ),
          );

          await expectLater(
            find.byType(IoLinearProgressIndicator),
            matchesGoldenFile(goldenKey('half')),
          );
        },
      );

      testWidgets(
        'with no progress',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(500, 50));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await tester.pumpApp(
            _GoldenSubject(
              child: IoLinearProgressIndicator(
                value: 0,
              ),
            ),
          );

          await expectLater(
            find.byType(IoLinearProgressIndicator),
            matchesGoldenFile(goldenKey('none')),
          );
        },
      );

      testWidgets(
        'with complete progress',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(500, 50));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await tester.pumpApp(
            _GoldenSubject(
              child: IoLinearProgressIndicator(
                value: 1,
              ),
            ),
          );

          await expectLater(
            find.byType(IoLinearProgressIndicator),
            matchesGoldenFile(goldenKey('complete')),
          );
        },
      );
    });
  });
}

class _GoldenSubject extends StatelessWidget {
  const _GoldenSubject({required this.child});

  final IoLinearProgressIndicator child;

  @override
  Widget build(BuildContext context) {
    final themeData = IoCrosswordTheme().themeData;
    return Theme(
      data: themeData,
      child: ColoredBox(
        color: themeData.colorScheme.surface,
        child: Center(child: child),
      ),
    );
  }
}
