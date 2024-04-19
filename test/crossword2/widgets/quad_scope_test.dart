import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword2/crossword2.dart';
import 'package:mocktail/mocktail.dart';

class _MockQuad extends Mock implements Quad {}

void main() {
  group('$QuadScope', () {
    late Quad quad;

    setUp(() {
      quad = _MockQuad();
    });

    testWidgets('pumps successfully', (tester) async {
      await tester.pumpWidget(
        QuadScope(
          data: quad,
          child: const SizedBox(),
        ),
      );

      expect(find.byType(QuadScope), findsOneWidget);
    });

    group('of', () {
      testWidgets('throws an exception if no $QuadScope is found',
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
          () => QuadScope.of(buildContext),
          throwsA(
            isA<AssertionError>().having(
              (e) => e.message,
              'message',
              'No $QuadScope found in context',
            ),
          ),
        );
      });

      testWidgets(
        'retrieves the $Quad from the nearest ancestor $QuadScope',
        (tester) async {
          late BuildContext buildContext;

          final childQuad = _MockQuad();
          await tester.pumpWidget(
            QuadScope(
              data: quad,
              child: QuadScope(
                data: childQuad,
                child: Builder(
                  builder: (context) {
                    buildContext = context;
                    return const SizedBox();
                  },
                ),
              ),
            ),
          );

          final result = QuadScope.of(buildContext);
          expect(result, childQuad);
        },
      );
    });

    group('updateShouldNotify', () {
      test('returns true if the data is different', () {
        final oldWidget = QuadScope(data: _MockQuad(), child: const SizedBox());
        final newWidget = QuadScope(data: _MockQuad(), child: const SizedBox());

        expect(newWidget.updateShouldNotify(oldWidget), isTrue);
      });

      test('returns false if the data is the same', () {
        final oldWidget = QuadScope(data: quad, child: const SizedBox());
        final newWidget = QuadScope(data: quad, child: const SizedBox());

        expect(newWidget.updateShouldNotify(oldWidget), isFalse);
      });
    });
  });
}
