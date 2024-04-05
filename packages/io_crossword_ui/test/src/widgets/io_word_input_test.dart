import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_tag.dart';

class _MockIoWordInputCharacterFieldStyle extends Mock
    implements IoWordInputCharacterFieldStyle {}

class _GoldenFileComparator extends LocalFileComparator {
  _GoldenFileComparator()
      : super(
          Uri.parse('test/src/widgets/io_word_input_test.dart'),
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
  group('$IoWordInput', () {
    testWidgets('renders successfully', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 150));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _Subject(child: IoWordInput.alphabetic(length: 5)),
      );
      expect(find.byType(IoWordInput), findsOneWidget);
    });

    testWidgets(
      'onWord gets called as words are filled',
      tags: TestTag.golden,
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(500, 150));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        final words = <String>[];
        await tester.pumpWidget(
          _Subject(
            child: IoWordInput.alphabetic(
              length: 5,
              characters: const {0: 'A', 1: 'B', 4: 'E'},
              onWord: words.add,
            ),
          ),
        );

        final subject = find.byType(IoWordInput);
        await tester.tap(subject);
        await tester.pumpAndSettle();

        final editableTexts = find.byType(EditableText);

        await tester.enterText(editableTexts.first, 'C');
        await tester.pumpAndSettle();

        expect(
          words,
          isEmpty,
          reason:
              '''onWord should not be called yet since there is still a character missing''',
        );

        await tester.enterText(editableTexts.last, 'D');
        await tester.pumpAndSettle();

        expect(
          words,
          equals(['ABCDE']),
          reason: '''onWord should be called with the filled word''',
        );
        words.clear();

        await tester.enterText(editableTexts.last, '!');
        await tester.pumpAndSettle();

        expect(
          words,
          isEmpty,
          reason:
              '''onWord should not be called yet since a character has been removed by a non-alphabetic character''',
        );

        await tester.enterText(editableTexts.first, 'Y');
        await tester.enterText(editableTexts.last, 'Z');
        await tester.pumpAndSettle();

        expect(
          words,
          equals(['ABYZE']),
          reason: '''onWord should be called again with the updated word''',
        );
      },
    );

    group('renders as expected', () {
      Uri goldenKey(String name) =>
          Uri.parse('goldens/io_word_input/io_word_input__$name.png');

      setUpAll(() async {
        final previousComparator = goldenFileComparator;
        final comparator = _GoldenFileComparator();
        goldenFileComparator = comparator;
        addTearDown(() {
          goldenFileComparator = previousComparator;
        });
      });

      testWidgets(
        'with empty characters',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(500, 150));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;

          await tester.pumpWidget(
            _GoldenSubject(
              themeData: themeData,
              child: IoWordInput.alphabetic(length: 5),
            ),
          );

          await expectLater(
            find.byType(IoWordInput),
            matchesGoldenFile(goldenKey('empty_characters')),
          );
        },
      );

      testWidgets(
        'with all characters',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(500, 150));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;

          await tester.pumpWidget(
            _GoldenSubject(
              themeData: themeData,
              child: IoWordInput.alphabetic(
                length: 5,
                characters: const {0: 'A', 1: 'B', 2: 'C', 3: 'D', 4: 'E'},
              ),
            ),
          );

          await expectLater(
            find.byType(IoWordInput),
            matchesGoldenFile(goldenKey('all_characters')),
          );
        },
      );

      testWidgets(
        'with focused character',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(500, 150));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;

          await tester.pumpWidget(
            _GoldenSubject(
              themeData: themeData,
              child: IoWordInput.alphabetic(
                length: 5,
                characters: const {0: 'A', 2: 'C'},
              ),
            ),
          );

          final subject = find.byType(IoWordInput);
          await tester.tap(subject);
          await tester.pumpAndSettle();

          await expectLater(
            subject,
            matchesGoldenFile(goldenKey('focused')),
          );
        },
      );

      testWidgets(
        'with filled character',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(500, 150));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;

          await tester.pumpWidget(
            _GoldenSubject(
              themeData: themeData,
              child: IoWordInput.alphabetic(
                length: 5,
                characters: const {0: 'A', 2: 'C'},
              ),
            ),
          );

          final subject = find.byType(IoWordInput);
          await tester.tap(subject);
          await tester.pumpAndSettle();

          final editableText = find.byType(EditableText).first;
          await tester.enterText(editableText, 'A');
          await tester.pumpAndSettle();

          await expectLater(
            subject,
            matchesGoldenFile(goldenKey('filled')),
          );
        },
      );
    });
  });

  group('$IoWordInputStyle', () {
    test('lerps', () {
      const t = 0.5;
      final from = IoWordInputStyle(
        padding: const EdgeInsets.all(1),
        empty: _MockIoWordInputCharacterFieldStyle(),
        filled: _MockIoWordInputCharacterFieldStyle(),
        focused: _MockIoWordInputCharacterFieldStyle(),
        disabled: _MockIoWordInputCharacterFieldStyle(),
      );
      final to = IoWordInputStyle(
        padding: const EdgeInsets.all(2),
        empty: _MockIoWordInputCharacterFieldStyle(),
        filled: _MockIoWordInputCharacterFieldStyle(),
        focused: _MockIoWordInputCharacterFieldStyle(),
        disabled: _MockIoWordInputCharacterFieldStyle(),
      );

      when(() => from.empty.lerp(to.empty, t)).thenReturn(to.empty);
      when(() => from.filled.lerp(to.filled, t)).thenReturn(to.filled);
      when(() => from.focused.lerp(to.focused, t)).thenReturn(to.focused);
      when(() => from.disabled.lerp(to.disabled, t)).thenReturn(to.disabled);

      final lerp = from.lerp(to, t);

      expect(lerp.empty, equals(to.empty));
      expect(lerp.filled, equals(to.filled));
      expect(lerp.focused, equals(to.focused));
      expect(lerp.disabled, equals(to.disabled));

      expect(lerp.padding, equals(const EdgeInsets.all(1.5)));
    });
  });

  group('$IoWordInputCharacterFieldStyle', () {
    test('lerps', () {
      final from = IoWordInputCharacterFieldStyle(
        backgroundColor: const Color(0xff00ff00),
        border: Border.all(),
        borderRadius: BorderRadius.circular(1),
        textStyle: const TextStyle(color: Color(0xff00ff00)),
      );

      final to = IoWordInputCharacterFieldStyle(
        backgroundColor: const Color(0xff0000ff),
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(2),
        textStyle: const TextStyle(color: Color(0xff0000ff)),
      );

      final lerp = from.lerp(to, 0.5);

      expect(lerp, isNot(equals(to)));
      expect(lerp, isNot(equals(from)));

      expect(lerp.backgroundColor, const Color(0xff007f7f));
      expect(lerp.border.top.width, 1.5);
      expect(lerp.borderRadius, BorderRadius.circular(1.5));
      expect(lerp.textStyle.color, const Color(0xff007f7f));
    });
  });
}

class _Subject extends StatelessWidget {
  const _Subject({
    required this.child,
  });

  final IoWordInput child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: IoCrosswordTheme().themeData,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: child),
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

  final IoWordInput child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ColoredBox(
          color: themeData.colorScheme.background,
          child: Center(child: child),
        ),
      ),
    );
  }
}