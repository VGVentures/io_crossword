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
          Uri.parse('goldens/io_crossword__card_$name.png');

      testWidgets(
        'when portrait mobile',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(390, 844));

          await tester.pumpWidget(
            const ColoredBox(
              color: Color(0xFF020F30),
              child: IoCrosswordCard(),
            ),
          );

          await expectLater(
            find.byType(IoCrosswordCard),
            matchesGoldenFile(goldenKey('mobile_portrait')),
          );
        },
      );

      testWidgets(
        'when landscape mobile',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(844, 390));

          await tester.pumpWidget(
            const ColoredBox(
              color: Color(0xFF020F30),
              child: IoCrosswordCard(),
            ),
          );

          await expectLater(
            find.byType(IoCrosswordCard),
            matchesGoldenFile(goldenKey('mobile_landscape')),
          );
        },
      );

      testWidgets(
        'when desktop',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(1440, 800));

          await tester.pumpWidget(
            const ColoredBox(
              color: Color(0xFF020F30),
              child: IoCrosswordCard(),
            ),
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
