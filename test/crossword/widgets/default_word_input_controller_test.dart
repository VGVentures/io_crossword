import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

class _MockIoWordInputController extends Mock
    implements IoWordInputController {}

void main() {
  group('$DefaultWordInputController', () {
    group('of', () {
      testWidgets(
        '''throws an AssertionError if no DefaultWordInputController is found in context''',
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
            () => DefaultWordInputController.of(buildContext),
            throwsA(
              isA<AssertionError>().having(
                (e) => e.message,
                'message',
                'No $DefaultWordInputController found in context',
              ),
            ),
          );
        },
      );

      testWidgets(
        '''retrieves the $IoWordInputController from the nearest ancestor $DefaultWordInputController''',
        (tester) async {
          late BuildContext buildContext;

          await tester.pumpWidget(
            DefaultWordInputController(
              child: Builder(
                builder: (context) {
                  buildContext = context;
                  return const SizedBox();
                },
              ),
            ),
          );

          final result = DefaultWordInputController.of(buildContext);
          expect(result, isA<IoWordInputController>());
        },
      );
    });
  });

  group('$IoWordInputControllerScope', () {
    group('updateShouldNotify', () {
      test('is false when controller is the same', () {
        final scope = IoWordInputControllerScope(
          wordInputController: _MockIoWordInputController(),
          child: const SizedBox(),
        );
        final newScope = IoWordInputControllerScope(
          wordInputController: scope.wordInputController,
          child: const SizedBox(),
        );

        expect(scope.updateShouldNotify(newScope), isFalse);
      });

      test('is true when controller is not the same', () {
        final scope = IoWordInputControllerScope(
          wordInputController: _MockIoWordInputController(),
          child: const SizedBox(),
        );
        final newScope = IoWordInputControllerScope(
          wordInputController: _MockIoWordInputController(),
          child: const SizedBox(),
        );

        expect(scope.updateShouldNotify(newScope), isTrue);
      });
    });
  });
}
