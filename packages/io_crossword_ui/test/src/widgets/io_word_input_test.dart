import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../test_tag.dart';

class _MockIoWordInputCharacterFieldStyle extends Mock
    implements IoWordInputCharacterFieldStyle {}

class _MockIoWordInputStyle extends Mock implements IoWordInputStyle {}

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
    TestWidgetsFlutterBinding.ensureInitialized();

    testWidgets('renders successfully', (tester) async {
      await tester.binding.setSurfaceSize(const Size(500, 150));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        _Subject(child: IoWordInput.alphabetic(length: 5)),
      );
      expect(find.byType(IoWordInput), findsOneWidget);
    });

    testWidgets('onSubmit gets called with word', (tester) async {
      final words = <String>[];
      await tester.pumpWidget(
        _Subject(
          child: IoWordInput.alphabetic(
            length: 5,
            characters: const {0: 'A', 1: 'B', 4: 'E'},
            onSubmit: words.add,
          ),
        ),
      );

      Future<void> submit() async {
        await TestWidgetsFlutterBinding.instance.testTextInput
            .receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();
      }

      final subject = find.byType(IoWordInput);
      await tester.tap(subject);
      await tester.pumpAndSettle();

      final editableTexts = find.byType(EditableText);

      await tester.enterText(editableTexts.first, 'C');
      await submit();
      expect(words.last, equals('ABCE'));

      await tester.enterText(editableTexts.last, 'D');
      await submit();
      expect(words.last, equals('ABCDE'));

      await tester.enterText(editableTexts.last, '!');
      await submit();
      expect(words.last, equals('ABCE'));

      await tester.enterText(editableTexts.first, 'Y');
      await tester.pumpAndSettle();
      expect(
        words.last,
        equals('ABCE'),
        reason: '''onSubmit should not be called since it was not submitted''',
      );

      await tester.enterText(editableTexts.last, 'Z');
      await submit();
      expect(words.last, equals('ABYZE'));
    });

    testWidgets(
      'onWord gets called as words are filled',
      (tester) async {
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

    group('controller', () {
      testWidgets('word gets updated as input changes', (tester) async {
        final controller = IoWordInputController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          _Subject(
            child: IoWordInput.alphabetic(
              length: 5,
              characters: const {0: 'A', 1: 'B', 4: 'E'},
              controller: controller,
            ),
          ),
        );

        expect(controller.word, equals('ABE'));

        final editableTexts = find.byType(EditableText);

        await tester.enterText(editableTexts.first, 'C');
        await tester.pumpAndSettle();
        expect(controller.word, equals('ABCE'));

        await tester.enterText(editableTexts.last, 'D');
        await tester.pumpAndSettle();
        expect(controller.word, equals('ABCDE'));

        await tester.enterText(editableTexts.last, '!');
        await tester.pumpAndSettle();
        expect(controller.word, equals('ABCE'));

        await tester.enterText(editableTexts.first, 'Y');
        await tester.enterText(editableTexts.last, 'Z');
        await tester.pumpAndSettle();
        expect(controller.word, equals('ABYZE'));
      });

      testWidgets('word gets notified as input changes', (tester) async {
        final controller = IoWordInputController();
        addTearDown(controller.dispose);

        final words = <String>[];
        controller.addListener(() => words.add(controller.word));

        await tester.pumpWidget(
          _Subject(
            child: IoWordInput.alphabetic(
              length: 5,
              characters: const {0: 'A', 1: 'B', 4: 'E'},
              controller: controller,
            ),
          ),
        );

        expect(words.last, equals('ABE'));

        final editableTexts = find.byType(EditableText);

        await tester.enterText(editableTexts.first, 'C');
        await tester.pumpAndSettle();
        expect(words.last, equals('ABCE'));

        await tester.enterText(editableTexts.last, 'D');
        await tester.pumpAndSettle();
        expect(words.last, equals('ABCDE'));

        await tester.enterText(editableTexts.last, '!');
        await tester.pumpAndSettle();
        expect(words.last, equals('ABCE'));

        await tester.enterText(editableTexts.first, 'Y');
        await tester.enterText(editableTexts.last, 'Z');
        await tester.pumpAndSettle();
        expect(words.last, equals('ABYZE'));
      });

      testWidgets('word resets when controller.reset is called',
          (tester) async {
        final controller = IoWordInputController();
        addTearDown(controller.dispose);

        final words = <String>[];
        controller.addListener(() => words.add(controller.word));

        await tester.pumpWidget(
          _Subject(
            child: IoWordInput.alphabetic(
              length: 5,
              characters: const {0: 'A', 1: 'B', 4: 'E'},
              controller: controller,
            ),
          ),
        );

        expect(words.last, equals('ABE'));

        final editableTexts = find.byType(EditableText);

        await tester.enterText(editableTexts.first, 'C');
        await tester.pumpAndSettle();
        expect(words.last, equals('ABCE'));

        await tester.enterText(editableTexts.last, 'D');
        await tester.pumpAndSettle();
        expect(words.last, equals('ABCDE'));

        controller.reset();
        await tester.pumpAndSettle();
        expect(words.last, equals(''));
      });
    });

    group('renders as expected', () {
      Uri goldenKey(String name) =>
          Uri.parse('goldens/io_word_input/io_word_input__$name.png');

      setUp(() async {
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
        'with focused characters vertically',
        tags: TestTag.golden,
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(150, 500));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          final themeData = IoCrosswordTheme().themeData;

          await tester.pumpWidget(
            _GoldenSubject(
              themeData: themeData,
              child: IoWordInput.alphabetic(
                length: 5,
                direction: Axis.vertical,
                characters: const {0: 'A', 2: 'C'},
              ),
            ),
          );

          final subject = find.byType(IoWordInput);
          await tester.tap(subject);
          await tester.pumpAndSettle();

          await expectLater(
            subject,
            matchesGoldenFile(goldenKey('focused_vertically')),
          );
        },
      );

      testWidgets(
        'with secondary style',
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
                style: themeData.io.wordInput.secondary,
                characters: const {0: 'A', 2: 'C'},
              ),
            ),
          );

          final subject = find.byType(IoWordInput);
          await tester.tap(subject);
          await tester.pumpAndSettle();

          await expectLater(
            subject,
            matchesGoldenFile(goldenKey('secondary_style')),
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

  group('$IoWordInputTheme', () {
    test('supports value equality', () {
      final theme1 = IoWordInputTheme(
        primary: _MockIoWordInputStyle(),
        secondary: _MockIoWordInputStyle(),
      );
      final theme2 = IoWordInputTheme(
        primary: theme1.primary,
        secondary: theme1.secondary,
      );
      final theme3 = IoWordInputTheme(
        primary: _MockIoWordInputStyle(),
        secondary: _MockIoWordInputStyle(),
      );

      expect(theme1, equals(theme2));
      expect(theme1, isNot(equals(theme3)));
      expect(theme2, isNot(equals(theme3)));
    });

    test('lerps', () {
      const t = 0.5;
      final from = IoWordInputTheme(
        primary: _MockIoWordInputStyle(),
        secondary: _MockIoWordInputStyle(),
      );
      final to = IoWordInputTheme(
        primary: _MockIoWordInputStyle(),
        secondary: _MockIoWordInputStyle(),
      );

      when(() => from.primary.lerp(to.primary, t)).thenReturn(to.primary);
      when(() => from.secondary.lerp(to.secondary, t)).thenReturn(to.secondary);

      final lerp = from.lerp(to, t);

      expect(lerp.primary, equals(to.primary));
      expect(lerp.secondary, equals(to.secondary));
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
        size: Size.zero,
      );

      final to = IoWordInputCharacterFieldStyle(
        backgroundColor: const Color(0xff0000ff),
        border: Border.all(width: 2),
        borderRadius: BorderRadius.circular(2),
        textStyle: const TextStyle(color: Color(0xff0000ff)),
        size: const Size(2, 2),
        elevation: 2,
      );

      final lerp = from.lerp(to, 0.5);

      expect(lerp, isNot(equals(to)));
      expect(lerp, isNot(equals(from)));

      expect(lerp.backgroundColor, const Color(0xff007f7f));
      expect(lerp.border.top.width, 1.5);
      expect(lerp.borderRadius, BorderRadius.circular(1.5));
      expect(lerp.textStyle.color, const Color(0xff007f7f));
      expect(lerp.size, const Size(1, 1));
      expect(lerp.elevation, 1);
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
