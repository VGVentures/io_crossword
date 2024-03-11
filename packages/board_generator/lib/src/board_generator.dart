// ignore_for_file: avoid_print

import 'dart:io';

import 'package:board_generator/src/models/data_model.dart';
import 'package:game_domain/game_domain.dart';

/// Generates a crossword.
Crossword generateCrossword(List<String> wordList, String filePath) {
  var crossword = Crossword((b) => b..candidates.addAll(wordList)).generate();

  final before = DateTime.now();

  final file = File(filePath);
  final savedDownWords = <Location, String>{};
  final savedAcrossWords = <Location, String>{};

  while (crossword.candidates.isNotEmpty) {
    crossword = crossword.generate();

    // Save the words to a file. Only save every 100 words to avoid
    // slowing down the process.
    final wordCount = crossword.downWords.length + crossword.acrossWords.length;
    if ((wordCount % 100 == 0) || (wordCount == wordList.length)) {
      final now = DateTime.now();

      print('Generated $wordCount words in ${now.difference(before)}');
      print('Candidate locations: ${crossword.candidateLocations.length}');

      final newAcrossWords = crossword.acrossWords.rebuild(
        (b) =>
            b..removeWhere((key, value) => savedAcrossWords.containsKey(key)),
      );
      final newDownWords = crossword.downWords.rebuild(
        (b) => b..removeWhere((key, value) => savedDownWords.containsKey(key)),
      );

      final buffer = StringBuffer();
      for (final entry in newAcrossWords.entries) {
        buffer.writeln(
          '${entry.key.across},${entry.key.down},${entry.value},'
          '${Axis.horizontal.name}',
        );
      }
      for (final entry in newDownWords.entries) {
        buffer.writeln(
          '${entry.key.across},${entry.key.down},${entry.value},'
          '${Axis.vertical.name}',
        );
      }

      file.writeAsStringSync(buffer.toString(), mode: FileMode.append);

      savedAcrossWords.addAll(newAcrossWords.asMap());
      savedDownWords.addAll(newDownWords.asMap());
    }
  }

  return crossword;
}
