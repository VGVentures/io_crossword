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

    group('RenderModeSwitched', () {
      test('can be instantiated', () {
        expect(RenderModeSwitched(RenderMode.game), isA<RenderModeSwitched>());
      });
      test('supports value comparisons', () {
        expect(
          RenderModeSwitched(RenderMode.game),
          RenderModeSwitched(RenderMode.game),
        );
        expect(
          RenderModeSwitched(RenderMode.game),
          isNot(
            RenderModeSwitched(RenderMode.snapshot),
          ),
        );
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
        expect(BoardLoadingInfoFetched(), isA<BoardLoadingInfoFetched>());
      });

      test('supports value comparisons', () {
        expect(
          BoardLoadingInfoFetched(),
          equals(BoardLoadingInfoFetched()),
        );
      });
    });

    group('InitialsSelected', () {
      test('can be instantiated', () {
        expect(InitialsSelected(['W', 'O', 'W']), isA<InitialsSelected>());
      });

      test('supports value comparisons', () {
        expect(
          InitialsSelected(['W', 'O', 'W']),
          equals(InitialsSelected(['W', 'O', 'W'])),
        );
        expect(
          InitialsSelected(['W', 'O', 'W']),
          isNot(equals(InitialsSelected(['G', 'G', 'G']))),
        );
      });
    });
  });
}
