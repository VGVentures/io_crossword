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
  final positions = Queue<Location>()..add(Location.zero);

  while (placedWords < 100000) {
    if (positions.isEmpty) {
      log('No more locations to place words');
      break;
    }

    final location = positions.first;
    final words = crossword.wordsAt(location);
    if (words.any((word) => word.direction == Direction.across) &&
        words.any((word) => word.direction == Direction.down)) {
      positions.removeFirst();
      continue;
    }
    final currentDirection = words.first.direction;

    final wordCandidate = WordCandidate(
      location: location,
      direction: currentDirection == Direction.across
          ? Direction.down
          : Direction.across,
    );
    final constrainedWordCandidate = crossword.constraints(wordCandidate);
    if (constrainedWordCandidate == null) {
      positions.removeFirst();
      continue;
    }

    final candidate = wordPool.firstMatch(constrainedWordCandidate);

    if (candidate == null) {
      positions.removeFirst();
      continue;
    }

    final wordEntry = WordEntry(
      word: candidate,
      start: location,
      direction: wordCandidate.direction,
    );
    crossword.add(wordEntry);
    wordPool.remove(wordEntry.word);

    for (var i = 0; i < wordEntry.word.length; i++) {
      final position = wordEntry.direction == Direction.across
          ? wordEntry.start.shift(x: i)
          : wordEntry.start.shift(y: i);

      positions.add(position);
    }

    placedWords++;
    if (placedWords % 200 == 0) {
      log('Placed $placedWords words');
    }
  }

  File('crossword.txt').writeAsStringSync(crossword.toPrettyString());
}
