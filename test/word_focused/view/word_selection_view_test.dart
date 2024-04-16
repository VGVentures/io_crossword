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
  String get answer => 'ant';
}

void main() {
  group('$WordSelectionView', () {
    group('renders', () {
      late CrosswordBloc crosswordBloc;
      late WordSelectionBloc wordSelectionBloc;
      late WordSelection selectedWord;

      setUp(() {
        crosswordBloc = _MockCrosswordBloc();
        wordSelectionBloc = _MockWordSelectionBloc();
        selectedWord = WordSelection(section: (0, 0), word: _FakeWord());
      });

      testWidgets('SizedBox when there is no selected word', (tester) async {
        when(() => crosswordBloc.state)
            .thenReturn(CrosswordState(sectionSize: 20));

        await tester.pumpApp(
          crosswordBloc: crosswordBloc,
          WordSelectionView(),
        );

        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets(
        '$WordSelectionLargeContainer when layout is large',
        (tester) async {
          when(() => crosswordBloc.state).thenReturn(
            CrosswordState(
              sectionSize: 20,
              selectedWord: selectedWord,
            ),
          );
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(status: WordSelectionStatus.preSolving),
          );

          await tester.pumpApp(
            layout: IoLayoutData.large,
            crosswordBloc: crosswordBloc,
            BlocProvider(
              create: (_) => wordSelectionBloc,
              child: WordSelectionView(),
            ),
          );

          expect(find.byType(WordSelectionLargeContainer), findsOneWidget);
        },
      );

      testWidgets(
        '$WordSelectionSmallContainer when layout is small',
        (tester) async {
          when(() => crosswordBloc.state).thenReturn(
            CrosswordState(
              sectionSize: 20,
              selectedWord: selectedWord,
            ),
          );
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(status: WordSelectionStatus.preSolving),
          );

          await tester.pumpApp(
            layout: IoLayoutData.small,
            crosswordBloc: crosswordBloc,
            BlocProvider(
              create: (_) => wordSelectionBloc,
              child: WordSelectionView(),
            ),
          );

          expect(find.byType(WordSelectionSmallContainer), findsOneWidget);
        },
      );

      testWidgets('$WordPreSolvingView when status is preSolving',
          (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            sectionSize: 20,
            selectedWord: selectedWord,
          ),
        );
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(status: WordSelectionStatus.preSolving),
        );

        await tester.pumpApp(
          crosswordBloc: crosswordBloc,
          BlocProvider(
            create: (_) => wordSelectionBloc,
            child: WordSelectionView(),
          ),
        );

        expect(find.byType(WordPreSolvingView), findsOneWidget);
      });

      testWidgets('$WordSolvingView when status is solving', (tester) async {
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

        await tester.pumpApp(
          crosswordBloc: crosswordBloc,
          BlocProvider(
            create: (_) => wordSelectionBloc,
            child: WordSelectionView(),
          ),
        );

        expect(find.byType(WordSolvingView), findsOneWidget);
      });

      testWidgets('$WordSuccessView when status is solved', (tester) async {
        when(() => crosswordBloc.state).thenReturn(
          CrosswordState(
            sectionSize: 20,
            selectedWord: selectedWord,
          ),
        );
        when(() => wordSelectionBloc.state).thenReturn(
          WordSelectionState(
            status: WordSelectionStatus.solved,
            wordIdentifier: '1',
            wordPoints: 10,
          ),
        );

        await tester.pumpApp(
          crosswordBloc: crosswordBloc,
          BlocProvider(
            create: (_) => wordSelectionBloc,
            child: WordSelectionView(),
          ),
        );

        expect(find.byType(WordSuccessView), findsOneWidget);
      });
    });
  });
}
