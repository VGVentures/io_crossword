import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword2/crossword2.dart';

void main() {
  group('$CrosswordInteractiveViewer', () {
    testWidgets('pumps successfully', (tester) async {
      await tester.pumpWidget(
        CrosswordInteractiveViewer(
          builder: (context, position) {
            return const SizedBox();
          },
        ),
      );

      expect(find.byType(CrosswordInteractiveViewer), findsOneWidget);
    });

    testWidgets(
      "pumps a $QuadScope with the viewer's viewport",
      (tester) async {
        late BuildContext buildContext;
        late Quad quad;

        await tester.pumpWidget(
          CrosswordInteractiveViewer(
            builder: (context, viewport) {
              quad = viewport;

              return Builder(
                builder: (context) {
                  buildContext = context;
                  return const SizedBox();
                },
              );
            },
          ),
        );

        expect(QuadScope.of(buildContext), equals(quad));
      },
    );
  });
}
