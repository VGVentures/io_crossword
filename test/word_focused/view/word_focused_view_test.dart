// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_focused/word_focused.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordFocusedBloc extends MockBloc<WordFocusedEvent, WordFocusedState>
    implements WordFocusedBloc {}

class _MockCrosswordBloc extends MockBloc<CrosswordEvent, CrosswordState>
    implements CrosswordBloc {}

class _FakeWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;

  @override
  String get id => 'id';

  @override
  String get clue => 'clue';

  @override
  String get answer => 'answer';
}

void main() {
  group('WordFocusedDesktopPage', () {
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();

      widget = BlocProvider.value(
        value: crosswordBloc,
        child: WordFocusedDesktopPage(),
      );
    });

    testWidgets(
      'renders SizedBox.shrink when selectedWord is null',
      (tester) async {
        when(() => crosswordBloc.state)
            .thenReturn(CrosswordState(sectionSize: 20));

        await tester.pumpApp(widget);

        expect(find.byType(SizedBox), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordFocusedDesktopView when selectedWord is not null',
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            sectionSize: 20,
            selectedWord: selectedWord,
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordFocusedDesktopView), findsOneWidget);
      },
    );
  });

  group('WordFocusedDesktopView', () {
    late WordFocusedBloc wordFocusedBloc;
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      wordFocusedBloc = _MockWordFocusedBloc();
      crosswordBloc = _MockCrosswordBloc();

      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: wordFocusedBloc),
          BlocProvider.value(value: crosswordBloc),
        ],
        child: WordFocusedDesktopView(selectedWord),
      );
    });

    testWidgets(
      'renders WordClueDesktopView when the status is WordFocusedStatus.clue',
      (tester) async {
        when(() => wordFocusedBloc.state).thenReturn(WordFocusedState());

        await tester.pumpApp(widget);

        expect(find.byType(WordClueDesktopView), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordSolvingDesktopView when the state is '
      'WordFocusedStatus.solving',
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            sectionSize: 20,
            selectedWord: selectedWord,
          ),
        );
        when(() => wordFocusedBloc.state).thenReturn(
          WordFocusedState(status: WordFocusedStatus.solving),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordSolvingDesktopView), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordSuccessDesktopView when the state is '
      'WordFocusedStatus.success',
      (tester) async {
        tester.setDisplaySize(Size(1800, 800));
        when(() => wordFocusedBloc.state).thenReturn(
          WordFocusedState(status: WordFocusedStatus.success),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordSuccessDesktopView), findsOneWidget);
      },
    );
  });

  group('WordFocusedMobilePage', () {
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();

      widget = BlocProvider.value(
        value: crosswordBloc,
        child: WordFocusedMobilePage(),
      );
    });

    testWidgets(
      'renders SizedBox.shrink when selectedWord is null',
      (tester) async {
        when(() => crosswordBloc.state)
            .thenReturn(CrosswordState(sectionSize: 20));

        await tester.pumpApp(widget);

        expect(find.byType(SizedBox), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordFocusedMobileView when selectedWord is not null',
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            sectionSize: 20,
            selectedWord: selectedWord,
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordFocusedMobileView), findsOneWidget);
      },
    );
  });

  group('WordFocusedMobileView', () {
    late WordFocusedBloc wordFocusedBloc;
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      wordFocusedBloc = _MockWordFocusedBloc();
      crosswordBloc = _MockCrosswordBloc();

      widget = Theme(
        data: IoCrosswordTheme().themeData,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: wordFocusedBloc),
            BlocProvider.value(value: crosswordBloc),
          ],
          child: WordFocusedMobileView(selectedWord),
        ),
      );
    });

    testWidgets(
      'renders WordClueMobileView when the state is WordFocusedState.clue',
      (tester) async {
        when(() => wordFocusedBloc.state).thenReturn(WordFocusedState());

        await tester.pumpApp(widget);

        expect(find.byType(WordClueMobileView), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordSolvingMobileView when the state is '
      'WordFocusedStatus.solving',
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            sectionSize: 20,
            selectedWord: selectedWord,
          ),
        );
        when(() => wordFocusedBloc.state).thenReturn(
          WordFocusedState(status: WordFocusedStatus.solving),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordSolvingMobileView), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordSuccessMobileView when the state is '
      'WordFocusedStatus.success',
      (tester) async {
        when(() => wordFocusedBloc.state).thenReturn(
          WordFocusedState(status: WordFocusedStatus.success),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordSuccessMobileView), findsOneWidget);
      },
    );
  });
}
