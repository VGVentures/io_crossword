import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword_ui/src/theme/teams/teams.dart';

void main() {
  group('$IoChromeTheme', () {
    test('themeData returns normally', () {
      expect(() => IoChromeTheme.themeData, returnsNormally);
    });
  });
}
