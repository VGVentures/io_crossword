import 'dart:io';

import 'package:board_generator_playground/src/crossword.dart';
import 'package:board_generator_playground/src/generators/symmetrical_crossword_generator.dart';
import 'package:board_generator_playground/src/models/models.dart';
import 'package:board_generator_playground/src/word_pool.dart';
import 'package:csv/csv.dart';

void main({
  void Function(String) log = print,
}) {
  final fileString = File('words.csv').readAsStringSync();
  final lines = const CsvToListConverter(eol: '\n').convert(fileString)
    ..removeAt(0);

  final pool = <String>{
    for (final line in lines) (line[0] as String).toLowerCase(),
  };

  log('Sorting ${pool.length} words');
  final wordPool = WordPool(words: pool);
  log('Sorted ${pool.length} words');

  final generator = SymmetricalCrosswordGenerator(
    pool: wordPool,
    crossword: Crossword(bounds: Bounds.square(size: 10000)),
  );

  final crossword = generator.populate();

  File('symmetrical_crossword.txt')
      .writeAsStringSync(crossword.toPrettyString());

  log('Finished');
}

Location _horizontallySymmetricalLocation(WordEntry wordEntry) {
  switch (wordEntry.direction) {
    case Direction.across:
      return wordEntry.start.copyWith(y: wordEntry.end.y * -1);
    case Direction.down:
      return wordEntry.end.copyWith(y: wordEntry.end.y * -1);
  }
}
