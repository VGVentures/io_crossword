import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword2/widgets/default_transformation_controller.dart';
import 'package:mocktail/mocktail.dart';

class _MockTransformationController extends Mock
    implements TransformationController {}

void main() {
  group('$DefaultTransformationController', () {
    group('of', () {
      testWidgets(
        '''throws an AssertionError if no DefaultTransformationController is found in context''',
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
            () => DefaultTransformationController.of(buildContext),
            throwsA(
              isA<AssertionError>().having(
                (e) => e.message,
                'message',
                'No $DefaultTransformationController found in context',
              ),
            ),
          );
        },
      );

      testWidgets(
        '''retrieves the $TransformationController from the nearest ancestor $DefaultTransformationController''',
        (tester) async {
          late BuildContext buildContext;

          await tester.pumpWidget(
            DefaultTransformationController(
              child: Builder(
                builder: (context) {
                  buildContext = context;
                  return const SizedBox();
                },
              ),
            ),
          );

          final result = DefaultTransformationController.of(buildContext);
          expect(result, isA<TransformationController>());
        },
      );
    });
  });

  group('$TransformationControllerScope', () {
    group('updateShouldNotify', () {
      test('is false when controller is the same', () {
        final scope = TransformationControllerScope(
          transformationController: _MockTransformationController(),
          child: const SizedBox(),
        );
        final newScope = TransformationControllerScope(
          transformationController: scope.transformationController,
          child: const SizedBox(),
        );

        expect(scope.updateShouldNotify(newScope), isFalse);
      });

      test('is true when controller is not the same', () {
        final scope = TransformationControllerScope(
          transformationController: _MockTransformationController(),
          child: const SizedBox(),
        );
        final newScope = TransformationControllerScope(
          transformationController: _MockTransformationController(),
          child: const SizedBox(),
        );

        expect(scope.updateShouldNotify(newScope), isTrue);
      });
    });
  });
}
