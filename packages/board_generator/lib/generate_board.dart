import 'dart:convert';
import 'dart:io';

import 'package:board_generator/src/board_generator.dart';

void main(List<String> args) async {
  final file = File('assets/allWords.json');

  final string = await file.readAsString();
  final map = jsonDecode(string) as Map<String, dynamic>;
  final words =
      (map['words'] as List<dynamic>).map((e) => e as Map<String, dynamic>);
  final parsedWords = words.map((word) {
    return word['answer'] as String;
  }).toList();

  final regex = RegExp(r'^[a-z]+$');
  final filteredWords = [...parsedWords]..removeWhere(
      (element) => !regex.hasMatch(element),
    );

  generateCrossword(filteredWords, 'assets/board.txt');
}
