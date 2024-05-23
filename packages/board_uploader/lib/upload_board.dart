// ignore_for_file: avoid_print

import 'dart:io';

import 'package:board_uploader/src/crossword_repository.dart';
import 'package:csv/csv.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:game_domain/game_domain.dart';

void main(List<String> args) async {
  final serviceAccountPath =
      Platform.environment['GOOGLE_APPLICATION_CREDENTIALS'];
  if (serviceAccountPath == null) {
    throw Exception('Service account path not found');
  }

  final admin = FirebaseAdminApp.initializeApp(
    'io-crossword-dev',
    Credential.fromServiceAccount(File(serviceAccountPath)),
  );
  final firestore = Firestore(admin);
  final crosswordRepository = CrosswordRepository(firestore: firestore);

  // Read the file
  final fileString = File('assets/board.txt').readAsStringSync();
  final rows = const CsvToListConverter().convert(fileString);

  // Sort words by position to assign an ordered index
  // From left to right, top to bottom
  // ignore: cascade_invocations
  rows.sort((a, b) {
    final aX = a[0] as int;
    final aY = a[1] as int;
    final bX = b[0] as int;
    final bY = b[1] as int;

    if (aX == bX) {
      return aY.compareTo(bY);
    }

    return aX.compareTo(bX);
  });

  final words = <Word>[];
  final answersMap = <String, String>{};

  for (final (i, row) in rows.indexed) {
    final id = '${i + 1}';
    final answer = row[2] as String;
    answersMap[id] = answer;
    words.add(
      Word(
        id: id,
        position: Point(row[0] as int, row[1] as int),
        answer: Word.emptyCharacter * answer.length,
        clue: row[3] as String,
        axis: row[4] == WordAxis.horizontal.name
            ? WordAxis.horizontal
            : WordAxis.vertical,
      ),
    );
  }

  // Get crossword size
  final maxX = words
      .map((e) => e.position.x)
      .reduce((value, element) => value > element ? value : element);
  final maxY = words
      .map((e) => e.position.y)
      .reduce((value, element) => value > element ? value : element);
  final minX = words
      .map((e) => e.position.x)
      .reduce((value, element) => value < element ? value : element);
  final minY = words
      .map((e) => e.position.y)
      .reduce((value, element) => value < element ? value : element);

  final boardHeight = maxY - minY;
  final boardWidth = maxX - minX;

  print('Crossword size: $boardWidth x $boardHeight.');

  final wordsWithTopLeftOrigin = words.map((word) {
    final x = word.position.x - minX;
    final y = word.position.y - minY;
    return word.copyWith(position: Point(x, y));
  }).toList();

  final sections = <BoardSection>[];
  const sectionSize = 20;

  const minSectionX = 0;
  const minSectionY = 0;
  final maxSectionX = (boardWidth / sectionSize).ceil();
  final maxSectionY = (boardHeight / sectionSize).ceil();

  print('maxSectionX: $maxSectionX');
  print('maxSectionY: $maxSectionY');

  final answers = <Answer>[];

  final wordsSections = <Word, List<Point<int>>>{};

  for (var i = minSectionX; i < maxSectionX; i++) {
    for (var j = minSectionY; j < maxSectionY; j++) {
      final sectionX = i * sectionSize;
      final sectionY = j * sectionSize;
      final sectionWords = wordsWithTopLeftOrigin.where((word) {
        return word.isAnyLetterInSection(sectionX, sectionY, sectionSize);
      });

      final section = BoardSection(
        id: '',
        position: Point(i, j),
        // remove this field from model (size)
        size: sectionSize,
        words: sectionWords
            .map(
              (e) => e.copyWith(
                position:
                    Point(e.position.x - sectionX, e.position.y - sectionY),
              ),
            )
            .toList(),
        // remove this field from model (border words)
        borderWords: const [],
      );

      sections.add(section);

      // Answers
      for (final word in sectionWords) {
        final allLetters = word.allLetters;

        final sectionsPoint = word.getSections(sectionX, sectionY, sectionSize);

        if (!wordsSections.containsKey(word)) {
          wordsSections[word] = sectionsPoint;
        }

        final allWordsSections = <Word>{}
          ..addAll(
            [
              for (final section in sections
                  .where((section) => sectionsPoint.contains(section.position)))
                ...wordsWithTopLeftOrigin.where(
                  (word) {
                    return word.isAnyLetterInSection(
                      section.position.x * sectionSize,
                      section.position.y * sectionSize,
                      sectionSize,
                    );
                  },
                ),
            ],
          )
          ..remove(word);

        final collidedWords = <CollidedWord>[];

        for (final word in allWordsSections) {
          final collision = word
              .copyWith(answer: answersMap[word.id])
              .getCollision(allLetters);

          if (collision != null) {
            collidedWords.add(
              CollidedWord(
                character: collision.$2,
                position: collision.$1,
                wordId: word.id,
                sections: wordsSections[word] ??
                    word.getSections(
                      sectionX,
                      sectionY,
                      sectionSize,
                    ),
              ),
            );
          }
        }

        final index = answers.indexWhere((answer) => answer.id == word.id);

        if (index > -1) {
          answers[index] = Answer(
            id: word.id,
            answer: answersMap[word.id]!,
            sections: wordsSections[word]!,
            collidedWords: {
              ...answers[index].collidedWords,
              ...collidedWords,
            }.toList(),
          );
        } else {
          answers.add(
            Answer(
              id: word.id,
              answer: answersMap[word.id]!,
              sections: wordsSections[word]!,
              collidedWords: collidedWords,
            ),
          );
        }
      }
    }
  }

  print('Answers: ${answers.length}');
  print('AnswersMap: ${answersMap.length}');

  print('Uploading answers...');
  await crosswordRepository.addAnswers(answers);
  print('Added all answers to the database.');

  print('Uploading sections...');
  await crosswordRepository.addSections(sections);
  print('Added all ${sections.length} section to the database.');
}

