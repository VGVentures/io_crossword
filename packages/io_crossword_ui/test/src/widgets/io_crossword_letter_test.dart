import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_tag.dart';

class _MockIoCrosswordLetterStyle extends Mock
    implements IoCrosswordLetterStyle {}

void main() {
  group('$IoCrosswordLetter', () {
    testWidgets('pumps successfully', (tester) async {
      await tester.pumpWidget(
        Theme(
          data: IoCrosswordTheme().themeData,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: IoCrosswordLetter('A'),
          ),
        ),
      );

      expect(find.byType(IoCrosswordLetter), findsOneWidget);
    });

    testWidgets('upper-cases the letter', (tester) async {
      await tester.pumpWidget(
        Theme(
          data: IoCrosswordTheme().themeData,
          child: const Directionality(
            textDirection: TextDirection.ltr,
            child: IoCrosswordLetter('a'),
          ),
        ),
      );

      expect(find.text('A'), findsOneWidget);
      expect(find.text('a'), findsNothing);
    });

    group('renders as expected', () {
      Uri goldenKey(String name) =>
          Uri.parse('goldens/io_crossword_letter_$name.png');

      testWidgets(
        'with empty theme',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size.square(100));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await tester.pumpGoldenSubject(const IoCrosswordLetter(null));

          await expectLater(
            find.byType(IoCrosswordLetter),
            matchesGoldenFile(goldenKey('empty')),
          );
        },
      );

      testWidgets(
        'with dash theme',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size.square(100));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;
          final style = themeData.io.crosswordLetterTheme.dash;

          await tester.pumpGoldenSubject(
            themeData: themeData,
            IoCrosswordLetter(null, style: style),
          );

          await expectLater(
            find.byType(IoCrosswordLetter),
            matchesGoldenFile(goldenKey('dash')),
          );
        },
      );

      testWidgets(
        'with sparky theme',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size.square(100));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;
          final style = themeData.io.crosswordLetterTheme.sparky;

          await tester.pumpGoldenSubject(
            themeData: themeData,
            IoCrosswordLetter(null, style: style),
          );

          await expectLater(
            find.byType(IoCrosswordLetter),
            matchesGoldenFile(goldenKey('sparky')),
          );
        },
      );

      testWidgets(
        'with android theme',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size.square(100));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;
          final style = themeData.io.crosswordLetterTheme.android;

          await tester.pumpGoldenSubject(
            themeData: themeData,
            IoCrosswordLetter(null, style: style),
          );

          await expectLater(
            find.byType(IoCrosswordLetter),
            matchesGoldenFile(goldenKey('android')),
          );
        },
      );

      testWidgets(
        'with dino theme',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size.square(100));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;
          final style = themeData.io.crosswordLetterTheme.dino;

          await tester.pumpGoldenSubject(
            themeData: themeData,
            IoCrosswordLetter(null, style: style),
          );

          await expectLater(
            find.byType(IoCrosswordLetter),
            matchesGoldenFile(goldenKey('dino')),
          );
        },
      );
    });
  });

  group('$IoCrosswordLetterStyle', () {
    test('supports value equality', () {
      final style1 = IoCrosswordLetterStyle(
        backgroundColor: const Color(0xff00ff00),
        border: Border.all(color: const Color(0xff00ff00)),
        textStyle: const TextStyle(color: Color(0xff00ff00)),
      );
      final style2 = IoCrosswordLetterStyle(
        backgroundColor: const Color(0xff00ff00),
        border: Border.all(color: const Color(0xff00ff00)),
        textStyle: const TextStyle(color: Color(0xff00ff00)),
      );
      final style3 = IoCrosswordLetterStyle(
        backgroundColor: const Color(0xff0000ff),
        border: Border.all(color: const Color(0xff0000ff)),
        textStyle: const TextStyle(
          color: Color(0xff0000ff),
        ),
      );

      expect(style1, equals(style2));
      expect(style1, isNot(equals(style3)));
      expect(style2, isNot(equals(style3)));
    });

    test('lerps', () {
      final style1 = IoCrosswordLetterStyle(
        backgroundColor: const Color(0xff00ff00),
        border: Border.all(color: const Color(0xff00ff00)),
        textStyle: const TextStyle(color: Color(0xff00ff00)),
      );
      final style2 = IoCrosswordLetterStyle(
        backgroundColor: const Color(0xff0000ff),
        border: Border.all(color: const Color(0xff0000ff)),
        textStyle: const TextStyle(
          color: Color(0xff0000ff),
        ),
      );

      final lerp = style1.lerp(style2, 0.5);

      expect(lerp.backgroundColor, equals(const Color(0xff007f7f)));
      expect(lerp.border, equals(Border.all(color: const Color(0xff007f7f))));
      expect(lerp.textStyle.color, equals(const Color(0xff007f7f)));
    });
  });

  group('$IoCrosswordLetterTheme', () {
    test('supports value equality', () {
      final theme1 = IoCrosswordLetterTheme(
        dash: _MockIoCrosswordLetterStyle(),
        sparky: _MockIoCrosswordLetterStyle(),
        android: _MockIoCrosswordLetterStyle(),
        dino: _MockIoCrosswordLetterStyle(),
        empty: _MockIoCrosswordLetterStyle(),
      );
      final theme2 = IoCrosswordLetterTheme(
        dash: theme1.dash,
        sparky: theme1.sparky,
        android: theme1.android,
        dino: theme1.dino,
        empty: theme1.empty,
      );
      final theme3 = IoCrosswordLetterTheme(
        dash: _MockIoCrosswordLetterStyle(),
        sparky: _MockIoCrosswordLetterStyle(),
        android: _MockIoCrosswordLetterStyle(),
        dino: _MockIoCrosswordLetterStyle(),
        empty: _MockIoCrosswordLetterStyle(),
      );

      expect(theme1, equals(theme2));
      expect(theme1, isNot(equals(theme3)));
      expect(theme2, isNot(equals(theme3)));
    });

    test('lerps', () {
      final theme1 = IoCrosswordLetterTheme(
        dash: _MockIoCrosswordLetterStyle(),
        sparky: _MockIoCrosswordLetterStyle(),
        android: _MockIoCrosswordLetterStyle(),
        dino: _MockIoCrosswordLetterStyle(),
        empty: _MockIoCrosswordLetterStyle(),
      );
      final theme2 = IoCrosswordLetterTheme(
        dash: _MockIoCrosswordLetterStyle(),
        sparky: _MockIoCrosswordLetterStyle(),
        android: _MockIoCrosswordLetterStyle(),
        dino: _MockIoCrosswordLetterStyle(),
        empty: _MockIoCrosswordLetterStyle(),
      );

      const t = 0.5;
      when(() => theme1.dash.lerp(theme2.dash, t)).thenReturn(theme2.dash);
      when(() => theme1.sparky.lerp(theme2.sparky, t))
          .thenReturn(theme2.sparky);
      when(() => theme1.android.lerp(theme2.android, t))
          .thenReturn(theme2.android);
      when(() => theme1.dino.lerp(theme2.dino, t)).thenReturn(theme2.dino);
      when(() => theme1.empty.lerp(theme2.empty, t)).thenReturn(theme2.empty);

      final lerp = theme1.lerp(theme2, t);

      expect(lerp.dash, equals(theme2.dash));
      expect(lerp.sparky, equals(theme2.sparky));
      expect(lerp.android, equals(theme2.android));
      expect(lerp.dino, equals(theme2.dino));

      verify(() => theme1.dash.lerp(theme2.dash, t)).called(1);
    });
  });
}

extension on WidgetTester {
  Future<void> pumpGoldenSubject(Widget child, {ThemeData? themeData}) async {
    await pumpWidget(
      _GoldenSubject(
        themeData: IoCrosswordTheme().themeData,
        child: child,
      ),
    );
  }
}

class _GoldenSubject extends StatelessWidget {
  const _GoldenSubject({
    required this.themeData,
    required this.child,
  });

  final ThemeData themeData;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: themeData.colorScheme.background,
          child: Center(
            child: SizedBox.square(dimension: 50, child: child),
          ),
        ),
      ),
    );
  }
}
