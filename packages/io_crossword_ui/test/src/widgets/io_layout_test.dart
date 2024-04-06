import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:io_crossword_ui/src/widgets/io_layout.dart';

void main() {
  group('$IoLayout', () {
    testWidgets('renders successfully', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(),
          child: IoLayout(child: SizedBox()),
        ),
      );

      expect(find.byType(IoLayout), findsOneWidget);
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

      group('is small', () {
        testWidgets(
          'when the width is smaller than the height',
          (tester) async {
            late final BuildContext buildContext;
            await tester.pumpWidget(
              MediaQuery(
                data: const MediaQueryData(size: Size(100, 200)),
                child: IoLayout(
                  child: Builder(
                    builder: (context) {
                      buildContext = context;
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            );

            expect(IoLayout.of(buildContext), equals(IoLayoutData.small));
          },
        );

        testWidgets(
          'when the width is smaller than the medium breakpoint',
          (tester) async {
            late final BuildContext buildContext;
            await tester.pumpWidget(
              MediaQuery(
                data: const MediaQueryData(
                  size: Size(IoCrosswordBreakpoints.medium - 1, 200),
                ),
                child: IoLayout(
                  child: Builder(
                    builder: (context) {
                      buildContext = context;
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            );

            expect(IoLayout.of(buildContext), equals(IoLayoutData.small));
          },
        );
      });

      group('is large', () {
        testWidgets(
          'when the width is at the medium breakpoint',
          (tester) async {
            late final BuildContext buildContext;
            await tester.pumpWidget(
              MediaQuery(
                data: const MediaQueryData(
                  size: Size(IoCrosswordBreakpoints.medium, 200),
                ),
                child: IoLayout(
                  child: Builder(
                    builder: (context) {
                      buildContext = context;
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            );

            expect(IoLayout.of(buildContext), equals(IoLayoutData.large));
          },
        );

        testWidgets(
          'when the width is greater than the medium breakpoint',
          (tester) async {
            late final BuildContext buildContext;
            await tester.pumpWidget(
              MediaQuery(
                data: const MediaQueryData(
                  size: Size(IoCrosswordBreakpoints.medium + 1, 200),
                ),
                child: IoLayout(
                  child: Builder(
                    builder: (context) {
                      buildContext = context;
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            );

            expect(IoLayout.of(buildContext), equals(IoLayoutData.large));
          },
        );
      });

      testWidgets(
        'changes when the $MediaQueryData changes',
        (tester) async {
          BuildContext? buildContext;
          StateSetter? stateSetter;

          var data = const MediaQueryData(size: Size(100, 200));

          await tester.pumpWidget(
            StatefulBuilder(
              builder: (context, setState) {
                stateSetter ??= setState;
                return MediaQuery(
                  data: data,
                  child: IoLayout(
                    child: Builder(
                      builder: (context) {
                        buildContext ??= context;
                        return const SizedBox();
                      },
                    ),
                  ),
                );
              },
            ),
          );

          expect(IoLayout.of(buildContext!), equals(IoLayoutData.small));

          stateSetter!(() {
            data = const MediaQueryData(
              size: Size(IoCrosswordBreakpoints.medium, 100),
            );
          });
          await tester.pumpAndSettle();

          expect(IoLayout.of(buildContext!), equals(IoLayoutData.large));
        },
      );
    });
  });
}