/// An extension on [Word] to check if it is in a section or collision
/// of characters of words.
extension WordExtension on Word {
  /// Returns true if any of its letters is in the section.
  ///
  /// The [sectionX] and [sectionY] value is the absolute position in the board.
  bool isAnyLetterInSection(int sectionX, int sectionY, int sectionSize) {
    return allLetters
        .any((e) => _isInSection(e.$1, e.$2, sectionX, sectionY, sectionSize));
  }

  /// Returns all the sections that the word crosses with the relative index of
  /// the section based on the [sectionSize].
  ///
  /// The [sectionX] and [sectionY] value is the absolute position in the board.
  List<Point<int>> getSections(int sectionX, int sectionY, int sectionSize) {
    final sections = <Point<int>>[];

    switch (axis) {
      case WordAxis.horizontal:
        var i = 0;

        while (true) {
          final x = sectionX + (sectionSize * i);

          if (isAnyLetterInSection(x, sectionY, sectionSize)) {
            sections.add(
              Point(
                (x / sectionSize).floor(),
                (sectionY / sectionSize).floor(),
              ),
            );
          } else {
            break;
          }

          i++;
        }
      case WordAxis.vertical:
        var i = 0;

        while (true) {
          final y = sectionY + (sectionSize * i);

          if (isAnyLetterInSection(sectionX, y, sectionSize)) {
            sections.add(
              Point(
                (sectionX / sectionSize).floor(),
                (y / sectionSize).floor(),
              ),
            );
          } else {
            break;
          }

          i++;
        }
    }

    return sections;
  }

  /// Returns all the letter positions of the word.
  List<(int, int)> get allLetters {
    return axis == WordAxis.horizontal
        ? [
            for (var i = 0; i < length; i++) (position.x + i, position.y),
          ]
        : [
            for (var j = 0; j < length; j++) (position.x, position.y + j),
          ];
  }

  /// Returns true if the point is in the section.
  ///
  /// The [x], [y], [sectionX] and [sectionY] value is the absolute
  /// position in the board.
  bool _isInSection(int x, int y, int sectionX, int sectionY, int sectionSize) {
    return x >= sectionX &&
        x < sectionX + sectionSize &&
        y >= sectionY &&
        y < sectionY + sectionSize;
  }

  /// Returns the index position of the collision.
  /// If there are no collisions returns null.
  (int, String)? getCollision(List<(int, int)> letters) {
    switch (axis) {
      case WordAxis.horizontal:
        for (var i = 0; i < length; i++) {
          if (letters.contains((position.x + i, position.y))) {
            return (i, answer[i]);
          }
        }
      case WordAxis.vertical:
        for (var i = 0; i < length; i++) {
          if (letters.contains((position.x, position.y + i))) {
            return (i, answer[i]);
          }
        }
    }

    return null;
  }
}
