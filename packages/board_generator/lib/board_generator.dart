import 'dart:collection';

import 'package:board_generator/models/data_model.dart';

/// Generates a crossword.
Iterable<Crossword> generateCrosswords(List<String> wordList) sync* {
  final queue = Queue<Iterator<Crossword>>()
    ..addFirst(
      Crossword(
        (b) => b..candidates.addAll(wordList),
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
