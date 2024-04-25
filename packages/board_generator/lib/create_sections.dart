// ignore_for_file: avoid_print

import 'dart:io';

import 'package:board_generator/src/crossword_repository.dart';
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
  final rows = const CsvToListConverter(eol: '\n').convert(fileString);

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
        length: answer.length,
        clue: row[3] as String,
        axis: row[4] == Axis.horizontal.name ? Axis.horizontal : Axis.vertical,
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

  final sections = <BoardSection>[];
  const sectionSize = 20;

  final minSectionX = (minX / sectionSize).floor();
  final maxSectionX = (maxX / sectionSize).ceil();
  final minSectionY = (minY / sectionSize).floor();
  final maxSectionY = (maxY / sectionSize).ceil();

  final answers = <Answer>[];

  for (var i = minSectionX; i < maxSectionX; i++) {
    for (var j = minSectionY; j < maxSectionY; j++) {
      final sectionX = i * sectionSize;
      final sectionY = j * sectionSize;
      final sectionWords = words.where((word) {
        return word.isStartInSection(sectionX, sectionY, sectionSize);
      }).toList();

      final borderWords = words.where((word) {
        final isStartInSection =
            word.isStartInSection(sectionX, sectionY, sectionSize);
        final isInSection =
            word.isAnyLetterInSection(sectionX, sectionY, sectionSize);
        return !isStartInSection && isInSection;
      }).toList();

      answers.addAll(
        sectionWords.map((word) {
          return Answer(
            id: word.id,
            answer: answersMap[word.id]!,
            section: Point(i, j),
          );
        }),
      );

      final section = BoardSection(
        id: '',
        position: Point(i, j),
        size: sectionSize,
        words: sectionWords,
        borderWords: borderWords,
      );

      // Add only sections that have words
      if (section.words.isNotEmpty || section.borderWords.isNotEmpty) {
        sections.add(section);
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

/// An extension on [Word] to check if it is in a section.
extension SectionBelonging on Word {
  /// Returns true if the word starting letter is in the section.
  bool isStartInSection(int sectionX, int sectionY, int sectionSize) {
    return position.x >= sectionX &&
        position.x < sectionX + sectionSize &&
        position.y >= sectionY &&
        position.y < sectionY + sectionSize;
  }

  /// Returns true if the word ending letter is in the section.
  bool isEndInSection(int sectionX, int sectionY, int sectionSize) {
    final (endX, endY) = axis == Axis.horizontal
        ? (position.x + length - 1, position.y)
        : (position.x, position.y + length - 1);
    return endX >= sectionX &&
        endX < sectionX + sectionSize &&
        endY >= sectionY &&
        endY < sectionY + sectionSize;
  }

  /// Returns true if any of its letters is in the section.
  bool isAnyLetterInSection(int sectionX, int sectionY, int sectionSize) {
    return allLetters
        .any((e) => _isInSection(e.$1, e.$2, sectionX, sectionY, sectionSize));
  }

  /// Returns all the letter positions of the word.
  List<(int, int)> get allLetters {
    return axis == Axis.horizontal
        ? [
            for (var i = 0; i < length; i++) (position.x + i, position.y),
          ]
        : [
            for (var j = 0; j < length; j++) (position.x, position.y + j),
          ];
  }

  /// Returns true if the point is in the section.
  bool _isInSection(int x, int y, int sectionX, int sectionY, int sectionSize) {
    return x >= sectionX &&
        x < sectionX + sectionSize &&
        y >= sectionY &&
        y < sectionY + sectionSize;
  }
}
