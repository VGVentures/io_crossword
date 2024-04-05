import 'dart:ui';

import 'package:io_crossword/crossword/game/section_component/models/models.dart';

class WordIndex {
  WordIndex({
    required this.id,
    required this.color,
    required this.batchPosition,
  });

  // Id of the word
  final String id;

  // Color of the word
  final Color color;

  // Batch position of the word
  final WordBatchPosition batchPosition;
}
