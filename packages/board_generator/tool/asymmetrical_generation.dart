import 'dart:io';

import 'package:board_generator/board_generator.dart';
import 'package:csv/csv.dart';

import 'model/model.dart';

void main({void Function(String) log = print}) {
  final fileString = File('words.csv').readAsStringSync();
  final rows = const CsvToListConverter().convert(fileString);

  final wordsList = rows.map((row) {
    return WordClue(
      word: (row[0] as String).replaceAll(' ', '').trim().toLowerCase(),
      clue: row[1] as String,
    );
  }).toList()
    ..removeWhere((element) => !RegExp(r'^[a-zA-Z]*$').hasMatch(element.word));

  final pool = {...wordsList.map((word) => word.word)};

  log('Sorting ${pool.length} words');
  final wordPool = WordPool(words: pool);
  log('Sorted ${pool.length} words');

  final generator = AsymmetricalCrosswordGenerator(
    pool: wordPool,
    crossword: Crossword(
      bounds: Bounds.square(size: 78),
      largestWordLength: wordPool.longestWordLength,
      shortestWordLength: wordPool.shortestWordLength,
    ),
  );

  final crossword = generator.populate();

  log('Placed words: ${crossword.words.length}');
  File('asymmetrical_crossword.txt')
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

  log('Unused words: ${notUsedWords.map((w) => w.word).toList()}');

  File('board_asymmetrical.txt')
      .writeAsStringSync(const ListToCsvConverter().convert(list));
}
