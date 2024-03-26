import 'dart:io';

import 'package:board_generator_playground/board_generator_playground.dart';
import 'package:csv/csv.dart';

void main({void Function(String) log = print}) {
  final fileString = File('words.csv').readAsStringSync();
  final lines = const CsvToListConverter(eol: '\n').convert(fileString)
    ..removeAt(0);

  final pool = <String>{
    for (final line in lines) (line[0] as String).toLowerCase(),
  };
  final wordPool = WordPool(words: pool);

  final generator = AsymmetricalCrosswordGenerator(
    pool: wordPool,
    crossword: Crossword(bounds: Bounds.square(size: 100)),
  );

  final crossword = generator.populate();
  File('asymmetrical_crossword.txt')
      .writeAsStringSync(crossword.toPrettyString());
}
