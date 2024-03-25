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
  final initialWordEntry = WordEntry(
    word: initialWorld,
    start: Location(x: 0, y: 0 - (initialWorld.length ~/ 2)),
    direction: Direction.down,
  );
  final crossword = Crossword()..add(initialWordEntry);

  var placedWords = 0;

  /// The locations that are yet to be explored.
  final area = Queue<Location>()
    ..addAll(
      const Location(x: 0, y: 1).to(initialWordEntry.end),
    );

  while (placedWords < 200) {
    if (area.isEmpty) {
      log('No more locations to place words');
      break;
    }

    final location = area.removeFirst();

    // If a position already has two words, it can't have more.
    final words = crossword.wordsAt(location);
    if (words.any((word) => word.direction == Direction.across) &&
        words.any((word) => word.direction == Direction.down)) {
      continue;
    }

    final wordCandidate = WordCandidate(
      location: location,
      // The new direction should be the opposite of the word that's
      // already there.
      direction: words.first.direction == Direction.across
          ? Direction.down
          : Direction.across,
    );
    final constrainedWordCandidate = crossword.constraints(wordCandidate);
    if (constrainedWordCandidate == null) continue;

    // TODO(Ayad): Don't let add the same name in bottom and top

    // while (constrainedWordCandidate.constraints.isNotEmpty) {
    final newWord = wordPool.firstMatch(constrainedWordCandidate);
    // if (newWord == null) break;
    if (newWord == null) continue;

    final newWordEntry = WordEntry(
      word: newWord,
      start: location,
      direction: wordCandidate.direction,
    );

    final symmetricalLocation = _horizontallySymmetricalLocation(newWordEntry);

    final symmetricalWordCandidate = WordCandidate(
      location: symmetricalLocation,
      direction: wordCandidate.direction,
    );
    final symmetricalConstrainedWordCandidate =
        crossword.constraints(symmetricalWordCandidate);
    if (symmetricalConstrainedWordCandidate == null) {
      final length = newWord.length;
      constrainedWordCandidate.invalidLengths.add(length);
      continue;
    }
    final symmetricalNewWord =
        wordPool.firstMatch(symmetricalConstrainedWordCandidate);
    if (symmetricalNewWord == null) {
      final length = newWord.length;
      constrainedWordCandidate.invalidLengths.add(length);
      continue;
    }

    final symmetricalNewWordEntry = WordEntry(
      word: symmetricalNewWord,
      start: _horizontallySymmetricalLocation(newWordEntry),
      direction: wordCandidate.direction,
    );

    if (crossword.overlaps(newWordEntry)) {
      // TODO(Ayad): Investigate, this should not be reached. Investigate constraints and selection.
      print('pass 2');
      continue;
    }

    if (crossword.overlaps(symmetricalNewWordEntry)) {
      // TODO(Ayad): Investigate, this should not be reached. Investigate constraints and selection.
      print('pass');
      continue;
    }

    crossword
      ..add(newWordEntry)
      ..add(symmetricalNewWordEntry);
    wordPool
      ..remove(newWord)
      ..remove(symmetricalNewWord);
    area.addAll(location.to(newWordEntry.end));

    print(placedWords);

    placedWords += 2;
    if (placedWords % 200 == 0) {
      log('Placed $placedWords words');
    }

    //   break;
    // }
  }

  File('symmetrical_crossword.txt')
      .writeAsStringSync(crossword.toPrettyString());
}

Location _horizontallySymmetricalLocation(WordEntry wordEntry) {
  switch (wordEntry.direction) {
    case Direction.across:
      return wordEntry.start.copyWith(y: wordEntry.end.y * -1);
    case Direction.down:
      return wordEntry.end.copyWith(y: wordEntry.end.y * -1);
  }
}
