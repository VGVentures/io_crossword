import 'dart:ui';

import 'package:io_crossword/crossword/game/section_component/models/models.dart';

class WordIndex {
  WordIndex({
    required this.id,
    required this.color,
    required this.batchPosition,
  });

  final String id;
  final Color color;
  final WordBatchPosition batchPosition;
}
