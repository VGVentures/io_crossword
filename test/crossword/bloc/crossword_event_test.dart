// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
import 'package:io_crossword/crossword/bloc/crossword_bloc.dart';
import 'package:io_crossword/crossword/crossword.dart';
import 'package:mocktail/mocktail.dart';

class _MockWord extends Mock implements Word {}

void main() {
  group('CrosswordEvent', () {
    group('BoardSectionRequested', () {
      test('can be instantiated', () {
        expect(BoardSectionRequested((1, 1)), isA<BoardSectionRequested>());
      });
      test('supports value comparisons', () {
        expect(BoardSectionRequested((1, 1)), BoardSectionRequested((1, 1)));
        expect(
          BoardSectionRequested((1, 1)),
          isNot(
            BoardSectionRequested(
              (1, 2),
            ),
          ),
        );
      });
    });

    group('WordSelected', () {
      test('can be instantiated', () {
        expect(WordSelected((0, 0), _MockWord()), isA<WordSelected>());
      });

      test('supports value comparisons', () {
        final firstWord = _MockWord();
        final secondWord = _MockWord();

        expect(
          WordSelected((0, 0), firstWord),
          equals(WordSelected((0, 0), firstWord)),
        );
        expect(
          WordSelected((0, 0), firstWord),
          isNot(
            WordSelected((0, 0), secondWord),
          ),
        );
        expect(
          WordSelected((0, 0), firstWord),
          isNot(
            WordSelected((0, 1), firstWord),
          ),
        );
      });
    });

    group('WordUnselected', () {
      test('can be instantiated', () {
        expect(WordUnselected(), isA<WordUnselected>());
      });

      test('supports value comparisons', () {
        expect(WordUnselected(), equals(WordUnselected()));
      });
    });

    group('MascotSelected', () {
      test('can be instantiated', () {
        expect(MascotSelected(Mascots.sparky), isA<MascotSelected>());
      });

      test('supports value comparisons', () {
        expect(
          MascotSelected(Mascots.sparky),
          equals(MascotSelected(Mascots.sparky)),
        );
        expect(
          MascotSelected(Mascots.sparky),
          isNot(equals(MascotSelected(Mascots.dash))),
        );
      });
    });

    group('BoardLoadingInfoFetched', () {
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

    group('InitialsSelected', () {
      test('can be instantiated', () {
        expect(InitialsSelected('WOW'), isA<InitialsSelected>());
      });

      test('supports value comparisons', () {
        expect(
          InitialsSelected('WOW'),
          equals(InitialsSelected('WOW')),
        );
        expect(
          InitialsSelected('WOW'),
          isNot(equals(InitialsSelected('GGG'))),
        );
      });
    });

    group('AnswerUpdated', () {
      test('can be instantiated', () {
        expect(AnswerUpdated('answer'), isA<AnswerUpdated>());
      });

      test('supports value comparisons', () {
        expect(
          AnswerUpdated('answer'),
          equals(AnswerUpdated('answer')),
        );
        expect(
          AnswerUpdated('answer'),
          isNot(equals(AnswerUpdated('word'))),
        );
      });
    });

    group('AnswerSubmitted', () {
      test('can be instantiated', () {
        expect(AnswerSubmitted(), isA<AnswerSubmitted>());
      });

      test('supports value comparisons', () {
        expect(
          AnswerSubmitted(),
          equals(AnswerSubmitted()),
        );
      });
    });
  });
}
