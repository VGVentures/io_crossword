// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:io_crossword_ui/io_crossword_ui.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

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
  group('$WordSelectionView', () {
    testWidgets(
      'renders WordFocusedDesktopPage when layout is large',
      (tester) async {
        await tester.pumpApp(
          IoLayout(
            data: IoLayoutData.large,
            child: WordSelectionView(),
          ),
        );

        expect(find.byType(WordFocusedDesktopPage), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordFocusedMobilePage when layout is small',
      (tester) async {
        await tester.pumpApp(
          IoLayout(
            data: IoLayoutData.small,
            child: WordSelectionView(),
          ),
        );

        expect(find.byType(WordFocusedMobilePage), findsOneWidget);
      },
    );
  });

  group('WordFocusedDesktopPage', () {
    late CrosswordBloc crosswordBloc;
    late WordSelectionBloc wordSelectionBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      wordSelectionBloc = _MockWordSelectionBloc();

      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: crosswordBloc,
          ),
          BlocProvider.value(
            value: wordSelectionBloc,
          ),
        ],
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
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            wordIdentifier: '1',
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordFocusedDesktopView), findsOneWidget);
      },
    );
  });

  group('WordFocusedDesktopView', () {
    late WordSelectionBloc wordSelectionBloc;
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      crosswordBloc = _MockCrosswordBloc();

      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: wordSelectionBloc),
          BlocProvider.value(value: crosswordBloc),
        ],
        child: WordFocusedDesktopView(selectedWord),
      );
    });

    testWidgets(
      'renders WordClueDesktopView when the status is WordSelectionStatus.clue',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(status: WordSelectionStatus.preSolving),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordClueDesktopView), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordSolvingDesktopView when the status is '
      'WordSelectionStatus.solving',
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            sectionSize: 20,
            selectedWord: selectedWord,
          ),
        );
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solving,
            wordIdentifier: '1',
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordSolvingDesktopView), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordSuccessDesktopView when the status is '
      'WordSelectionStatus.success',
      (tester) async {
        tester.setDisplaySize(Size(1800, 800));
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solved,
            wordIdentifier: '1',
            wordPoints: 10,
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordSuccessDesktopView), findsOneWidget);
      },
    );
  });

  group('WordFocusedMobilePage', () {
    late CrosswordBloc crosswordBloc;
    late WordSelectionBloc wordSelectionBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      crosswordBloc = _MockCrosswordBloc();
      wordSelectionBloc = _MockWordSelectionBloc();

      widget = MultiBlocProvider(
        providers: [
          BlocProvider.value(value: crosswordBloc),
          BlocProvider.value(value: wordSelectionBloc),
        ],
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
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.preSolving,
            wordIdentifier: '1',
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordFocusedMobileView), findsOneWidget);
      },
    );
  });

  group('WordFocusedMobileView', () {
    late WordSelectionBloc wordSelectionBloc;
    late CrosswordBloc crosswordBloc;
    late Widget widget;

    final selectedWord = WordSelection(section: (0, 0), word: _FakeWord());

    setUp(() {
      wordSelectionBloc = _MockWordSelectionBloc();
      crosswordBloc = _MockCrosswordBloc();

      widget = Theme(
        data: IoCrosswordTheme().themeData,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: wordSelectionBloc),
            BlocProvider.value(value: crosswordBloc),
          ],
          child: WordFocusedMobileView(selectedWord),
        ),
      );
    });

    testWidgets(
      'renders WordClueMobileView when the status is WordSelectionStatus.clue',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(status: WordSelectionStatus.preSolving),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordClueMobileView), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordSolvingMobileView when the state is '
      'WordSelectionStatus.solving',
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            sectionSize: 20,
            selectedWord: selectedWord,
          ),
        );
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solving,
            wordIdentifier: '1',
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordSolvingMobileView), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordSuccessMobileView when the state is '
      'WordSelectionStatus.success',
      (tester) async {
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solved,
            wordIdentifier: '1',
            wordPoints: 10,
          ),
        );

        await tester.pumpApp(widget);

        expect(find.byType(WordSuccessMobileView), findsOneWidget);
      },
    );
  });
}
