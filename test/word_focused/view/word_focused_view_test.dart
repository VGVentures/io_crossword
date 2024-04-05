// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_focused/word_focused.dart';
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
}

void main() {
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
      'renders WordClueDesktopView when the state is WordFocusedState.clue',
      (tester) async {
        when(() => wordFocusedBloc.state).thenReturn(WordFocusedState.clue);

        await tester.pumpApp(widget);

        expect(find.byType(WordClueDesktopView), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordSolvingDesktopView when the state is '
      'WordFocusedState.solving',
      (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordLoaded(
            sectionSize: 20,
            selectedWord: selectedWord,
          ),
        );
        when(() => wordFocusedBloc.state).thenReturn(WordFocusedState.solving);

        await tester.pumpApp(widget);

        expect(find.byType(WordSolvingDesktopView), findsOneWidget);
      },
    );

    testWidgets(
      'renders WordSuccessDesktopView when the state is '
      'WordFocusedState.success',
      (tester) async {
        when(() => wordFocusedBloc.state).thenReturn(WordFocusedState.success);

        await tester.pumpApp(widget);

        expect(find.byType(WordSuccessDesktopView), findsOneWidget);
      },
    );
  });
}
