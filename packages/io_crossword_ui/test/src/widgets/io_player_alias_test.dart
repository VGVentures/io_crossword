import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';

import '../../test_tag.dart';

void main() {
  group('$IoPlayerAlias', () {
    const style = IoPlayerAliasStyle(
      backgroundColor: Color(0xff00ff00),
      textStyle: TextStyle(),
      borderRadius: BorderRadius.all(Radius.circular(4)),
      margin: EdgeInsets.all(4),
      boxSize: Size.square(30),
    );

    testWidgets('renders successfully', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: IoPlayerAlias('ABC', style: style),
        ),
      );
      expect(find.byType(IoPlayerAlias), findsOneWidget);
    });

    testWidgets('renders characters', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: IoPlayerAlias('ABC', style: style),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    group('renders as expected', () {
      Uri goldenKey(String name) =>
          Uri.parse('goldens/io_player_alias__$name.png');

      group('with Android theme', () {
        late ThemeData themeData;

        setUp(() {
          themeData = IoAndroidTheme().themeData;
        });

        testWidgets(
          'and big',
          tags: TestTag.golden,
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(300, 150));

            await tester.pumpWidget(
              _GoldenSubject(
                themeData: themeData,
                child: IoPlayerAlias(
                  'ABC',
                  style: themeData.io.playerAliasTheme.big,
                ),
              ),
            );

            await expectLater(
              find.byType(IoPlayerAlias),
              matchesGoldenFile(goldenKey('android--big')),
            );
          },
        );

        testWidgets(
          'and small',
          tags: TestTag.golden,
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(300, 150));

            await tester.pumpWidget(
              _GoldenSubject(
                themeData: themeData,
                child: IoPlayerAlias(
                  'ABC',
                  style: themeData.io.playerAliasTheme.small,
                ),
              ),
            );

            await expectLater(
              find.byType(IoPlayerAlias),
              matchesGoldenFile(goldenKey('android--small')),
            );
          },
        );
      });

      group('with Chrome theme', () {
        late ThemeData themeData;

        setUp(() {
          themeData = IoChromeTheme().themeData;
        });

        testWidgets(
          'and big',
          tags: TestTag.golden,
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(300, 150));

            await tester.pumpWidget(
              _GoldenSubject(
                themeData: themeData,
                child: IoPlayerAlias(
                  'ABC',
                  style: themeData.io.playerAliasTheme.big,
                ),
              ),
            );

            await expectLater(
              find.byType(IoPlayerAlias),
              matchesGoldenFile(goldenKey('chrome--big')),
            );
          },
        );

        testWidgets(
          'and small',
          tags: TestTag.golden,
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(300, 150));

            await tester.pumpWidget(
              _GoldenSubject(
                themeData: themeData,
                child: IoPlayerAlias(
                  'ABC',
                  style: themeData.io.playerAliasTheme.small,
                ),
              ),
            );

            await expectLater(
              find.byType(IoPlayerAlias),
              matchesGoldenFile(goldenKey('chrome--small')),
            );
          },
        );
      });

      group('with Firebase theme', () {
        late ThemeData themeData;

        setUp(() {
          themeData = IoFirebaseTheme().themeData;
        });

        testWidgets(
          'and big',
          tags: TestTag.golden,
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(300, 150));

            await tester.pumpWidget(
              _GoldenSubject(
                themeData: themeData,
                child: IoPlayerAlias(
                  'ABC',
                  style: themeData.io.playerAliasTheme.big,
                ),
              ),
            );

            await expectLater(
              find.byType(IoPlayerAlias),
              matchesGoldenFile(goldenKey('firebase--big')),
            );
          },
        );

        testWidgets(
          'and small',
          tags: TestTag.golden,
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(300, 150));

            await tester.pumpWidget(
              _GoldenSubject(
                themeData: themeData,
                child: IoPlayerAlias(
                  'ABC',
                  style: themeData.io.playerAliasTheme.small,
                ),
              ),
            );

            await expectLater(
              find.byType(IoPlayerAlias),
              matchesGoldenFile(goldenKey('firebase--small')),
            );
          },
        );
      });

      group('with Flutter theme', () {
        late ThemeData themeData;

        setUp(() {
          themeData = IoFlutterTheme().themeData;
        });

        testWidgets(
          'and big',
          tags: TestTag.golden,
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(300, 150));

            await tester.pumpWidget(
              _GoldenSubject(
                themeData: themeData,
                child: IoPlayerAlias(
                  'ABC',
                  style: themeData.io.playerAliasTheme.big,
                ),
              ),
            );

            await expectLater(
              find.byType(IoPlayerAlias),
              matchesGoldenFile(goldenKey('flutter--big')),
            );
          },
        );

        testWidgets(
          'and small',
          tags: TestTag.golden,
          (tester) async {
            await tester.binding.setSurfaceSize(const Size(300, 150));

            await tester.pumpWidget(
              _GoldenSubject(
                themeData: themeData,
                child: IoPlayerAlias(
                  'ABC',
                  style: themeData.io.playerAliasTheme.small,
                ),
              ),
            );

            await expectLater(
              find.byType(IoPlayerAlias),
              matchesGoldenFile(goldenKey('flutter--small')),
            );
          },
        );
      });
    });
  });
}

class _GoldenSubject extends StatelessWidget {
  const _GoldenSubject({
    required this.themeData,
    required this.child,
  });

  final ThemeData themeData;

  final IoPlayerAlias child;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: themeData.colorScheme.background,
        child: Center(child: child),
      ),
    );
  }
}
