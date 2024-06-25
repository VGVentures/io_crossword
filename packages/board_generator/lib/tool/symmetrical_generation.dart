import 'dart:io';

import 'package:board_generator/board_generator.dart';
import 'package:board_generator/tool/model/model.dart';
import 'package:csv/csv.dart';

void main({
  void Function(String) log = print,
}) {
  final fileString = File('words.csv').readAsStringSync();
  final rows = const CsvToListConverter().convert(fileString);

  final wordsList = rows.map((row) {
    return WordClue(
      word: (row[0] as String).replaceAll(' ', '').trim().toLowerCase(),
      clue: row[1] as String,
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
      bounds: Bounds.square(size: 93),
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
  final wordsString = <String>{};

  for (final word in crossword.words) {
    final axis = word.direction == Direction.across ? 'horizontal' : 'vertical';

    final clue = wordsList.firstWhere((w) => w.word == word.word).clue;

    list.add([word.start.x, word.start.y, word.word, clue, axis]);

    wordsString.add(word.word);
  }

  final notUsedWords = wordsList.where((w) => !wordsString.contains(w.word));

  log('Unused words: ${notUsedWords.length}');

  File('board.txt').writeAsStringSync(const ListToCsvConverter().convert(list));
}
