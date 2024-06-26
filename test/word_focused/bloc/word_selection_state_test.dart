// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

class _FakeWord extends Fake implements Word {}

void main() {
  group('$WordSelectionState', () {
    late SelectedWord selectedWord;

    setUp(() {
      selectedWord = SelectedWord(
        word: _FakeWord(),
        section: (0, 0),
      );
    });

    test('.initial initializes correctly', () {
      final state = WordSelectionState.initial();

      expect(state.status, WordSelectionStatus.empty);
      expect(state.word, isNull);
      expect(state.wordPoints, isNull);
    });

    test('supports value equality', () {
      final state1 = WordSelectionState(
        word: selectedWord,
        status: WordSelectionStatus.preSolving,
        wordPoints: 10,
      );
      final state2 = WordSelectionState(
        word: selectedWord,
        status: WordSelectionStatus.preSolving,
        wordPoints: 10,
      );
      final state3 = WordSelectionState(
        word: SelectedWord(section: (1, 1), word: _FakeWord()),
        status: WordSelectionStatus.solving,
        wordPoints: 20,
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
      expect(state2, isNot(equals(state3)));
    });

    group('copyWith', () {
      test('does nothing when no parameters are specified', () {
        final state = WordSelectionState(
          word: selectedWord,
          status: WordSelectionStatus.preSolving,
          wordPoints: 10,
        );

        final copy = state.copyWith();

        expect(copy, equals(state));
      });

      test('copies specified parameters', () {
        final state = WordSelectionState(
          word: selectedWord,
          status: WordSelectionStatus.preSolving,
          wordPoints: 10,
        );
        final newState = WordSelectionState(
          word: SelectedWord(section: (1, 1), word: _FakeWord()),
          status: WordSelectionStatus.solved,
          wordPoints: 20,
        );

        final copy = state.copyWith(
          word: newState.word,
          status: newState.status,
          wordPoints: newState.wordPoints,
        );

        expect(copy, equals(newState));
      });
    });
  });

  group('$SelectedWord', () {
    test('supports value equality', () {
      final word1 = SelectedWord(
        word: _FakeWord(),
        section: (0, 0),
      );
      final word2 = SelectedWord(
        word: word1.word,
        section: (0, 0),
      );
      final word3 = SelectedWord(
        word: _FakeWord(),
        section: (1, 1),
      );

      expect(word1, equals(word2));
      expect(word1, isNot(equals(word3)));
      expect(word2, isNot(equals(word3)));
    });

    group('copyWith', () {
      test('does nothing when no parameters are specified', () {
        final word = SelectedWord(
          word: _FakeWord(),
          section: (0, 0),
        );

        final copy = word.copyWith();

        expect(copy, equals(word));
      });

      test('copies specified parameters', () {
        final word = SelectedWord(
          word: _FakeWord(),
          section: (0, 0),
        );
        final newWord = SelectedWord(
          word: _FakeWord(),
          section: (1, 1),
        );

        final copy = word.copyWith(
          word: newWord.word,
          section: newWord.section,
        );

        expect(copy, equals(newWord));
      });
    });
  });
}
