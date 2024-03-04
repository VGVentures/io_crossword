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
  final fileString = File('board.txt').readAsStringSync();
  final rows = const CsvToListConverter(eol: '\n').convert(fileString);

  // Convert to custom object
  final words = rows.map((row) {
    return Word(
      position: Point(row[0] as int, row[1] as int),
      answer: row[2] as String,
      clue: 'The answer is: ${row[2]}',
      hints: const [],
      visible: false,
      axis: row[3] == 'horizontal' ? Axis.horizontal : Axis.vertical,
      solvedTimestamp: null,
    );
  }).toList();

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
  const sectionSize = 300;

  var sectionX = minX;
  while (sectionX < maxX) {
    var sectionY = minY;
    while (sectionY < maxY) {
      final sectionWords = words.where((word) {
        final isStartInSection = word.position.x >= sectionX &&
            word.position.x < sectionX + sectionSize &&
            word.position.y >= sectionY &&
            word.position.y < sectionY + sectionSize;
        return isStartInSection;
      }).toList();

      final borderWords = words.where((word) {
        final isStartInSection = word.position.x >= sectionX &&
            word.position.x < sectionX + sectionSize &&
            word.position.y >= sectionY &&
            word.position.y < sectionY + sectionSize;
        final endX = word.axis == Axis.horizontal
            ? word.position.x + word.answer.length - 1
            : word.position.x;
        final endY = word.axis == Axis.vertical
            ? word.position.y + word.answer.length - 1
            : word.position.y;
        final isEndInSection = endX >= sectionX &&
            endX < sectionX + sectionSize &&
            endY >= sectionY &&
            endY < sectionY + sectionSize;
        return !isStartInSection && isEndInSection;
      }).toList();

      final section = BoardSection(
        id: '',
        position: Point(sectionX, sectionY),
        size: sectionSize,
        words: sectionWords,
        borderWords: borderWords,
      );
      sections.add(section);

      sectionY += sectionSize;
    }
    sectionX += sectionSize;
  }

  await crosswordRepository.addSections(sections);
  // await crosswordRepository.deleteSections();

  print('Added all ${sections.length} section to the database.');
}
