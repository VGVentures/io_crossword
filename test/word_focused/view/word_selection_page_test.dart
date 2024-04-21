// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/word_selection/word_selection.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockWordSelectionBloc
    extends MockBloc<WordSelectionEvent, WordSelectionState>
    implements WordSelectionBloc {}

class _MockHintResource extends Mock implements HintResource {}

class _FakeWord extends Fake implements Word {
  @override
  int? get solvedTimestamp => null;

  @override
  String get id => 'id';

  @override
  String get clue => 'clue';

  @override
  String? get answer => 'ant';

  @override
  int get length => 3;
}

void main() {
  group('$WordSelectionPage', () {
    group('renders', () {
      late WordSelectionBloc wordSelectionBloc;
      late SelectedWord selectedWord;

      setUp(() {
        wordSelectionBloc = _MockWordSelectionBloc();
        selectedWord = SelectedWord(section: (0, 0), word: _FakeWord());
      });

      testWidgets(
        'SizedBox when there is no selected word',
        (tester) async {
          when(() => wordSelectionBloc.state)
              .thenReturn(WordSelectionState.initial());

          await tester.pumpApp(
            BlocProvider(
              create: (_) => wordSelectionBloc,
              child: WordSelectionPage(),
            ),
          );

          expect(find.byType(SizedBox), findsOneWidget);
        },
      );

      testWidgets(
        '$WordSelectionView when there is a selected word',
        (tester) async {
          final hintResource = _MockHintResource();
          when(() => hintResource.getHints(wordId: any(named: 'wordId')))
              .thenAnswer((_) async => []);
          when(() => wordSelectionBloc.state).thenReturn(
            WordSelectionState(
              status: WordSelectionStatus.preSolving,
              word: selectedWord,
            ),
          );

          await tester.pumpApp(
            BlocProvider(
              create: (_) => wordSelectionBloc,
              child: WordSelectionPage(),
            ),
            hintResource: hintResource,
          );

          expect(find.byType(WordSelectionView), findsOneWidget);
        },
      );
    });
  });
}
