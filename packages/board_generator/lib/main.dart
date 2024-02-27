import 'dart:collection';

import 'package:board_generator/models/data_model.dart';

void main(List<String> args) {
  final iter = generateCrosswords();
  final completeCrossword = iter.last;

  // ignore: avoid_print
  print(completeCrossword);
}

/// The list of all words that can be used to generate a crossword.
final allWords = [
  'winter',
  'spring',
  'summer',
];

/// Generates a crossword.
Iterable<Crossword> generateCrosswords() sync* {
  final queue = Queue<Iterator<Crossword>>()
    ..addFirst(
      Crossword(
        (b) => b..candidates.addAll(allWords),
      ).generate().iterator,
    );

  while (queue.isNotEmpty) {
    final iterator = queue.removeFirst();
    if (iterator.moveNext()) {
      final crossword = iterator.current;
      yield crossword;
      queue
        ..addFirst(iterator)
        ..addFirst(crossword.generate().iterator);
    }
  }
}
