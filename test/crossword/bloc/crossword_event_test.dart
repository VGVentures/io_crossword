// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/crossword/crossword.dart';

void main() {
  group('CrosswordEvent', () {
    group('InitialBoardLoadRequested', () {
      test('can be instantiated', () {
        expect(InitialBoardLoadRequested(), isA<InitialBoardLoadRequested>());
      });
      test('supports value comparisons', () {
        expect(InitialBoardLoadRequested(), InitialBoardLoadRequested());
      });
    });
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
  });
}
