// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/random_word_selection/bloc/random_word_selection_bloc.dart';

void main() {
  group('$RandomWordSelectionEvent', () {
    group('$RandomWordRequested', () {
      test('supports equality', () {
        expect(
          RandomWordRequested(),
          equals(RandomWordRequested()),
        );
      });
    });
  });
}
