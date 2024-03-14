// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:game_domain/game_domain.dart';
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
  });
}
