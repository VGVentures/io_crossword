import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword2/crossword2.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$CrosswordChunk', () {
    late CrosswordLayoutData layoutData;

    setUp(() {
      layoutData = CrosswordLayoutData.fromConfiguration(
        configuration: const CrosswordConfiguration(
          bottomLeft: (40, 40),
          chunkSize: 20,
        ),
        cellSize: const Size.square(20),
      );
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpApp(
        CrosswordLayoutScope(
          data: layoutData,
          child: const CrosswordChunk(index: (0, 0)),
        ),
      );
    });

    group('debug', () {
      testWidgets('shows debug information when enabled', (tester) async {
        await tester.pumpApp(
          CrosswordLayoutScope(
            data: layoutData,
            child: const CrosswordChunk(
              index: (0, 0),
              // ignore: avoid_redundant_argument_values
              debug: true,
            ),
          ),
        );

        expect(
          find.text('(0, 0)'),
          findsOneWidget,
          reason: 'The chunk should display its index.',
        );

        final borderFinder = find.byKey(CrosswordChunk.debugBorderKey);
        expect(borderFinder, findsOneWidget);

        final decoratedBox = tester.widget<DecoratedBox>(borderFinder);
        expect(
          decoratedBox.decoration,
          BoxDecoration(border: Border.all(color: Colors.red)),
          reason: 'The chunk should have a red border.',
        );
      });

      testWidgets(
        'does not show debug information when disabled',
        (tester) async {
          await tester.pumpApp(
            CrosswordLayoutScope(
              data: layoutData,
              child: const CrosswordChunk(index: (0, 0), debug: false),
            ),
          );

          expect(find.text('(0, 0)'), findsNothing);
          expect(find.byKey(CrosswordChunk.debugBorderKey), findsNothing);
        },
      );
    });
  });
}
