import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/src/widgets/io_layout.dart';

// TODO(alestiago): Test when layout changes and so on.
void main() {
  group('$IoLayout', () {
    testWidgets('renders successfully', (tester) async {
      await tester.pumpWidget(const IoLayout(child: SizedBox()));
    });

    group('of', () {
      testWidgets(
        'throws an $AssertionError if no $IoLayout is found in context',
        (tester) async {
          late final BuildContext buildContext;

          await tester.pumpWidget(
            Builder(
              builder: (context) {
                buildContext = context;
                return const SizedBox();
              },
            ),
          );

          expect(
            () => IoLayout.of(buildContext),
            throwsAssertionError,
          );
        },
      );

      testWidgets('returns the closest $IoLayoutData', (tester) async {
        const data = IoLayoutData.small;

        late final BuildContext buildContext;
        await tester.pumpWidget(
          IoLayout(
            data: data,
            child: Builder(
              builder: (context) {
                buildContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        expect(IoLayout.of(buildContext), equals(data));
      });
    });
  });
}
