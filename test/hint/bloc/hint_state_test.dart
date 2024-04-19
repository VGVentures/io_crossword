// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:io_crossword/hint/bloc/hint_bloc.dart';

void main() {
  group('$HintState', () {
    test('supports equality', () {
      expect(
        HintState(status: HintStatus.asking),
        equals(HintState(status: HintStatus.asking)),
      );
    });

    group('copyWith', () {
      test('returns equivalent object when no properties are passed', () {
        final state = HintState(status: HintStatus.asking);
        expect(state.copyWith(), equals(state));
      });

      test('returns object with updated status when status is passed', () {
        final state = HintState(status: HintStatus.asking);
        expect(
          state.copyWith(status: HintStatus.thinking),
          equals(HintState(status: HintStatus.thinking)),
        );
      });
    });
  });
}
