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
      location: Location.zero,
      direction: Direction.down,
      constraints: const {0: 'a'},
    ),
  )!;
  log('Initial word: $initialWorld');

  final crossword = Crossword(
    bounds: Bounds.square(size: 100),
  )..add(
      WordEntry(
        word: initialWorld,
        start: Location(x: 0, y: 0 - (initialWorld.length ~/ 2)),
        direction: Direction.down,
      ),
    );

  var placedWords = 0;
  final area = Queue<Location>()..add(Location.zero);

  while (area.isNotEmpty && placedWords < 1000) {
    final location = area.removeFirst();
    final words = crossword.wordsAt(location);
    if (words.any((word) => word.direction == Direction.across) &&
        words.any((word) => word.direction == Direction.down)) {
      continue;
    }

    final wordCandidate = WordCandidate(
      location: location,
      direction: words.first.direction == Direction.across
          ? Direction.down
          : Direction.across,
    );
    final constrainedWordCandidate = crossword.constraints(wordCandidate);
    if (constrainedWordCandidate == null) continue;
    final candidate = wordPool.firstMatch(constrainedWordCandidate);
    if (candidate == null) continue;

    if (!constrainedWordCandidate.satisfies(candidate)) {
      log(constrainedWordCandidate.toString());
      log('firstMatch: $candidate');
      log('Does not satisfy constraints');
      continue;
    }

    final wordEntry = WordEntry(
      word: candidate,
      start: location,
      direction: wordCandidate.direction,
    );

    crossword.add(wordEntry);
    wordPool.remove(wordEntry.word);

    area.addAll(wordEntry.start.to(wordEntry.end));

    placedWords++;
    if (placedWords % 200 == 0) {
      log('Placed $placedWords words');
    }
  }

  File('crossword.txt').writeAsStringSync(crossword.toPrettyString());
}
