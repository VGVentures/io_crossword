// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../test_tag.dart';

void main() {
  group('$IoCrosswordCard', () {
    testWidgets('renders successfully', (tester) async {
      await tester.pumpWidget(const IoCrosswordCard(child: FlutterLogo()));
      expect(find.byType(IoCrosswordCard), findsOneWidget);
    });

    testWidgets('renders its child', (tester) async {
      const child = FlutterLogo();
      await tester.pumpWidget(const IoCrosswordCard(child: child));
      expect(find.byWidget(child), findsOneWidget);
    });

    group('renders as expected', () {
      Uri goldenKey(String name) =>
          Uri.parse('goldens/io_crossword_card__$name.png');

      testWidgets(
        'when portrait mobile',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(390, 844));

          await tester.pumpWidget(
            _GoldenSubject(child: IoCrosswordCard()),
          );

          await expectLater(
            find.byType(IoCrosswordCard),
            matchesGoldenFile(goldenKey('mobile_portrait')),
          );
        },
      );

      testWidgets(
        'when desktop',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1440, 800));

          await tester.pumpWidget(
            _GoldenSubject(child: IoCrosswordCard()),
          );

          await expectLater(
            find.byType(IoCrosswordCard),
            matchesGoldenFile(goldenKey('desktop')),
          );
        },
      );
    });
  });
}

class _GoldenSubject extends StatelessWidget {
  const _GoldenSubject({required this.child});

  final IoCrosswordCard child;

  @override
  Widget build(BuildContext context) {
    final themeData = IoCrosswordTheme.themeData;
    return Theme(
      data: IoCrosswordTheme.themeData,
      child: ColoredBox(
        color: themeData.colorScheme.background,
        child: Center(child: child),
      ),
    );
  }
}
