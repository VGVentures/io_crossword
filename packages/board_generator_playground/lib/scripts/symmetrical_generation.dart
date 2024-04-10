import 'dart:io';

import 'package:board_generator_playground/board_generator_playground.dart';

void main({
  void Function(String) log = print,
}) {
  final fileString = File('words_final.csv');
  final pool = fileString
      .readAsLinesSync()
      .map(
        (line) => line.replaceAll(' ', '').trim().toLowerCase(),
      )
      .toList();

  log('Sorting ${pool.length} words');
  final wordPool = WordPool(words: pool);
  log('Sorted ${pool.length} words');

  final generator = SymmetricalCrosswordGenerator(
    pool: wordPool,
    crossword: Crossword(
      bounds: Bounds.square(size: 900),
      largestWordLength: wordPool.longestWordLength,
      shortestWordLength: wordPool.shortestWordLength,
    ),
  );

  final stopwatch = Stopwatch()..start();
  final crossword = generator.populate();
  stopwatch.stop();

  log('Elapsed time: ${stopwatch.elapsed.inSeconds} seconds');
  log('Generated a crossword with: ${crossword.words.length}');

  // Creates file to see the crossword
  File('symmetrical_crossword.txt')
      .writeAsStringSync(crossword.toPrettyString());

  // Creates CSV file representing the crossword.
  final buffer = StringBuffer();
  for (final word in crossword.words) {
    final axis = word.direction == Direction.across ? 'horizontal' : 'vertical';

    buffer.writeln(
      '${word.start.x},${word.start.y},${word.word},$axis',
    );
  }

  File('board.txt').writeAsStringSync(buffer.toString());
}
