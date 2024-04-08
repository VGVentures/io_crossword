// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/welcome/welcome.dart';

void main() {
  group('$WelcomeDataRequested', () {
    test('can be instantiated', () {
      expect(WelcomeDataRequested(), isA<WelcomeEvent>());
    });
  });
}
