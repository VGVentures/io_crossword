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

    group('BoardSectionLoaded', () {
      final boardSection = BoardSection(
        id: 'id',
        position: Point(1, 1),
        size: 20,
        words: [],
        borderWords: [],
      );
      test('can be instantiated', () {
        expect(BoardSectionLoaded(boardSection), isA<BoardSectionLoaded>());
      });
      test('supports value comparisons', () {
        expect(
          BoardSectionLoaded(boardSection),
          BoardSectionLoaded(boardSection),
        );
        expect(
          BoardSectionLoaded(boardSection),
          isNot(
            BoardSectionLoaded(
              boardSection.copyWith(id: 'differentId'),
            ),
          ),
        );
      });
    });

    group('VisibleSectionsCleaned', () {
      test('can be instantiated', () {
        expect(VisibleSectionsCleaned({(1, 1)}), isA<VisibleSectionsCleaned>());
      });
      test('supports value comparisons', () {
        expect(
          VisibleSectionsCleaned({(1, 1)}),
          VisibleSectionsCleaned({(1, 1)}),
        );
        expect(
          VisibleSectionsCleaned({(1, 1)}),
          isNot(
            VisibleSectionsCleaned(
              {(1, 2)},
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
  });
}
