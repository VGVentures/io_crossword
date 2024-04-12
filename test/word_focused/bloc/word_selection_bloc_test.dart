// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/word_focused/word_focused.dart';

void main() {
  group('$WordSelectionBloc', () {
    test('initial state is WordSelectionState.initial', () {
      final bloc = WordSelectionBloc();
      expect(bloc.state, equals(WordSelectionState.initial()));
    });

    blocTest<WordSelectionBloc, WordSelectionState>(
      'emits solving status when $WordSolveRequested '
      'is added',
      build: WordSelectionBloc.new,
      act: (bloc) => bloc.add(
        WordSolveRequested(wordIdentifier: '1'),
      ),
      expect: () => <WordSelectionState>[
        WordSelectionState(
          status: WordSelectionStatus.solving,
          wordIdentifier: '1',
        ),
      ],
    );

    blocTest<WordSelectionBloc, WordSelectionState>(
      'emits success status when WordFocusedSuccessRequested '
      'is added',
      build: WordSelectionBloc.new,
      act: (bloc) => bloc.add(WordFocusedSuccessRequested()),
      expect: () => <WordSelectionState>[
        WordSelectionState.initial()
            .copyWith(status: WordSelectionStatus.success),
      ],
    );
  });
}
