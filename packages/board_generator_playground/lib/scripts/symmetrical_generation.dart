import 'dart:io';

import 'package:board_generator_playground/board_generator_playground.dart';
import 'package:csv/csv.dart';
import 'package:equatable/equatable.dart';

class _WordClue extends Equatable {
  const _WordClue({
    required this.word,
    required this.clue,
  });

  final String word;
  final String clue;

  @override
  List<Object?> get props => [word, clue];
}

void main({
  void Function(String) log = print,
}) {
  final fileString = File('words.csv').readAsStringSync();
  final rows = const CsvToListConverter().convert(fileString);

  final wordsList = rows.map((row) {
    return _WordClue(
      word: (row[0] as String).replaceAll(' ', '').trim().toLowerCase(),
      clue: row[2] as String,
    );
  }).toList()
    ..removeWhere((element) => !RegExp(r'^[a-zA-Z]*$').hasMatch(element.word));

  final pool = wordsList.map((word) => word.word);

  log('Sorting ${pool.length} words');
  final wordPool = WordPool(words: pool);
  log('Sorted ${pool.length} words');

  final generator = SymmetricalCrosswordGenerator(
    pool: wordPool,
    crossword: Crossword(
      bounds: Bounds.square(size: 320),
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
  final list = <List<dynamic>>[];

  for (final word in crossword.words) {
    final axis = word.direction == Direction.across ? 'horizontal' : 'vertical';

    final clue = wordsList.firstWhere((w) => w.word == word.word).clue;

    list.add([word.start.x, word.start.y, word.word, clue, axis]);
  }

  File('board.txt').writeAsStringSync(const ListToCsvConverter().convert(list));
}
