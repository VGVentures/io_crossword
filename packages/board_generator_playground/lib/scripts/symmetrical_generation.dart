import 'dart:io';

import 'package:board_generator_playground/board_generator_playground.dart';
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
    crossword: Crossword(bounds: Bounds.square(size: 2000)),
  );

  final crossword = generator.populate();

  // Creates file to see the crossword
  File('symmetrical_crossword.txt')
      .writeAsStringSync(crossword.toPrettyString());

  // Creates CSV file to be uploaded to Firestore
  final buffer = StringBuffer();
  for (final word in crossword.words) {
    final axis = word.direction == Direction.across ? 'horizontal' : 'vertical';

    buffer.writeln(
      '${word.start.x},${word.start.y},${word.word},$axis',
    );
  }

  File('board.txt').writeAsStringSync(buffer.toString());

  log('Generated a crossword with: ${crossword.words.length}');
}
