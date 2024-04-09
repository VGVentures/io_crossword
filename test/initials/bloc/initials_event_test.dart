// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/initials/initials.dart';

void main() {
  group('$InitialsBlocklistRequested', () {
    test('supports value equality', () {
      final event1 = InitialsBlocklistRequested();
      final event2 = InitialsBlocklistRequested();

      expect(event1, equals(event2));
    });
  });

  group('$InitialsSubmitted', () {
    test('supports value equality', () {
      final event1 = InitialsSubmitted('ABC');
      final event2 = InitialsSubmitted('ABC');
      final event3 = InitialsSubmitted('DEF');

      expect(event1, equals(event2));
      expect(event1, isNot(equals(event3)));
    });
  });
}
