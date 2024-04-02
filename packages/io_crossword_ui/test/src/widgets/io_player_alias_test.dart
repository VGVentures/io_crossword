import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_tag.dart';

class _MockIoPlayerAliasStyle extends Mock implements IoPlayerAliasStyle {}

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
                  style: themeData.io.playerAliasTheme.big.toAhem(),
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
                  style: themeData.io.playerAliasTheme.small.toAhem(),
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
                  style: themeData.io.playerAliasTheme.big.toAhem(),
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
                  style: themeData.io.playerAliasTheme.small.toAhem(),
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
                  style: themeData.io.playerAliasTheme.big.toAhem(),
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
                  style: themeData.io.playerAliasTheme.small.toAhem(),
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
                  style: themeData.io.playerAliasTheme.big..toAhem(),
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
                  style: themeData.io.playerAliasTheme.small.toAhem(),
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

  group('$IoPlayerAliasStyle', () {
    group('copyWith', () {
      test('remains the same when no arguments are give', () {
        const style = IoPlayerAliasStyle(
          backgroundColor: Color(0xff00ff00),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          textStyle: TextStyle(),
          margin: EdgeInsets.all(4),
          boxSize: Size.square(30),
        );

        final copy = style.copyWith();

        expect(copy, equals(style));
      });

      test('changes when arguments are give', () {
        const style = IoPlayerAliasStyle(
          backgroundColor: Color(0xff00ff00),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          textStyle: TextStyle(),
          margin: EdgeInsets.all(4),
          boxSize: Size.square(30),
        );

        const newStyle = IoPlayerAliasStyle(
          backgroundColor: Color(0xff0000ff),
          borderRadius: BorderRadius.all(Radius.circular(8)),
          textStyle: TextStyle(),
          margin: EdgeInsets.all(8),
          boxSize: Size.square(60),
        );

        final copy = style.copyWith(
          backgroundColor: newStyle.backgroundColor,
          borderRadius: newStyle.borderRadius,
          textStyle: newStyle.textStyle,
          margin: newStyle.margin,
          boxSize: newStyle.boxSize,
        );

        expect(copy, equals(newStyle));
      });
    });

    test('lerps', () {
      const from = IoPlayerAliasStyle(
        backgroundColor: Color(0xff00ff00),
        borderRadius: BorderRadius.all(Radius.circular(4)),
        textStyle: TextStyle(),
        margin: EdgeInsets.all(4),
        boxSize: Size.square(30),
      );
      const to = IoPlayerAliasStyle(
        backgroundColor: Color(0xff0000ff),
        borderRadius: BorderRadius.all(Radius.circular(8)),
        textStyle: TextStyle(),
        margin: EdgeInsets.all(8),
        boxSize: Size.square(60),
      );

      final actual = from.lerp(to, 0.5);

      expect(actual.backgroundColor, equals(const Color(0xff007f7f)));
      expect(actual.borderRadius, equals(BorderRadius.circular(6)));
      expect(actual.margin, equals(const EdgeInsets.all(6)));
      expect(actual.boxSize, equals(const Size.square(45)));
    });
  });

  group('$IoPlayerAliasTheme', () {
    test('lerps', () {
      final small = _MockIoPlayerAliasStyle();
      final big = _MockIoPlayerAliasStyle();

      final theme = IoPlayerAliasTheme(
        small: small,
        big: big,
      );

      when(() => small.lerp(small, 0.5)).thenReturn(small);
      when(() => big.lerp(big, 0.5)).thenReturn(big);

      final actual = theme.lerp(theme, 0.5);

      expect(actual.small, equals(small));
      expect(actual.big, equals(big));
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

extension on IoPlayerAliasStyle {
  IoPlayerAliasStyle toAhem() {
    return copyWith(
      textStyle: textStyle.copyWith(fontFamily: ''),
    );
  }
}
