// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart' hide Axis;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/crossword/view/word_focused_view.dart';
import 'package:io_crossword/l10n/l10n.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _FakeWord extends Fake implements Word {
  @override
  String get id => 'id';

  @override
  String get clue => 'clue';

  @override
  Axis get axis => Axis.horizontal;

  @override
  int? get solvedTimestamp => null;

  @override
  String get answer => 'answer';
}

void main() {
  group('WordFocusedView', () {
    late AppLocalizations l10n;

    setUpAll(() async {
      l10n = await AppLocalizations.delegate.load(Locale('en'));
    });

    group('WordFocusedDesktopView', () {
      late CrosswordBloc crosswordBloc;
      late Widget widget;

      setUp(() {
        crosswordBloc = _MockCrosswordBloc();

        widget = Scaffold(
          body: BlocProvider.value(
            value: crosswordBloc,
            child: WordFocusedDesktopView(),
          ),
        );
      });

      testWidgets(
        'renders an empty SizedBox when the selected word is null',
        (tester) async {
          when(() => crosswordBloc.state).thenReturn(
            CrosswordLoaded(
              sectionSize: 20,
              selectedWord: null,
            ),
          );
          await tester.pumpApp(widget);

          final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));

          expect(find.byType(SizedBox), findsOneWidget);
          expect(sizedBox.child, isNull);
        },
      );

      testWidgets(
        'renders a WordFocusedDesktopView when the selected word is not null',
        (tester) async {
          when(() => crosswordBloc.state).thenReturn(
            CrosswordLoaded(
              sectionSize: 20,
              selectedWord: WordSelection(section: (0, 0), word: _FakeWord()),
            ),
          );
          await tester.pumpApp(widget);

          expect(find.byType(WordFocusedDesktopView), findsOneWidget);
        },
      );
    });

    group('WordFocusedDesktopBody', () {
      late CrosswordBloc crosswordBloc;
      late Widget widget;

      setUp(() {
        crosswordBloc = _MockCrosswordBloc();

        widget = Scaffold(
          body: BlocProvider.value(
            value: crosswordBloc,
            child: WordFocusedDesktopBody(
              WordSelection(section: (0, 0), word: _FakeWord()),
            ),
          ),
        );
      });

      testWidgets(
        'renders the clue text',
        (tester) async {
          await tester.pumpApp(widget);

          final clueText = _FakeWord().clue;
          expect(find.text(clueText), findsOneWidget);
        },
      );

      testWidgets(
        'tapping the close button sends WordUnselected event',
        (tester) async {
          await tester.pumpApp(widget);

          final closeButton = find.byIcon(Icons.cancel);
          await tester.tap(closeButton);

          verify(() => crosswordBloc.add(const WordUnselected())).called(1);
        },
      );

      testWidgets(
        'tapping the submit button sends AnswerSubmitted event',
        (tester) async {
          await tester.pumpApp(widget);

          final submitButton = find.text(l10n.submit);
          await tester.tap(submitButton);

          verify(() => crosswordBloc.add(const AnswerSubmitted())).called(1);
        },
      );
    });

    group('WordFocusedMobileView', () {
      late CrosswordBloc crosswordBloc;
      late Widget widget;

      setUp(() {
        crosswordBloc = _MockCrosswordBloc();
        final state = CrosswordLoaded(
          sectionSize: 20,
          selectedWord: WordSelection(section: (0, 0), word: _FakeWord()),
        );
        when(() => crosswordBloc.state).thenReturn(state);

        widget = Scaffold(
          body: BlocProvider.value(
            value: crosswordBloc,
            child: WordFocusedMobileView(
              WordSelection(section: (0, 0), word: _FakeWord()),
            ),
          ),
        );
      });

      testWidgets(
        'add AnswerUpdated event when user enters all the letters',
        (tester) async {
          await tester.pumpApp(widget);

          final answerField = find.byType(TextField);

          await tester.enterText(answerField, 'answer');
          verify(
            () => crosswordBloc.add(const AnswerUpdated('answer')),
          ).called(1);
        },
      );

      testWidgets(
        'tap the submit button sends AnswerSubmitted event',
        (tester) async {
          await tester.pumpApp(widget);

          final submitButton = find.text(l10n.submit);
          await tester.tap(submitButton);
          verify(() => crosswordBloc.add(const AnswerSubmitted())).called(1);
        },
      );
    });
  });
}
