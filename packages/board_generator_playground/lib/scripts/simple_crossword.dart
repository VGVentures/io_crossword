import 'dart:io';
import 'dart:math' as math;

import 'package:board_generator_playground/src/crossword.dart';
import 'package:board_generator_playground/src/models/models.dart';
import 'package:board_generator_playground/src/word_pool.dart';
import 'package:csv/csv.dart';

final _random = math.Random(0);

void main({
  void Function(String) log = print,
}) {
  final fileString = File('words.csv').readAsStringSync();
  final lines = const CsvToListConverter(eol: '\n').convert(fileString)
    ..removeAt(0);

  final pool = <String>{
    for (final line in lines) line[0] as String,
  };
  final longestWord = pool.reduce(
      (value, element) => value.length > element.length ? value : element);
  log('Longest word is $longestWord with ${longestWord.length} characters');
  final smallestWord = pool.reduce(
      (value, element) => value.length < element.length ? value : element);
  log('Smallest word $smallestWord with ${smallestWord.length} characters');

  log('Sorting ${pool.length} words');
  final wordPool = WordPool(
    words: pool,
    maxLengthWord: longestWord.length,
    minLengthWord: smallestWord.length,
  );
  log('Sorted ${pool.length} words');

  final initialWorld = wordPool.sortedWords[17]![0]!['a']!.first;
  print('Initial word: $initialWorld');

  final crossword = Crossword()
    ..add(
      WordEntry(
        word: initialWorld,
        start: Location(x: 0, y: 0 - (initialWorld.length ~/ 2)),
        direction: Direction.down,
      ),
    );

  final leafs = <Location>{};
  var placedWords = 0;

  while (placedWords < 100) {
    final locations = crossword.characterMap.keys.toSet()..removeAll(leafs);
    if (locations.isEmpty) {
      log('No more locations to place words');
      break;
    }

    final location = locations.elementAt(_random.nextInt(locations.length));
    final words = crossword.wordsAt(location);
    if (words.any((word) => word.direction == Direction.across) &&
        words.any((word) => word.direction == Direction.down)) {
      leafs.add(location);
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
      leafs.add(location);
      continue;
    }

    final candidate = wordPool.firstMatch(constrainedWordCandidate);

    if (candidate == null) {
      leafs.add(location);
      continue;
    }

    final wordEntry = WordEntry(
      word: candidate,
      start: location,
      direction: wordCandidate.direction,
    );
    crossword.add(wordEntry);
    wordPool.remove(wordEntry.word);

    placedWords++;
    if (placedWords % 200 == 0) {
      log('Placed $placedWords words');
    }
  }

  File('crossword.txt').writeAsStringSync(crossword.toPrettyString());
}
