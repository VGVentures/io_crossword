import 'dart:collection';
import 'dart:io';

import 'package:board_generator_playground/src/crossword.dart';
import 'package:board_generator_playground/src/models/models.dart';
import 'package:board_generator_playground/src/word_pool.dart';
import 'package:csv/csv.dart';

void main({
  void Function(String) log = print,
}) {
  final fileString = File('words.csv').readAsStringSync();
  final lines = const CsvToListConverter(eol: '\n').convert(fileString)
    ..removeAt(0);

  final pool = <String>{for (final line in lines) line[0] as String};
  log('Sorting ${pool.length} words');
  final wordPool = WordPool(words: pool);
  log('Sorted ${pool.length} words');

  final initialWorld = wordPool.firstMatch(
    ConstrainedWordCandidate(
      invalidLengths: {
        for (int i = 2; i <= wordPool.longestWordLength; i += 2) i,
      },
      location: Location.zero,
      direction: Direction.down,
      constraints: const {0: 'a'},
    ),
  )!;

  log('Initial word: $initialWorld');

  final crossword = Crossword()
    ..add(
      WordEntry(
        word: initialWorld,
        start: Location(x: 0, y: 0 - (initialWorld.length ~/ 2)),
        direction: Direction.down,
      ),
    );

  var placedWords = 0;

  final bottomPositions = Queue<Location>()
    ..add(
      const Location(x: 0, y: 1),
    );

  while (placedWords < 2) {
    if (bottomPositions.isEmpty) {
      log('No more locations to place words');
      break;
    }

    final location = bottomPositions.first;
    final words = crossword.wordsAt(location);
    if (words.any((word) => word.direction == Direction.across) &&
        words.any((word) => word.direction == Direction.down)) {
      bottomPositions.removeFirst();
      continue;
    }

    final wordCandidate = WordCandidate(
      location: location,
      direction: words.first.direction == Direction.across
          ? Direction.down
          : Direction.across,
    );
    final constrainedWordCandidate = crossword.constraints(wordCandidate);
    if (constrainedWordCandidate == null) {
      if (bottomPositions.isNotEmpty) bottomPositions.removeFirst();
      continue;
    }
    final candidate = wordPool.firstMatch(constrainedWordCandidate);
    if (candidate == null) {
      if (bottomPositions.isNotEmpty) bottomPositions.removeFirst();
      continue;
    }
    final wordEntry = WordEntry(
      word: candidate,
      start: location,
      direction: wordCandidate.direction,
    );

    final wordCandidate2 = WordCandidate(
      location: _horizontallySymmetricalLocation(wordEntry),
      direction: wordCandidate.direction,
    );
    final constrainedWordCandidate2 = crossword.constraints(wordCandidate2);
    if (constrainedWordCandidate2 == null) {
      if (bottomPositions.isNotEmpty) bottomPositions.removeFirst();
      continue;
    }
    final candidate2 = wordPool.firstMatch(constrainedWordCandidate2);
    if (candidate2 == null) {
      if (bottomPositions.isNotEmpty) bottomPositions.removeFirst();
      continue;
    }
    final wordEntry2 = WordEntry(
      word: candidate2,
      start: wordCandidate2.location,
      direction: wordCandidate2.direction,
    );

    crossword
      ..add(wordEntry)
      ..add(wordEntry2);
    wordPool
      ..remove(wordEntry.word)
      ..remove(wordEntry2.word);

    for (var i = 0; i < wordEntry.word.length; i++) {
      final position = wordEntry.direction == Direction.across
          ? wordEntry.start.shift(x: i)
          : wordEntry.start.shift(y: i);

      bottomPositions.add(position);
    }

    placedWords++;
    if (placedWords % 200 == 0) {
      log('Placed $placedWords words');
    }
  }

  File('crossword.txt').writeAsStringSync(crossword.toPrettyString());
}

Location _horizontallySymmetricalLocation(WordEntry wordEntry) {
  switch (wordEntry.direction) {
    case Direction.across:
      return wordEntry.start.copyWith(y: wordEntry.end.y * -1);
    case Direction.down:
      return wordEntry.end.copyWith(y: wordEntry.end.y * -1);
  }
}
