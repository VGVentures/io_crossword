// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/team_selection/team_selection.dart';

void main() {
  group('TeamSelectionState', () {
    group('TeamSelectionState', () {
      test('supports value comparisons', () {
        expect(
          TeamSelectionState(),
          equals(TeamSelectionState()),
        );
      });

      test('returns a copy with updated values', () {
        expect(
          TeamSelectionState().copyWith(),
          equals(TeamSelectionState()),
        );
      });
    });
  });
}
