// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:io_crossword/word_selection/word_selection.dart';

void main() {
  group('CrosswordEvent', () {
    group('$BoardLoadingInformationRequested', () {
      test('can be instantiated', () {
        expect(
          BoardLoadingInformationRequested(),
          isA<BoardLoadingInformationRequested>(),
        );
      });

      test('supports value comparisons', () {
        expect(
          BoardLoadingInformationRequested(),
          equals(BoardLoadingInformationRequested()),
        );
      });
    });

    group('BoardStatusPaused', () {
      test('can be instantiated', () {
        expect(BoardStatusPaused(), isA<BoardStatusPaused>());
      });

      test('supports value comparisons', () {
        expect(BoardStatusPaused(), equals(BoardStatusPaused()));
      });
    });

    group('BoardStatusResumed', () {
      test('can be instantiated', () {
        expect(BoardStatusResumed(), isA<BoardStatusResumed>());
      });

      test('supports value comparisons', () {
        expect(BoardStatusResumed(), equals(BoardStatusResumed()));
      });
    });

    group('MascotDropped', () {
      test('can be instantiated', () {
        expect(MascotDropped(), isA<MascotDropped>());
      });

      test('supports value comparisons', () {
        expect(MascotDropped(), equals(MascotDropped()));
      });
    });

    group('CrosswordSelectionsLoaded', () {
      final selectedWord = SelectedWord(
        section: (0, 0),
        word: Word(
          id: 'id',
          position: Point(0, 0),
          axis: WordAxis.horizontal,
          clue: 'clue',
          answer: 'answer',
        ),
      );

      test('can be instantiated', () {
        expect(
          CrosswordSectionsLoaded(selectedWord),
          isA<CrosswordSectionsLoaded>(),
        );
      });

      test('supports value comparisons', () {
        expect(
          CrosswordSectionsLoaded(selectedWord),
          equals(
            CrosswordSectionsLoaded(selectedWord),
          ),
        );
      });
    });
  });
}
