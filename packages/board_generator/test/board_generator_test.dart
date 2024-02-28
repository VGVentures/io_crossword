// ignore_for_file: prefer_const_constructors
import 'package:board_generator/board_generator.dart';
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
      var depth = 0;
      for (final crossword in generateCrosswords(wordList)) {
        depth++;
        expect(crossword.valid, true);
        expect(
          crossword.acrossWords.length + crossword.downWords.length,
          depth,
        );
        if (depth >= wordList.length) break;
      }
    });
  });
}
