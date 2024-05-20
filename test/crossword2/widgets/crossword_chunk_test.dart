import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixtures/fixtures.dart';
import '../../helpers/helpers.dart';
import '../../test_tag.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _GoldenFileComparator extends LocalFileComparator {
  _GoldenFileComparator()
      : super(
          Uri.parse('test/crossword2/widgets/crossword_chunk_test.dart'),
        );

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    // Sufficient toleration to accommodate for host-specific rendering
    // differences.
    final passed = result.diffPercent <= 0.15;
    if (passed) {
      result.dispose();
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

void main() {
  group('$CrosswordChunk', () {
    late CrosswordLayoutData layoutData;

    setUp(() {
      layoutData = CrosswordLayoutData.fromConfiguration(
        configuration: const CrosswordConfiguration(
          bottomRight: (40, 40),
          chunkSize: 20,
        ),
        cellSize: const Size.square(20),
      );
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpApp(
        CrosswordLayoutScope(
          data: layoutData,
          child: const CrosswordChunk(
            index: (0, 0),
            chunkSize: 20,
          ),
        ),
      );
    });

    group('renders', () {
      late CrosswordBloc crosswordBloc;
      late BoardSection chunk;

      Uri goldenKey(String name) =>
          Uri.parse('goldens/crossword_chunk/$name.png');

      setUp(() {
        crosswordBloc = _MockCrosswordBloc();
        chunk = chunkFixture1;

        final previousComparator = goldenFileComparator;
        goldenFileComparator = _GoldenFileComparator();
        addTearDown(() => goldenFileComparator = previousComparator);
      });

      testWidgets(
        'letters as defined in the chunk',
        tags: TestTag.golden,
        (tester) async {
          final state = CrosswordState(sections: {(0, 0): chunk});
          when(() => crosswordBloc.state).thenReturn(state);

          await tester.pumpApp(
            crosswordBloc: crosswordBloc,
            CrosswordLayoutScope(
              data: layoutData,
              child: const CrosswordChunk(
                debug: false,
                index: (0, 0),
                chunkSize: 20,
              ),
            ),
          );

          expect(find.byType(CrosswordLetter), findsNWidgets(15));
          await expectLater(
            find.byType(CrosswordChunk),
            matchesGoldenFile(goldenKey('chunk_fixture1')),
          );
        },
      );
    });

    group('debug', () {
      testWidgets('shows debug information when enabled', (tester) async {
        await tester.pumpApp(
          CrosswordLayoutScope(
            data: layoutData,
            child: const CrosswordChunk(
              index: (0, 0), chunkSize: 20,
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
              child: const CrosswordChunk(
                index: (0, 0),
                chunkSize: 20,
                debug: false,
              ),
            ),
          );

          expect(find.text('(0, 0)'), findsNothing);
          expect(find.byKey(CrosswordChunk.debugBorderKey), findsNothing);
        },
      );
    });
  });
}
