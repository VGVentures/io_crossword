// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:board_generator/src/board_generator.dart';
import 'package:test/test.dart';

void main() {
  const wordList = [
    'winter',
    'spring',
    'summer',
    'autumn',
    'interesting',
    'fascinating',
    'amazing',
    'wonderful',
    'beautiful',
    'gorgeous',
    'stunning',
    'breathtaking',
    'spectacular',
    'magnificent',
    'incredible',
  ];

  group('BoardGenerator', () {
    test('generate crosswords', () {
      final crossword = generateCrossword(wordList, 'test-board.txt');

      final size = crossword.acrossWords.length + crossword.downWords.length;
      expect(size, wordList.length);

      File('test-board.txt').deleteSync();
    });
  });
}
