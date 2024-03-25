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

  final pool = <String>{
    for (final line in lines) (line[0] as String).toLowerCase(),
  };
  log('Sorting ${pool.length} words');
  final wordPool = WordPool(words: pool);
  log('Sorted ${pool.length} words');

  final initialWorld = wordPool.firstMatch(
    ConstrainedWordCandidate(
      invalidLengths: {
        for (int i = 2; i <= wordPool.longestWordLength; i += 2) i,
      },
      start: Location.zero,
      direction: Direction.down,
      constraints: const {0: 'a'},
    ),
  )!;
  log('Initial word: $initialWorld');

  final initialWordEntry = WordEntry(
    word: initialWorld,
    start: Location(x: 0, y: 0 - (initialWorld.length ~/ 2)),
    direction: Direction.down,
  );
  final crossword = Crossword(
    bounds: Bounds.square(size: 100),
  )..add(initialWordEntry);

  var placedWords = 0;

  final closed = <WordCandidate>{};

  final frontier = Queue<WordCandidate>()
    ..addAll(
      {
        for (final location in initialWordEntry.start.to(initialWordEntry.end))
          WordCandidate(
            start: location,
            direction: initialWordEntry.direction == Direction.across
                ? Direction.down
                : Direction.across,
          ),
      },
    );

  while (frontier.isNotEmpty && placedWords < 1000) {
    final candidate = frontier.removeFirst();
    closed.add(candidate);

    if (crossword.crossesAt(candidate.start)) {
      continue;
    }

    final wordCandidate = WordCandidate(
      start: candidate.start,
      direction: candidate.direction,
    );
    final constraints = crossword.constraints(wordCandidate);
    if (constraints == null) continue;

    final word = wordPool.firstMatch(constraints);
    if (word == null) continue;

    if (!constraints.satisfies(word)) {
      log('Invalid candidate: $candidate');
      continue;
    }

    final wordEntry = WordEntry(
      word: word,
      start: candidate.start,
      direction: candidate.direction,
    );

    crossword.add(wordEntry);
    wordPool.remove(wordEntry.word);

    final span = wordEntry.start.to(wordEntry.end);
    final expansion = {
      for (final location in span)
        WordCandidate(
          start: location,
          direction: wordEntry.direction == Direction.across
              ? Direction.down
              : Direction.across,
        ),
    };

    final topLeft = wordEntry.direction == Direction.across
        ? Location(
            x: wordEntry.start.x - wordPool.longestWordLength,
            y: wordEntry.start.y,
          )
        : Location(
            x: wordEntry.start.x,
            y: wordEntry.start.y - wordPool.longestWordLength,
          );
    final bottomRight = wordEntry.direction == Direction.across
        ? Location(
            x: wordEntry.end.x + wordPool.longestWordLength,
            y: wordEntry.end.y,
          )
        : Location(
            x: wordEntry.end.x,
            y: wordEntry.end.y + wordPool.longestWordLength,
          );
    final radius = topLeft.to(bottomRight);
    for (final location in radius) {
      final words = crossword.wordsAt(location);
      if (!words.any((word) => word.direction == Direction.across)) {
        expansion.add(
          WordCandidate(
            start: location,
            direction: Direction.across,
          ),
        );
      }
      if (!words.any((word) => word.direction == Direction.down)) {
        expansion.add(
          WordCandidate(
            start: location,
            direction: Direction.down,
          ),
        );
      }
    }
    expansion.removeWhere(closed.contains);
    frontier.addAll(expansion..removeWhere(closed.contains));

    placedWords++;
    if (placedWords % 200 == 0) {
      log('Placed $placedWords words');
    }
  }

  File('crossword.txt').writeAsStringSync(crossword.toPrettyString());
}
