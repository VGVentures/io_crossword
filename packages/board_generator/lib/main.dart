import 'package:board_generator/board_generator.dart';

/// The list of all words that can be used to generate a crossword.
final allWords = [
  'winter',
  'spring',
  'summer',
];

void main(List<String> args) {
  final iter = generateCrosswords(allWords);
  final completeCrossword = iter.last;

  // ignore: avoid_print
  print(completeCrossword);
}
