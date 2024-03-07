import 'dart:convert';
import 'dart:io';

import 'package:game_domain/game_domain.dart';

List<BoardSection> getTestSections() {
  final fileString = File('assets/test/test_board.json').readAsStringSync();
  final jsonList = jsonDecode(fileString) as List<dynamic>;
  return jsonList.indexed.map((e) {
    final jsonData = e.$2 as Map<String, dynamic>;
    jsonData['id'] = e.$1.toString();
    return BoardSection.fromJson(jsonData);
  }).toList();
}
