// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/src/theme/io_crossword_theme.dart';
import 'package:io_crossword_ui/src/widgets/io_logo.dart';

import '../../test_tag.dart';

void main() {
  group('$IoLogo', () {
    testWidgets('renders successfully', (tester) async {
      await tester.pumpSubject(const IoLogo());
      expect(find.byType(IoLogo), findsOneWidget);
    });

    group('renders as expected', () {
      Uri goldenKey(String name) =>
          Uri.parse('goldens/io_logo/io_logo__$name.png');

      testWidgets(
        'with white surface color',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(100, 50));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;

          await tester.pumpSubject(
            ColoredBox(
              color: themeData.colorScheme.surface,
              child: const Center(child: IoLogo()),
            ),
            themeData: themeData,
          );

          await expectLater(
            find.byType(IoLogo),
            matchesGoldenFile(goldenKey('white')),
          );
        },
      );

      testWidgets(
        'with new color after repaint',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(100, 50));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          var themeData = IoCrosswordTheme().themeData;
          StateSetter? stateSetter;

          await tester.pumpWidget(
            StatefulBuilder(
              builder: (context, setState) {
                stateSetter ??= setState;

                return Theme(
                  data: themeData,
                  child: ColoredBox(
                    color: themeData.colorScheme.surface,
                    child: const Center(child: IoLogo()),
                  ),
                );
              },
            ),
          );

          await tester.pumpAndSettle();
          stateSetter!(() {
            themeData = themeData.copyWith(
              colorScheme: themeData.colorScheme
                  .copyWith(onSurface: const Color(0xffff0000)),
            );
          });
          await tester.pumpAndSettle();

          await expectLater(
            find.byType(IoLogo),
            matchesGoldenFile(goldenKey('repainted')),
          );
        },
      );
    });
  });
}

extension on WidgetTester {
  /// Pumps the test subject with all its required ancestors.
  Future<void> pumpSubject(
    Widget child, {
    ThemeData? themeData,
  }) =>
      pumpWidget(
        _Subject(
          themeData: themeData,
          child: child,
        ),
      );
}

class _Subject extends StatelessWidget {
  const _Subject({
    required this.child,
    this.themeData,
  });

  final ThemeData? themeData;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData ?? ThemeData(),
      child: child,
    );
  }
}
