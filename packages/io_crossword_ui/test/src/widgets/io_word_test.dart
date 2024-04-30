import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_tag.dart';

class _MockIoWordStyle extends Mock implements IoWordStyle {}

class _GoldenFileComparator extends LocalFileComparator {
  _GoldenFileComparator()
      : super(
          Uri.parse('test/src/widgets/io_word.dart'),
        );

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );

    // Sufficient toleration to accommodate font rendering differences.
    final passed = result.diffPercent <= 0.15;
    if (passed) {
      result.dispose();
      return true;
    }

    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

void main() {
  group('$IoWord', () {
    const style = IoWordStyle(
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
          child: IoWord('ABC', style: style),
        ),
      );
      expect(find.byType(IoWord), findsOneWidget);
    });

    testWidgets('renders upper-cased characters', (tester) async {
      await tester.pumpWidget(
        const Directionality(
          textDirection: TextDirection.ltr,
          child: IoWord('abc', style: style),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('B'), findsOneWidget);
      expect(find.text('C'), findsOneWidget);
    });

    group('renders as expected', () {
      Uri goldenKey(String name) =>
          Uri.parse('goldens/io_word/io_word__${name.toLowerCase()}.png');

      setUp(() async {
        final previousComparator = goldenFileComparator;
        final comparator = _GoldenFileComparator();
        goldenFileComparator = comparator;
        addTearDown(() {
          goldenFileComparator = previousComparator;
        });
      });

      for (final theme in {
        'Android': IoAndroidTheme.new,
        'Chrome': IoChromeTheme.new,
        'Firebase': IoFirebaseTheme.new,
        'Flutter': IoFlutterTheme.new,
      }.entries) {
        group('with ${theme.key} theme', () {
          late ThemeData themeData;

          setUp(() {
            themeData = theme.value().themeData;
          });

          testWidgets(
            'big and horizontal',
            tags: TestTag.golden,
            (tester) async {
              await tester.binding.setSurfaceSize(const Size(300, 150));
              addTearDown(() => tester.binding.setSurfaceSize(null));

              await tester.pumpWidget(
                _GoldenSubject(
                  themeData: themeData,
                  child: IoWord(
                    'ABC',
                    style: themeData.io.wordTheme.big,
                  ),
                ),
              );

              await expectLater(
                find.byType(IoWord),
                matchesGoldenFile(goldenKey('${theme.key}--big--horizontal')),
              );
            },
          );

          testWidgets(
            'big and vertical',
            tags: TestTag.golden,
            (tester) async {
              await tester.binding.setSurfaceSize(const Size(150, 300));
              addTearDown(() => tester.binding.setSurfaceSize(null));

              await tester.pumpWidget(
                _GoldenSubject(
                  themeData: themeData,
                  child: IoWord(
                    'ABC',
                    direction: Axis.vertical,
                    style: themeData.io.wordTheme.big,
                  ),
                ),
              );

              await expectLater(
                find.byType(IoWord),
                matchesGoldenFile(goldenKey('${theme.key}--big--vertical')),
              );
            },
          );

          testWidgets(
            'small and horizontal',
            tags: TestTag.golden,
            (tester) async {
              await tester.binding.setSurfaceSize(const Size(300, 150));
              addTearDown(() => tester.binding.setSurfaceSize(null));

              await tester.pumpWidget(
                _GoldenSubject(
                  themeData: themeData,
                  child: IoWord(
                    'ABC',
                    style: themeData.io.wordTheme.small,
                  ),
                ),
              );

              await expectLater(
                find.byType(IoWord),
                matchesGoldenFile(goldenKey('${theme.key}--small--horizontal')),
              );
            },
          );

          testWidgets(
            'small and vertical',
            tags: TestTag.golden,
            (tester) async {
              await tester.binding.setSurfaceSize(const Size(150, 300));
              addTearDown(() => tester.binding.setSurfaceSize(null));

              await tester.pumpWidget(
                _GoldenSubject(
                  themeData: themeData,
                  child: IoWord(
                    'ABC',
                    direction: Axis.vertical,
                    style: themeData.io.wordTheme.small,
                  ),
                ),
              );

              await expectLater(
                find.byType(IoWord),
                matchesGoldenFile(goldenKey('${theme.key}--small--vertical')),
              );
            },
          );
        });
      }
    });
  });

  group('$IoWordStyle', () {
    group('copyWith', () {
      test('remains the same when no arguments are give', () {
        const style = IoWordStyle(
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
        const style = IoWordStyle(
          backgroundColor: Color(0xff00ff00),
          borderRadius: BorderRadius.all(Radius.circular(4)),
          textStyle: TextStyle(),
          margin: EdgeInsets.all(4),
          boxSize: Size.square(30),
        );

        const newStyle = IoWordStyle(
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
      const from = IoWordStyle(
        backgroundColor: Color(0xff00ff00),
        borderRadius: BorderRadius.all(Radius.circular(4)),
        textStyle: TextStyle(),
        margin: EdgeInsets.all(4),
        boxSize: Size.square(30),
      );
      const to = IoWordStyle(
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

  group('$IoWordTheme', () {
    test('lerps', () {
      final small = _MockIoWordStyle();
      final big = _MockIoWordStyle();

      final theme = IoWordTheme(
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

  final IoWord child;

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
