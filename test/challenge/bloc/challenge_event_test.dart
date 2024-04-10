// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/challenge/challenge.dart';

void main() {
  group('$ChallengeDataRequested', () {
    test('can be instantiated', () {
      expect(ChallengeDataRequested(), isA<ChallengeEvent>());
    });

    test('supports value equality', () {
      expect(ChallengeDataRequested(), ChallengeDataRequested());
    });
  });
}
