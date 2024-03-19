import 'package:board_generator_playground/src/models/models.dart';

class WordEntry {
  const WordEntry({
    required this.word,
    required this.location,
    required this.direction,
  });

  final String word;
  final Location location;
  final Direction direction;
}
