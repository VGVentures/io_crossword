// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:io_crossword/crossword2/widgets/crossword_layout.dart';
import 'package:mocktail/mocktail.dart';

class _MockCrosswordLayoutData extends Mock implements CrosswordLayoutData {}

void main() {
  group('$CrosswordLayoutData', () {
    test('supports value equality', () {
      final data1 = CrosswordLayoutData(
        cellSize: const Size(1, 1),
        chunkSize: const Size(2, 2),
        crosswordSize: const Size(3, 3),
      );
      final data2 = CrosswordLayoutData(
        cellSize: const Size(1, 1),
        chunkSize: const Size(2, 2),
        crosswordSize: const Size(3, 3),
      );
      final data3 = CrosswordLayoutData(
        cellSize: const Size(3, 3),
        chunkSize: const Size(2, 2),
        crosswordSize: const Size(1, 1),
      );

      expect(data1, equals(data2));
      expect(data1, isNot(equals(data3)));
      expect(data2, isNot(equals(data3)));
    });

    test('fromConfiguration derives as expected', () {
      final configuration = CrosswordConfiguration(
        bottomLeft: (2, 2),
        chunkSize: 10,
      );
      const cellSize = Size(10, 10);

      final layoutData = CrosswordLayoutData.fromConfiguration(
        configuration: configuration,
        cellSize: cellSize,
      );

      expect(
        layoutData,
        equals(
          CrosswordLayoutData(
            cellSize: cellSize,
            chunkSize: const Size(100, 100),
            crosswordSize: const Size(300, 300),
          ),
        ),
      );
    });
  });

  group('$CrosswordLayoutScope', () {
    late CrosswordLayoutData data;

    setUp(() {
      data = _MockCrosswordLayoutData();
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpWidget(
        CrosswordLayoutScope(
          data: data,
          child: const SizedBox(),
        ),
      );

      expect(find.byType(CrosswordLayoutScope), findsOneWidget);
    });

    group('of', () {
      testWidgets('throws an exception if no $CrosswordLayoutScope is found',
          (tester) async {
        late BuildContext buildContext;
        await tester.pumpWidget(
          Builder(
            builder: (context) {
              buildContext = context;
              return const SizedBox();
            },
          ),
        );

        expect(
          () => CrosswordLayoutScope.of(buildContext),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'No $CrosswordLayoutScope found in context',
            ),
          ),
        );
      });

      testWidgets(
        '''retrieves the $CrosswordLayoutData from the nearest ancestor $CrosswordLayoutScope''',
        (tester) async {
          late BuildContext buildContext;

          final childData = _MockCrosswordLayoutData();
          await tester.pumpWidget(
            CrosswordLayoutScope(
              data: data,
              child: CrosswordLayoutScope(
                data: childData,
                child: Builder(
                  builder: (context) {
                    buildContext = context;
                    return const SizedBox();
                  },
                ),
              ),
            ),
          );

          final result = CrosswordLayoutScope.of(buildContext);
          expect(result, childData);
        },
      );
    });

    group('updateShouldNotify', () {
      test('returns true if the data is different', () {
        final oldWidget = CrosswordLayoutScope(
          data: _MockCrosswordLayoutData(),
          child: const SizedBox(),
        );
        final newWidget = CrosswordLayoutScope(
          data: _MockCrosswordLayoutData(),
          child: const SizedBox(),
        );

        expect(newWidget.updateShouldNotify(oldWidget), isTrue);
      });

      test('returns false if the data is the same', () {
        final oldWidget =
            CrosswordLayoutScope(data: data, child: const SizedBox());
        final newWidget =
            CrosswordLayoutScope(data: data, child: const SizedBox());

        expect(newWidget.updateShouldNotify(oldWidget), isFalse);
      });
    });
  });
}
